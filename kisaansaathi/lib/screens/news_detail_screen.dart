import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailedNewsScreen extends StatelessWidget {
  final NewsArticle article;

  const DetailedNewsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News Details")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl != null
                ? Image.network(article.imageUrl!, fit: BoxFit.cover)
                : SizedBox.shrink(),
            SizedBox(height: 10),
            Text(article.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            // Date and source information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                article.publishedAt != null
                  ? Text(
                      "${article.publishedAt!.day}/${article.publishedAt!.month}/${article.publishedAt!.year}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    )
                  : SizedBox(),
                article.source != null
                  ? Text(
                      "Source: ${article.source}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
            Text(article.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunchUrlString(article.url)) {
                  await launchUrlString(article.url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not open article')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text("Read Full Article"),
            ),
          ],//runnnnnnnnnn!!!!!!!!!!!!!!!!!!!!
        ),
      ),
    );
  }
}