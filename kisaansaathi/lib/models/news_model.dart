class NewsArticle {
  final String title;
  final String description;
  final String? imageUrl;
  final String url;
  final DateTime? publishedAt;
  final String? source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
    this.publishedAt,
    this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description Available',
      imageUrl: json['urlToImage'],
      url: json['url'],
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      source: json['source'] != null && json['source'] is Map ? json['source']['name'] : null,
    );
  }
}