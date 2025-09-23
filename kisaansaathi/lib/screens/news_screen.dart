import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_api_service.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = true;
  String _selectedCategory = "All";

  // Farming keywords
  final List<String> _farmingKeywords = [
    "farming", "agriculture", "crop", "harvest", "irrigation",
    "fertilizer", "pesticide", "organic", "soil", "farm",
    "agritech", "sustainable", "livestock", "farmer", "rural"
  ];

  final List<String> categories = [
    "All",
    "Crops",
    "Technology",
    "Weather",
    "Organic",
    "Market"
  ];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() => _isLoading = true);
    try {
      final news = await _newsApiService.fetchFilteredNews(_selectedCategory); //fetch news with selected category
      _filterNews(news);
    } catch (e) {
      print("Error fetching news: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterNews(List<NewsArticle> articles) {
    final filtered = articles.where((article) {
      final text = "${article.title.toLowerCase()} ${article.description.toLowerCase()}";
      return _farmingKeywords.any((keyword) => text.contains(keyword.toLowerCase()));
    }).toList();

    setState(() {
      _filteredArticles = filtered;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farming News"),
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        children: [
          // Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : "All";
                        _fetchNews();
                      });
                    },
                    selectedColor: Colors.green,
                  ),
                );
              }).toList(),
            ),
          ),

          // News list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredArticles.isEmpty
                    ? Center(child: Text("No farming news found"))
                    : ListView.builder(
                        itemCount: _filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = _filteredArticles[index];
                          return Card(
                            margin: EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailedNewsScreen(article: article),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    if (article.imageUrl != null)
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.network(
                                          article.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[200],
                                        child: Icon(Icons.article),
                                      ),
                                    
                                    SizedBox(width: 10),
                                    
                                    // Text
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            article.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Removed source field to prevent errors
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}