from flask import Flask, request, jsonify, session
from flask_cors import CORS
import requests
import json
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import google.generativeai as genai
from datetime import datetime
import uuid
import os

# -------------------------
# API Keys (set here)
# -------------------------


# Initialize Flask app
app = Flask(__name__)
DATA_GOV_API_KEY = "579b464db66ec23bdd000001fe95bc66760b464d7a1818e91d5e51d8"
GEMINI_API_KEY = ""
# Configure CORS to allow Flutter app to communicate with this server
CORS(app, resources={r"/api/*": {"origins": "*"}}, supports_credentials=True)

# Initialize Gemini client
genai.configure(api_key=GEMINI_API_KEY)
gemini_model = genai.GenerativeModel('gemini-2.0-flash')

# Global variables for KCC data and embeddings
kcc_texts = []
kcc_embeddings = None
embedding_model = None

# -------------------------
# Simple Memory Class (same as before)
# -------------------------
class SimpleMemory:
    def _init_(self):
        self.conversations = []  # List of {query, response, timestamp}
        self.farmer_context = {}  # Dict to store farmer details

    def add_conversation(self, query, response, used_kcc=False):
        """Add a conversation to memory"""
        self.conversations.append({
            'query': query,
            'response': response,
            'used_kcc': used_kcc,
            'timestamp': datetime.now().strftime("%H:%M")
        })

    def get_recent_conversations(self, limit=3):
        """Get last N conversations"""
        return self.conversations[-limit:] if self.conversations else []

    def set_farmer_context(self, **kwargs):
        """Store farmer details like name, crops, location etc."""
        self.farmer_context.update(kwargs)

    def get_farmer_context(self):
        """Get stored farmer context"""
        return self.farmer_context

    def get_conversation_summary(self):
        """Get a summary of conversation topics"""
        if not self.conversations:
            return "No previous conversations"

        topics = []
        for conv in self.conversations[-3:]:  # Last 3 conversations
            # Extract key topics from queries
            query = conv['query'].lower()
            if any(word in query for word in ['disease', 'pest', 'insect', 'fungus']):
                topics.append("disease/pest issues")
            elif any(word in query for word in ['fertilizer', 'urea', 'nutrient']):
                topics.append("fertilizer advice")
            elif any(word in query for word in ['price', 'market', 'sell']):
                topics.append("market/pricing")
            elif any(word in query for word in ['water', 'irrigation', 'rain']):
                topics.append("water management")
            elif any(word in query for word in ['crop', 'variety', 'seed']):
                topics.append("crop selection")
            else:
                topics.append("general farming")

        return ", ".join(set(topics))  # Remove duplicates

# In-memory storage for user sessions (in production, use Redis or database)
user_sessions = {}

# -------------------------
# KCC Data Functions
# -------------------------
def fetch_kcc_data(limit=1000):
    url = "https://api.data.gov.in/resource/cef25fe2-9231-4128-8aec-2c948fedd43f"
    params = {
        "api-key": DATA_GOV_API_KEY,
        "format": "json",
        "limit": limit
    }
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        return data.get("records", [])
    except Exception as e:
        print(f"Error loading dataset: {e}")
        return []

def prepare_embeddings(records):
    model = SentenceTransformer('all-MiniLM-L6-v2')
    texts = []
    for rec in records:
        q = rec.get("QueryText", "")
        a = rec.get("KccAns", "")
        combined = f"Q: {q}\nA: {a}"
        texts.append(combined)
    embeddings = model.encode(texts, convert_to_numpy=True)
    return texts, embeddings, model

def retrieve_context(query, texts, embeddings, model, top_n=5, threshold=0.5):
    query_emb = model.encode([query], convert_to_numpy=True)
    sims = cosine_similarity(query_emb, embeddings)[0]
    top_indices = sims.argsort()[::-1][:top_n]
    retrieved = []
    used_kcc = False
    for idx in top_indices:
        if sims[idx] >= threshold:
            retrieved.append(texts[idx])
            used_kcc = True
    return retrieved, used_kcc

def generate_prompt_with_memory(user_query, context_text, memory):
    # Get farmer context
    farmer_info = memory.get_farmer_context()

    # Get recent conversations
    recent_convs = memory.get_recent_conversations(3)

    # Get conversation topics summary
    topics_discussed = memory.get_conversation_summary()

    # Build farmer context string
    farmer_context = ""
    if farmer_info:
        farmer_context = "## Farmer Information:\n"
        if farmer_info.get('name'):
            farmer_context += f"Name: {farmer_info['name']}\n"
        if farmer_info.get('location'):
            farmer_context += f"Location: {farmer_info['location']}\n"
        if farmer_info.get('crops'):
            farmer_context += f"Main Crops: {farmer_info['crops']}\n"
        if farmer_info.get('farm_size'):
            farmer_context += f"Farm Size: {farmer_info['farm_size']}\n"
        farmer_context += "\n"

    # Build conversation history string
    history_context = ""
    if recent_convs:
        history_context = "## Recent Questions in This Session:\n"
        for i, conv in enumerate(recent_convs[-2:], 1):  # Last 2 conversations only
            history_context += f"{i}. Previous Question: {conv['query']}\n"
            history_context += f"   My Previous Advice: {conv['response'][:150]}...\n\n"

        history_context += f"Topics we've discussed today: {topics_discussed}\n\n"

    prompt = f"""
# KisaanSetu AI Assistant with Session Memory

You are KisaanSetu AI Assistant, an expert agricultural advisor for Indian farmers. You remember our conversation within this session and can reference previous questions and advice.

## Core Functionality
- Use relevant current/forecasted weather if applicable.
- Deliver clear, actionable advice that can be implemented immediately.
- Use affordable and practical techniques when possible.
- Provide product recommendations only if necessary, with clear instructions.
- Reference previous conversations when relevant and build upon earlier advice.

## Response Guidelines
- Respond in English using simple, conversational language.
- Keep answers concise: 3-5 key points max.
- Use numbered steps for instructions.
- Avoid jargon unless explained.

## Examples of Good vs Bad Responses

### Example 1: Crop Disease Query
*Query*: "My tomato plants have yellow leaves and black spots. What should I do?"

*❌ BAD Response:*
"Your tomatoes might have early blight or late blight disease caused by fungal pathogens like Alternaria solani or Phytophthora infestans. You need to apply fungicides immediately."

*✅ GOOD Response:*
"This sounds like blight disease in tomatoes. Here's what to do immediately:

1. Remove affected leaves: Cut and burn all yellow/spotted leaves to stop spread
2. Apply neem oil spray: Mix 30ml neem oil + 1 tsp soap in 1 liter water, spray in evening
3. Improve air circulation: Space plants properly, remove lower branches touching soil
4. Stop overhead watering: Water at soil level only to keep leaves dry
5. Apply copper sulfate: If available, spray 2g per liter water every 7 days

Cost: 50-100 rupees for neem oil treatment. Prevention: Plant disease-resistant varieties next season."

### Example 2: Fertilizer Query
*Query*: "When should I apply urea to my wheat crop?"

*❌ BAD Response:*
"Apply urea fertilizer according to soil test recommendations and crop growth stage requirements for optimal nitrogen uptake efficiency."

*✅ GOOD Response:*
"For wheat, apply urea in 3 splits for best results:

1. At sowing (November): 1/3 of total urea (about 65 kg/hectare)
2. First irrigation (35-40 days): 1/3 of total urea
3. Second irrigation (65-70 days): Remaining 1/3 urea

Timing tip: Apply urea just before irrigation, not during rain. Mix with soil lightly.
Local measurement: 1 bigha = about 13 kg urea total
Cost saving: Buy during subsidy period (usually 266 rupees per bag vs 350+ later)"

### Example 3: Market Price Query
*Query*: "What's the current price of onions?"

*❌ BAD Response:*
"Onion prices fluctuate based on market dynamics, supply-demand factors, and seasonal variations across different mandis."

*✅ GOOD Response:*
"I don't have access to real-time market prices, but here's how to get current rates:

1. Check eNAM portal: nafed.india.gov.in for daily mandi prices
2. Call local mandi: Your nearest APMC will have today's rates
3. WhatsApp groups: Join local farmer groups for price updates

Recent trend info (if available in context): Based on KCC data, onion prices typically peak in May-July.
Selling tip: Grade your onions - A-grade gets 5-8 rupees per kg more than mixed quality."

## What Makes Responses Good:
- Specific numbers: Quantities, costs, timing
- Local context: Indian measurements (bigha, hectare), rupees, local practices
- Step-by-step action: Clear numbered instructions
- Cost information: Actual prices or price ranges
- Prevention tips: How to avoid the problem next time
- Alternative solutions: Multiple options when possible

## What Makes Responses Bad:
- Vague advice: "Apply as needed", "consult expert"
- Technical jargon: Scientific names without explanation
- No quantities: "Apply fertilizer" without amounts
- No cost info: Expensive solutions without mentioning cost
- Complex language: Academic or scientific terminology
- Irrelevant information: General advice not specific to query

## CRITICAL FORMATTING RULE:
DO NOT use asterisks (*), markdown formatting, or special symbols in your response. Use plain text only with clear, simple formatting like colons and numbered lists.

{farmer_context}{history_context}## Context from KCC Records
{context_text}

## Current Question
{user_query}

## Advanced Instructions:
- For crop health issues: identify likely causes, suggest low-cost or organic solutions, preventive measures.
- For market advice: provide local MSP, mandis, realistic price ranges, and timing recommendations.
- For input recommendations: specify quantities, local measurements, and any available government schemes.
- For water management: suggest irrigation schedules and water conservation techniques.
- For technology adoption: suggest feasible technologies considering local availability, cost, and skill requirements.
- If this question relates to previous advice from our conversation, acknowledge that connection and build upon it.
- If farmer mentions success ("it worked", "problem is solved"), congratulate and provide next steps.

*Important*: Follow the GOOD response pattern shown in examples above. Be specific, practical, and cost-conscious. If you don't know something specific, clearly state "I don't know" and provide alternative ways to find the information.
"""

    return prompt

def generate_answer(prompt):
    response = gemini_model.generate_content(contents=[prompt])
    answer = ""
    for part in response.candidates[0].content.parts:
        if part.text:
            answer += part.text
    return answer

# -------------------------
# Flask API Endpoints
# -------------------------

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "service": "KisaanSetu AI Assistant",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/api/start-session', methods=['POST'])
def start_session():
    """Start a new farmer session"""
    try:
        data = request.get_json()

        # Generate session ID
        session_id = str(uuid.uuid4())[:8]

        # Create new memory for this session
        memory = SimpleMemory()

        # Set farmer context if provided
        if data:
            memory.set_farmer_context(**data)

        # Store session
        user_sessions[session_id] = memory

        return jsonify({
            "success": True,
            "session_id": session_id,
            "message": f"Session started for {data.get('name', 'farmer')}",
            "farmer_context": memory.get_farmer_context()
        })

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

@app.route('/api/ask', methods=['POST'])
def ask_question():
    """Main endpoint to ask farming questions"""
    try:
        data = request.get_json()

        # Validate request
        if not data or 'query' not in data:
            return jsonify({
                "success": False,
                "error": "Query is required"
            }), 400

        query = data['query'].strip()
        session_id = data.get('session_id')

        # Get or create session
        if session_id and session_id in user_sessions:
            memory = user_sessions[session_id]
        else:
            # Create new session if none exists
            memory = SimpleMemory()
            session_id = str(uuid.uuid4())[:8]
            user_sessions[session_id] = memory

            # Set farmer context if provided
            farmer_info = data.get('farmer_info', {})
            if farmer_info:
                memory.set_farmer_context(**farmer_info)


        # Check if KCC data is loaded
        global kcc_texts, kcc_embeddings, embedding_model
        if not kcc_texts:
            return jsonify({
                "success": False,
                "error": "KCC data not loaded. Please restart the service."
            }), 500

        # Retrieve relevant context
        retrieved_contexts, used_kcc = retrieve_context(
            query, kcc_texts, kcc_embeddings, embedding_model
        )
        context_text = "\n".join(retrieved_contexts) if retrieved_contexts else "No relevant KCC records found."

        # Generate prompt with memory
        prompt = generate_prompt_with_memory(query, context_text, memory)

        # Generate answer
        answer = generate_answer(prompt)

        # Save conversation to memory
        memory.add_conversation(query, answer, used_kcc)

        # Prepare response
        response = {
            "success": True,
            "session_id": session_id,
            "query": query,
            "answer": answer,
            "used_kcc_context": used_kcc,
            "conversation_count": len(memory.conversations),
            "farmer_context": memory.get_farmer_context(),
            "topics_discussed": memory.get_conversation_summary()
        }

        return jsonify(response)

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

@app.route('/api/get-history', methods=['GET'])
def get_conversation_history():
    """Get conversation history for a session"""
    try:
        session_id = request.args.get('session_id')

        if not session_id or session_id not in user_sessions:
            return jsonify({
                "success": False,
                "error": "Invalid session ID"
            }), 400

        memory = user_sessions[session_id]
        history = memory.get_recent_conversations(10)  # Get last 10 conversations

        return jsonify({
            "success": True,
            "session_id": session_id,
            "conversation_history": history,
            "farmer_context": memory.get_farmer_context(),
            "topics_discussed": memory.get_conversation_summary()
        })

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

@app.route('/api/update-profile', methods=['POST'])
def update_farmer_profile():
    """Update farmer profile information"""
    try:
        data = request.get_json()
        session_id = data.get('session_id')

        if not session_id or session_id not in user_sessions:
            return jsonify({
                "success": False,
                "error": "Invalid session ID"
            }), 400

        memory = user_sessions[session_id]

        # Update farmer context
        farmer_info = {k: v for k, v in data.items() if k != 'session_id'}
        memory.set_farmer_context(**farmer_info)

        return jsonify({
            "success": True,
            "message": "Profile updated successfully",
            "farmer_context": memory.get_farmer_context()
        })

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

@app.route('/api/get-sessions', methods=['GET'])
def get_active_sessions():
    """Get list of active sessions (for debugging)"""
    try:
        sessions_info = {}
        for session_id, memory in user_sessions.items():
            sessions_info[session_id] = {
                "farmer_context": memory.get_farmer_context(),
                "conversation_count": len(memory.conversations),
                "topics_discussed": memory.get_conversation_summary()
            }

        return jsonify({
            "success": True,
            "active_sessions": len(user_sessions),
            "sessions": sessions_info
        })

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

# -------------------------
# Initialize KCC Data on Startup
# -------------------------
def initialize_kcc_data():
    """Load and prepare KCC data on app startup"""
    global kcc_texts, kcc_embeddings, embedding_model

    print("Loading KCC dataset...")
    records = fetch_kcc_data(limit=1000)

    if records:
        print(f"Loaded {len(records)} KCC records.")
        kcc_texts, kcc_embeddings, embedding_model = prepare_embeddings(records)
        print("KCC embeddings prepared successfully!")
    else:
        print("Warning: No KCC data loaded!")

# -------------------------
# Run Flask App
# -------------------------
if _name_ == '_main_':
    # Initialize KCC data
    initialize_kcc_data()

    # Run Flask app
    print("Starting KisaanSetu API Server...")
    print("API Endpoints available:")
    print("- POST /api/start-session - Start new farmer session")
    print("- POST /api/ask - Ask farming questions")
    print("- GET /api/get-history - Get conversation history")
    print("- POST /api/update-profile - Update farmer profile")
    print("- GET /health - Health check")

    app.run(debug=True, host='0.0.0.0', port=5000)