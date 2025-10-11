// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/news_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class NewsApiService {
//   static String get apiKey => dotenv.env['NEWS_API_KEY'] ?? '9914b00bb34f7028b046b8586de86393';
//   static const String baseUrl = "https://gnews.io/api/v4/search";

//   // Fetch filtered news based on the selected category
//   Future<List<NewsArticle>> fetchFilteredNews(String selectedCategory) async {
//     // Define category-specific search terms with more focused agricultural keywords
//     final Map<String, String> categoryKeywords = {
//       "All": "agriculture farming crop harvest",
//       "Crops": "rice wheat sugarcane pulses cotton millet crop",
//       "Technology": "farm mechanization drip irrigation precision agriculture smart farming agri-tech",
//       "Weather": "monsoon kharif rabi drought rainfall farming",
//       "Organic": "organic farming natural pesticides vermicompost sustainable agriculture zero budget jaivik kheti",
//       "Market": "mandi prices agricultural export MSP farmer market commodity e-NAM",
//     };

//     // Get keywords based on selected category
//     final String query = categoryKeywords[selectedCategory] ?? categoryKeywords["All"]!;

//     // Add India-specific filtering for GNews API
//     // Format: baseUrl?q=query&lang=en&country=in&max=10&apikey=apiKey
//     final String url =
//         "$baseUrl?q=($query) India farmer&lang=en&country=in&max=10&apikey=$apiKey";

//     print("Fetching news for category: $selectedCategory from URL: $url"); // Debugging

//     try {
//       final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 15));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey('articles') && data['articles'] is List && data['articles'].isNotEmpty) {
//           final List articles = data['articles'];
//           final List<NewsArticle> newsArticles = articles.map((json) => NewsArticle.fromJson(json)).toList();
          
//           // Filter out non-agricultural content by checking for relevant keywords in title or description
//           final filteredArticles = _filterAgricultureRelevantNews(newsArticles);
          
//           if (filteredArticles.isEmpty) {
//             print("No agriculture news found after filtering");
//           } else {
//             print("Found ${filteredArticles.length} agriculture news articles");
//           }
          
//           return filteredArticles;
//         } else {
//           print("No articles found in API response: ${response.body}");
//           return [];
//         }
//       } else if (response.statusCode == 403 || response.statusCode == 401) {
//         print("API key error: ${response.statusCode}, Response: ${response.body}");
//         throw Exception('API key error. Please check your GNews API key.');
//       } else if (response.statusCode == 429) {
//         print("Rate limit exceeded: ${response.statusCode}, Response: ${response.body}");
//         throw Exception('Rate limit exceeded. Please try again later.');
//       } else {
//         print("API error: ${response.statusCode}, Response: ${response.body}");
//         throw Exception('Failed to load news: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Exception when fetching news: $e");
//       throw Exception('Error fetching news: $e');
//     }
//   }
  
//   // Additional method to filter news for agriculture relevance
//   List<NewsArticle> _filterAgricultureRelevantNews(List<NewsArticle> articles) {
//     // Core agriculture keywords to check for relevance
//     final List<String> coreAgriKeywords = [
//       'agriculture', 'farming', 'crop', 'harvest', 'farmer', 
//       'soil', 'irrigation', 'pesticide', 'fertilizer', 'seed',
//       'cultivation', 'livestock', 'dairy', 'organic', 'sustainable',
//       'monsoon', 'drought', 'yield', 'kisan', 'farm', 'food',
//       'mandi', 'agri-tech', 'horticulture', 'agronomy'
//     ];
    
//     // Indian specific keywords
//     final List<String> indianKeywords = [
//       'india', 'indian', 'bharat', 'bharatiya', 'kisan', 
//       'pradhan mantri', 'msp', 'minimum support price', 'niti aayog',
//       'maharashtra', 'punjab', 'haryana', 'uttar pradesh', 'madhya pradesh',
//       'gujarat', 'rajasthan', 'bihar', 'west bengal', 'karnataka', 'tamil nadu',
//       'rural', 'village', 'gram', 'panchayat', 'krishi'
//     ];
    
//     // Keywords related to farmer benefits
//     final List<String> benefitKeywords = [
//       'subsidy', 'loan', 'scheme', 'income', 'profit', 'technology',
//       'innovation', 'support', 'price', 'market', 'export', 'training',
//       'education', 'weather', 'forecast', 'insurance', 'credit', 'relief',
//       'development', 'improvement', 'productivity', 'efficiency', 'solution'
//     ];

//     // Filter articles that contain agriculture keywords
//     final filteredArticles = articles.where((article) {
//       final title = article.title?.toLowerCase() ?? '';
//       final description = article.description?.toLowerCase() ?? '';
//       final content = title + ' ' + description;
      
//       // Check if content contains any agriculture keyword
//       bool hasAgriKeyword = coreAgriKeywords.any((keyword) => 
//         content.contains(keyword.toLowerCase()));
      
//       // Check if content contains any Indian keyword
//       bool hasIndianKeyword = indianKeywords.any((keyword) => 
//         content.contains(keyword.toLowerCase()));
        
//       // Check if content contains any benefit keyword
//       bool hasBenefitKeyword = benefitKeywords.any((keyword) => 
//         content.contains(keyword.toLowerCase()));
      
//       // Return true if content has agriculture relevance AND either Indian context OR farmer benefit
//       return hasAgriKeyword && (hasIndianKeyword || hasBenefitKeyword);
//     }).toList();
    
//     // If filtering results in no articles, return the original list to prevent empty display
//     return filteredArticles.isNotEmpty ? filteredArticles : articles;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String apiKey =
      "5a81b673171f4a339728a27500a2dc53"; // Replace with your actual API key
  static const String baseUrl = "https://newsapi.org/v2/everything";

  // Fetch filtered news based on the selected category
  Future<List<NewsArticle>> fetchFilteredNews(String selectedCategory) async {
    // Define category-specific search terms
    final Map<String, String> categoryKeywords = {
      "All":
          "agriculture OR farming OR crops OR agritech OR pesticides OR irrigation",
      "Crops": "crops OR plantation OR harvest OR yield OR farming",
      "Farming Tech":
          "agritech OR precision farming OR smart agriculture OR AI in farming",
      "Weather":
          "agriculture weather OR monsoon OR drought OR rainfall OR climate change",
      "Organic Farming":
          "organic farming OR natural farming OR sustainable agriculture",
      "Market Trends":
          "agriculture market OR crop prices OR MSP OR agri business",
    };

    // Get keywords based on selected category
    final String query =
        categoryKeywords[selectedCategory] ?? categoryKeywords["All"]!;

    final String url =
        "$baseUrl?q=agriculture OR farming OR crops OR livestock&language=en&sortBy=publishedAt&apiKey=$apiKey&domains=thehindu.com,indianexpress.com,agriguru.in,krishijagran.com";

    print(
      "Fetching news for category: $selectedCategory from URL: $url",
    ); // Debugging

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('articles')) {
        final List articles = data['articles'];
        return articles.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}
