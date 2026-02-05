// import 'package:flutter/material.dart';
// import '../models/news_model.dart';
// import '../services/news_api_service.dart';
// import 'news_detail_screen.dart';




// class NewsScreen extends StatefulWidget {
//   @override
//   _NewsScreenState createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {
//   final NewsApiService _newsApiService = NewsApiService();
//   List<NewsArticle> _newsArticles = [];
//   bool _isLoading = true;
//   String _selectedCategory = "All";
//   String _searchQuery = "";
//   final TextEditingController _searchController = TextEditingController();

//   // Category icons mapping
//   final Map<String, IconData> categoryIcons = {
//     "All": Icons.article,
//     "Crops": Icons.grass,
//     "Technology": Icons.precision_manufacturing,
//     "Weather": Icons.wb_sunny,
//     "Organic": Icons.eco,
//     "Market": Icons.trending_up,
//   };

//   // Category descriptions
//   final Map<String, String> categoryDescriptions = {
//     "All": "All agriculture news",
//     "Crops": "Crop cultivation & management",
//     "Technology": "Farm tech & innovations",
//     "Weather": "Weather forecasts for farmers",
//     "Organic": "Organic & sustainable farming",
//     "Market": "Market prices & trends",
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchNews();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchNews() async {
//     setState(() => _isLoading = true);
//     try {
//       final news = await _newsApiService.fetchFilteredNews(_selectedCategory);
//       setState(() {
//         _newsArticles = news;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching news: $e");
//       setState(() => _isLoading = false);
//     }
//   }

//   // Filter news based on search query
//   List<NewsArticle> get _filteredArticles {
//     if (_searchQuery.isEmpty) {
//       return _newsArticles;
//     }
    
//     return _newsArticles.where((article) {
//       final title = article.title?.toLowerCase() ?? '';
//       final description = article.description?.toLowerCase() ?? '';
//       final query = _searchQuery.toLowerCase();
      
//       return title.contains(query) || description.contains(query);
//     }).toList();
//   }

//   // Get news category tag based on content
//   String _getNewsCategory(NewsArticle article) {
//     final content = "${article.title ?? ''} ${article.description ?? ''}".toLowerCase();
    
//     if (content.contains("price") || content.contains("market") || content.contains("msp") || 
//         content.contains("export") || content.contains("mandi") || content.contains("trade")) {
//       return "Market";
//     } else if (content.contains("organic") || content.contains("natural") || 
//                content.contains("sustainable") || content.contains("jaivik")) {
//       return "Organic";
//     } else if (content.contains("monsoon") || content.contains("rain") || 
//                content.contains("drought") || content.contains("climate") || 
//                content.contains("weather") || content.contains("forecast")) {
//       return "Weather";
//     } else if (content.contains("technology") || content.contains("innovation") || 
//                content.contains("digital") || content.contains("smart") || 
//                content.contains("app") || content.contains("tech")) {
//       return "Technology";
//     } else if (content.contains("crop") || content.contains("harvest") || 
//                content.contains("seed") || content.contains("yield") || 
//                content.contains("wheat") || content.contains("rice") || 
//                content.contains("cultivation")) {
//       return "Crops";
//     }
    
//     return "General";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Kisan News"),
//         backgroundColor: Colors.green[800],
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _fetchNews,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Search agriculture news...",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide(color: Colors.green),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },
//             ),
//           ),

//           // Category chips
//           Container(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: categoryIcons.length,
//               itemBuilder: (context, index) {
//                 final category = categoryIcons.keys.elementAt(index);
//                 final icon = categoryIcons[category];
//                 final description = categoryDescriptions[category];
                
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         _selectedCategory = category;
//                         _fetchNews();
//                       });
//                     },
//                     child: Container(
//                       width: 100,
//                       decoration: BoxDecoration(
//                         color: _selectedCategory == category ? Colors.green : Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 3,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             icon,
//                             color: _selectedCategory == category ? Colors.white : Colors.green,
//                             size: 32,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             category,
//                             style: TextStyle(
//                               color: _selectedCategory == category ? Colors.white : Colors.black87,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             description ?? "",
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: _selectedCategory == category ? Colors.white70 : Colors.black54,
//                             ),
//                             textAlign: TextAlign.center,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // News list
//           Expanded(
//             child: _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : _filteredArticles.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.article_outlined, size: 48, color: Colors.grey),
//                             SizedBox(height: 16),
//                             Text(
//                               "No agriculture news found",
//                               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               "Try changing the category or search term",
//                               style: TextStyle(fontSize: 14, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _filteredArticles.length,
//                         itemBuilder: (context, index) {
//                           final article = _filteredArticles[index];
//                           final category = _getNewsCategory(article);
                          
//                           return Card(
//                             margin: EdgeInsets.all(8),
//                             elevation: 3,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => DetailedNewsScreen(article: article),
//                                   ),
//                                 );
//                               },
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Image
//                                   if (article.imageUrl != null)
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(12),
//                                         topRight: Radius.circular(12),
//                                       ),
//                                       child: Image.network(
//                                         article.imageUrl!,
//                                         height: 180,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, __, ___) => Container(
//                                           height: 180,
//                                           color: Colors.grey[200],
//                                           child: Icon(Icons.broken_image, size: 50),
//                                         ),
//                                       ),
//                                     ),
                                  
//                                   Padding(
//                                     padding: EdgeInsets.all(12),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         // Category chip
//                                         Container(
//                                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                           decoration: BoxDecoration(
//                                             color: Colors.green[100],
//                                             borderRadius: BorderRadius.circular(16),
//                                           ),
//                                           child: Text(
//                                             category,
//                                             style: TextStyle(
//                                               color: Colors.green[800],
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 8),
                                        
//                                         // Title
//                                         Text(
//                                           article.title ?? "No title",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(height: 8),
                                        
//                                         // Description
//                                         Text(
//                                           article.description ?? "No description",
//                                           style: TextStyle(
//                                             color: Colors.grey[700],
//                                             fontSize: 14,
//                                           ),
//                                           maxLines: 3,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
                                        
//                                         SizedBox(height: 8),
                                        
//                                         // Date and source
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             article.publishedAt != null
//                                               ? Text(
//                                                   _formatDate(article.publishedAt!),
//                                                   style: TextStyle(
//                                                     color: Colors.grey[600],
//                                                     fontSize: 12,
//                                                   ),
//                                                 )
//                                               : SizedBox(),
//                                             article.source != null
//                                               ? Text(
//                                                   "Source: ${article.source}",
//                                                   style: TextStyle(
//                                                     color: Colors.grey[600],
//                                                     fontSize: 12,
//                                                     fontStyle: FontStyle.italic,
//                                                   ),
//                                                 )
//                                               : SizedBox(),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   // Format date
//   String _formatDate(DateTime date) {
//     try {
//       return "${date.day}/${date.month}/${date.year}";
//     } catch (e) {
//       return "N/A";
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import '../models/news_model.dart';
// import '../services/news_api_service.dart';
// import 'news_detail_screen.dart';

// class NewsScreen extends StatefulWidget {
//   @override
//   _NewsScreenState createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {
//   final NewsApiService _newsApiService = NewsApiService();
//   List<NewsArticle> _newsArticles = [];
//   bool _isLoading = true;
//   String _selectedCategory = "All";

//   // categories
//   final List<String> categories = [
//     "All",
//     "Crops",
//     "Farming Tech",
//     "Weather",
//     "Organic Farming",
//     "Market Trends",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchNews();
//   }

//   void _fetchNews() async {
//     setState(() => _isLoading = true);

//     try {
//       final news = await _newsApiService.fetchFilteredNews(_selectedCategory);
//       setState(() {
//         _newsArticles = news;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching news: $e");
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Agriculture News")),
//       body: Column(
//         children: [
//           // Category Selection
//           Container(
//             height: 60,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children:
//                   categories.map((category) {
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedCategory = category;
//                           _fetchNews();
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 10,
//                         ),
//                         margin: EdgeInsets.symmetric(
//                           horizontal: 5,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color:
//                               _selectedCategory == category
//                                   ? Colors.green
//                                   : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           category,
//                           style: TextStyle(
//                             color:
//                                 _selectedCategory == category
//                                     ? Colors.white
//                                     : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//             ),
//           ),

//           // News List
//           Expanded(
//             child:
//                 _isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                       itemCount: _newsArticles.length,
//                       itemBuilder: (context, index) {
//                         final article = _newsArticles[index];
//                         return Card(
//                           margin: EdgeInsets.all(10),
//                           child: ListTile(
//                             leading:
//                                 article.imageUrl != null
//                                     ? Image.network(
//                                       article.imageUrl!,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )
//                                     : Icon(Icons.image_not_supported),
//                             title: Text(article.title, maxLines: 2),
//                             subtitle: Text(
//                               article.description ?? "",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) =>
//                                           DetailedNewsScreen(article: article),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_api_service.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  List<NewsArticle> _newsArticles = [];
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
      final text = "${article.title.toLowerCase() ?? ''} ${article.description.toLowerCase() ?? ''}";
      return _farmingKeywords.any((keyword) => text.contains(keyword.toLowerCase()));
    }).toList();

    setState(() {
      _newsArticles = articles;
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
                                      SizedBox(
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
                                            article.title ?? "No title",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            article.description ?? "No description",
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