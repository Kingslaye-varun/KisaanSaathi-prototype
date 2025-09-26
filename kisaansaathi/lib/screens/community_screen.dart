import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/post_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final PostService _postService = PostService();
  final TextEditingController _postController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Post> _posts = [];
  bool _isLoading = true;
  bool _isCreatingPost = false;
  String? _selectedTag;
  File? _imageFile;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String? _currentFarmerId;
  String? _currentFarmerName;
  String? _currentFarmerImage;

  final ScrollController _scrollController = ScrollController();

  final List<String> _tags = [
    'All',
    'success_story',
    'question',
    'pest_control',
    'harvest',
    'market_prices',
    'weather',
    'equipment',
    'seeds',
    'fertilizer',
    'general',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentFarmer();
    _loadPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMorePosts();
      }
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentFarmer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerData = prefs.getString('farmerData');
      
      if (farmerData != null) {
        final farmer = json.decode(farmerData);
        setState(() {
          _currentFarmerId = farmer['_id'];
          _currentFarmerName = farmer['name'];
          _currentFarmerImage = farmer['profileImage']?['url'];
        });
        print('Set farmer ID: $_currentFarmerId, name: $_currentFarmerName');
      } else {
        print('No farmer data found in SharedPreferences');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No farmer data found. Please log in again.')),
        );
      }
    } catch (e) {
      print('Error loading current farmer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading farmer data: $e')),
      );
    }
  }

  // Helper method to convert tag names to readable format
  String _getReadableTagName(String tag) {
    return tag.replaceAll('_', ' ').toCapitalized();
  }

  Future<void> _loadPosts() async {
    if (_currentFarmerId == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view posts')),
      );
      return;
    }

    try {
      final result = await _postService.getPosts(
        page: _currentPage,
        tag: _selectedTag == 'All' ? null : _selectedTag,
      );

      setState(() {
        _posts = result['posts'] ?? [];
        _totalPages = result['totalPages'] ?? 1;
        _hasMore = _currentPage < _totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e'))
      );
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final result = await _postService.getPosts(
        page: nextPage,
        tag: _selectedTag == 'All' ? null : _selectedTag,
      );

      final newPosts = result['posts'] ?? [];

      setState(() {
        _posts.addAll(newPosts);
        _currentPage = nextPage;
        _hasMore = nextPage < (result['totalPages'] ?? 1);
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading more posts: $e'))
      );
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _currentPage = 1;
    });
    await _loadPosts();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e'))
      );
    }
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post content cannot be empty')),
      );
      return;
    }

    if (_currentFarmerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to create a post')),
      );
      return;
    }

    if (_selectedTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a topic for your post')),
      );
      return;
    }

    setState(() {
      _isCreatingPost = true;
    });

    try {
      // Show a progress indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Text('Creating your post...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      final tags = _selectedTag != 'All' ? [_selectedTag!] : ['general'];

      final result = await _postService.createPost(
        content: _postController.text.trim(),
        authorId: _currentFarmerId!,
        tags: tags,
        image: _imageFile,
      );

      setState(() {
        _postController.clear();
        _imageFile = null;
        _isCreatingPost = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your post has been shared successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh posts after creating a new one
      await Future.delayed(const Duration(milliseconds: 500));
      _refreshIndicatorKey.currentState?.show();
    } on SocketException {
      setState(() {
        _isCreatingPost = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
    } catch (e) {
      setState(() {
        _isCreatingPost = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating post: $e'),
          backgroundColor: Colors.red,
        )
      );
    }
  }

  Future<void> _toggleLike(Post post) async {
    if (_currentFarmerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to like posts')),
      );
      return;
    }

    try {
      await _postService.toggleLike(post.id, _currentFarmerId!);

      // Refresh posts to update like status
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error liking post: $e'))
      );
    }
  }

  void _showComments(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentBottomSheet(
        post: post,
        currentFarmerId: _currentFarmerId,
        onCommentAdded: () {
          // Refresh posts to update comments
          _refreshIndicatorKey.currentState?.show();
        },
      ),
    );
  }

  void _navigateToProfile(String farmerId) {
    // This will be implemented later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile screen will be implemented soon')),
    );
  }

  void _navigateToChat(String farmerId) {
    // This will be implemented later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat screen will be implemented soon')),
    );
  }

  // Show post creation UI in bottom sheet
  void _showPostCreationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share with Farmers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage: _currentFarmerImage != null
                        ? NetworkImage(_currentFarmerImage!)
                        : null,
                    child: _currentFarmerImage == null
                        ? const Icon(Icons.person, size: 30, color: Colors.green)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentFarmerName ?? 'Farmer',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Posting to Community',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Post topic selection
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select Topic (required)'),
                  value: _selectedTag,
                  underline: Container(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTag = newValue;
                    });
                  },
                  items: _tags
                      .where((tag) => tag != 'All')
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getReadableTagName(value)),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 16),
              TextField(
                controller: _postController,
                decoration: InputDecoration(
                  hintText: 'What would you like to share with other farmers?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                maxLines: 5,
                minLines: 3,
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 16),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _imageFile = null;
                          });
                          Navigator.pop(context);
                          _showPostCreationSheet();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.add_photo_alternate, color: Colors.green, size: 28),
                    label: const Text('Add Photo', 
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    onPressed: () async {
                      await _pickImage();
                      Navigator.pop(context);
                      _showPostCreationSheet();
                    },
                  ),
                  ElevatedButton(
                    onPressed: _isCreatingPost || _selectedTag == null
                        ? null
                        : () async {
                            await _createPost();
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isCreatingPost
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Share Post',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farmer Community',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshPosts,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Post creation section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: _currentFarmerImage != null
                              ? NetworkImage(_currentFarmerImage!)
                              : null,
                          child: _currentFarmerImage == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showPostCreationSheet();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.shade100,
                              ),
                              child: Text(
                                'What\'s on your mind?',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tag filters
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _tags.length,
                      itemBuilder: (context, index) {
                        final tag = _tags[index];
                        final isSelected = _selectedTag == tag || 
                                          (tag == 'All' && _selectedTag == null);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(tag.replaceAll('_', ' ').toCapitalized()),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTag = selected ? (tag == 'All' ? null : tag) : null;
                                _currentPage = 1;
                                _posts = [];
                                _isLoading = true;
                              });
                              _loadPosts();
                            },
                            backgroundColor: Colors.grey.shade200,
                            selectedColor: Colors.green.shade100,
                            checkmarkColor: Colors.green,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.green.shade800 : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  // Posts list
                  Expanded(
                    child: _posts.isEmpty
                        ? const Center(
                            child: Text(
                              'No posts yet. Be the first to post!',
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _posts.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _posts.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final post = _posts[index];
                              final isLiked = post.likes.contains(_currentFarmerId);

                              return PostCard(
                                post: post,
                                isLiked: isLiked,
                                onLike: () => _toggleLike(post),
                                onComment: () => _showComments(post),
                                onProfileTap: () => _navigateToProfile(post.authorId),
                                onChatTap: () => _navigateToChat(post.authorId),
                                currentFarmerId: _currentFarmerId,
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: _currentFarmerId != null
          ? FloatingActionButton(
              onPressed: _showPostCreationSheet,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            )
          : null,
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onProfileTap;
  final VoidCallback onChatTap;
  final String? currentFarmerId;

  const PostCard({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.onProfileTap,
    required this.onChatTap,
    required this.currentFarmerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrentUserPost =
        currentFarmerId != null && post.authorId == currentFarmerId;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info and post time
                Row(
                  children: [
                    GestureDetector(
                      onTap: onProfileTap,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.green.shade100,
                        backgroundImage: post.authorProfileImage != null
                            ? NetworkImage(post.authorProfileImage!)
                            : null,
                        child: post.authorProfileImage == null
                            ? const Icon(Icons.person, size: 28, color: Colors.green)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: onProfileTap,
                            child: Text(
                              post.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatTimestamp(post.createdAt),
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isCurrentUserPost)
                      IconButton(
                        icon: const Icon(Icons.message, color: Colors.green),
                        onPressed: onChatTap,
                        tooltip: 'Message',
                      ),
                  ],
                ),

                // Post content
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    post.content,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                // Post tags
                if (post.tags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: post.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade100),
                            ),
                            child: Text(
                              tag.replaceAll('_', ' ').toCapitalized(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                // Post image
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.red, size: 32),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // Post stats and actions
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 16,
                        color: Colors.green[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes.length}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.comment,
                        size: 16,
                        color: Colors.blue[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.comments.length}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: currentFarmerId != null ? onLike : null,
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: isLiked ? Colors.green : Colors.grey[600],
                          size: 20,
                        ),
                        label: Text(
                          'Like',
                          style: TextStyle(
                            color: isLiked ? Colors.green : Colors.grey[600],
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onComment,
                        icon: Icon(
                          Icons.comment_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        label: Text(
                          'Comment',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class CommentBottomSheet extends StatefulWidget {
  final Post post;
  final String? currentFarmerId;
  final VoidCallback onCommentAdded;

  const CommentBottomSheet({
    Key? key,
    required this.post,
    required this.currentFarmerId,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final PostService _postService = PostService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    if (widget.currentFarmerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to comment'))
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _postService.addComment(
        widget.post.id,
        _commentController.text.trim(),
        widget.currentFarmerId!,
      );

      _commentController.clear();
      widget.onCommentAdded();

      setState(() {
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Comments list
            widget.post.comments.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No comments yet. Be the first to comment!'),
                    ),
                  )
                : SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) {
                        final comment = widget.post.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: comment.authorProfileImage != null
                                ? NetworkImage(comment.authorProfileImage!)
                                : null,
                            child: comment.authorProfileImage == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Row(
                            children: [
                              Text(
                                comment.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimestamp(comment.createdAt),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(comment.content),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 16),

            // Comment input
            if (widget.currentFarmerId != null)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      minLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isSubmitting ? null : _addComment,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}