import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import '../config/env_config.dart';

class Post {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorProfileImage;
  final String? imageUrl;
  final List<String> tags;
  final List<String> likes;
  final List<Comment> comments;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorProfileImage,
    this.imageUrl,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> commentsList = [];
    if (json['comments'] != null) {
      commentsList = List<Comment>.from(
        json['comments'].map((comment) => Comment.fromJson(comment)),
      );
    }
    
    // Handle different schema formats (farmer app vs other app)
    String authorId = '';
    String authorName = '';
    String? authorProfileImage;
    
    // Handle author field which could be from farmer app
    if (json['author'] != null) {
      if (json['author'] is Map) {
        authorId = json['author']['_id'] ?? '';
        authorName = json['author']['name'] ?? 'Farmer';
        authorProfileImage = json['author']['profileImage']?['url'];
      } else {
        // If author is just an ID string
        authorId = json['author'].toString();
        authorName = 'Farmer';
      }
    } 
    // Handle user field which could be from other app
    else if (json['user'] != null) {
      if (json['user'] is Map) {
        authorId = json['user']['_id'] ?? '';
        authorName = json['username'] ?? 'Farmer';
      } else {
        authorId = json['user'].toString();
        authorName = json['username'] ?? 'Farmer';
      }
    }
    
    // Get content from either content or caption field
    String content = json['content'] ?? json['caption'] ?? '';
    
    return Post(
      id: json['_id'] ?? '',
      content: content,
      authorId: authorId,
      authorName: authorName,
      authorProfileImage: authorProfileImage,
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
      comments: commentsList,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}

class Comment {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorProfileImage;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorProfileImage,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    // Handle different schema formats
    String authorId = '';
    String authorName = '';
    String? authorProfileImage;
    String content = '';
    
    // Handle author field (farmer app)
    if (json['author'] != null) {
      if (json['author'] is Map) {
        authorId = json['author']['_id'] ?? '';
        authorName = json['author']['name'] ?? 'Farmer';
        authorProfileImage = json['author']['profileImage']?['url'];
      } else {
        authorId = json['author'].toString();
        authorName = 'Farmer';
      }
    } 
    // Handle user field (other app)
    else if (json['user'] != null) {
      if (json['user'] is Map) {
        authorId = json['user']['_id'] ?? '';
      } else {
        authorId = json['user'].toString();
      }
      authorName = json['username'] ?? 'Farmer';
    }
    
    // Get content from either content or text field
    content = json['content'] ?? json['text'] ?? '';
    
    return Comment(
      id: json['_id'] ?? '',
      content: content,
      authorId: authorId,
      authorName: authorName,
      authorProfileImage: authorProfileImage,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}

class PostService {
  // Use localhost for web, 10.0.2.2 for Android emulator
  final String baseUrl = 'http://10.99.111.180:5000/api';

  // Get all posts with pagination
  Future<Map<String, dynamic>> getPosts({int page = 1, int limit = 10, String? tag}) async {
    try {
      final String baseUrl = '${EnvConfig.nodeApiUrl}/api';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      
      String url = '$baseUrl/posts?page=$page&limit=$limit';
      if (tag != null && tag != 'All' && tag.isNotEmpty) {
        url += '&tag=$tag';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: token != null ? {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        } : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Handle case where posts might be null or not an array
        List<dynamic> postsData = [];
        if (data['posts'] != null && data['posts'] is List) {
          postsData = data['posts'];
        }
        
        // Safely convert to Post objects with error handling for each post
        final List<Post> posts = [];
        for (var postData in postsData) {
          try {
            posts.add(Post.fromJson(postData));
          } catch (e) {
            print('Error parsing post: $e');
            // Continue to next post if one fails
          }
        }

        return {
          'posts': posts,
          'totalPages': data['totalPages'] ?? 1,
          'currentPage': data['currentPage'] ?? 1,
        };
      } else if (response.statusCode == 404) {
        // No posts found, return empty list instead of throwing error
        return {
          'posts': [],
          'totalPages': 0,
          'currentPage': page,
        };
      } else if (response.statusCode == 401) {
        throw Exception('Authentication error. Please login again.');
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting posts: $e');
      // Return empty data instead of rethrowing to prevent app crashes
      return {
        'posts': [],
        'totalPages': 1,
        'currentPage': 1,
      };
    }
  }

  // Create a new post
  Future<Post> createPost({
    required String content,
    required String authorId,
    List<String>? tags,
    File? image,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));

      // Add text fields
      request.fields['content'] = content;
      request.fields['authorId'] = authorId;
      
      if (tags != null && tags.isNotEmpty) {
        request.fields['tags'] = json.encode(tags);
      }

      // Add image if provided
      if (image != null) {
        final fileExtension = image.path.split('.').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType('image', fileExtension),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  // Like or unlike a post
  Future<Map<String, dynamic>> toggleLike(String postId, String farmerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts/$postId/like'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'farmerId': farmerId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  // Add a comment to a post
  Future<Comment> addComment(String postId, String content, String authorId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts/$postId/comment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': content,
          'authorId': authorId,
        }),
      );

      if (response.statusCode == 201) {
        return Comment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  // Get posts by a specific farmer
  Future<Map<String, dynamic>> getFarmerPosts(String farmerId, {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/farmer/$farmerId?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Post> posts = List<Post>.from(
          data['posts'].map((post) => Post.fromJson(post)),
        );

        return {
          'posts': posts,
          'totalPages': data['totalPages'],
          'currentPage': data['currentPage'],
        };
      } else {
        throw Exception('Failed to load farmer posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching farmer posts: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$postId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }

  // Get current farmer ID from shared preferences
  Future<String?> getCurrentFarmerId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerData = prefs.getString('farmer');
      
      if (farmerData != null) {
        final farmer = json.decode(farmerData);
        return farmer['_id'];
      }
      return null;
    } catch (e) {
      print('Error getting current farmer ID: $e');
      return null;
    }
  }
}