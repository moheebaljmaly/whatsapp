import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'services/auth_service.dart';
import 'chat_page.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  State<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final results = await AuthService.searchUsers(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في البحث'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Back Button and Title
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.textWhite,
                                size: 24,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'البحث عن أصدقاء',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // Balance the back button
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Search Description
                        const Text(
                          'ابحث عن الأصدقاء باستخدام اسم المستخدم أو البريد الإلكتروني',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textWhite,
                            height: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Search Field
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'اكتب اسم المستخدم أو البريد الإلكتروني...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        _searchUsers('');
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              hintStyle: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                            onChanged: (value) {
                              setState(() {});
                              _searchUsers(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Search Results
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildSearchResults(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched) {
      return _buildEmptyState(
        icon: Icons.search,
        title: 'ابدأ البحث',
        subtitle: 'اكتب اسم المستخدم أو البريد الإلكتروني للعثور على الأصدقاء',
      );
    }

    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16),
            Text(
              'جاري البحث...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_search,
        title: 'لا توجد نتائج',
        subtitle: 'لم نجد أي مستخدم يطابق بحثك\nتأكد من كتابة اسم المستخدم أو البريد الإلكتروني بشكل صحيح',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return _buildUserTile(user, index);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(Map<String, String> user, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.accentGradient,
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(user['avatar'] ?? ''),
                        onBackgroundImageError: (_, __) {},
                        backgroundColor: Colors.transparent,
                        child: user['avatar'] == null
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: AppColors.textWhite,
                              )
                            : null,
                      ),
                    ),
                    if (user['isVerified'] == 'true')
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 14,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    if (user['status'] == 'متصل' || user['status'] == 'متصلة')
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.online,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  user['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '@${user['username'] ?? ''}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['bio'] ?? '',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: () => _startChat(user),
                    icon: const Icon(
                      Icons.chat_bubble,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
                onTap: () => _startChat(user),
              ),
            ),
          ),
        );
      },
    );
  }

  void _startChat(Map<String, String> user) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          contactName: user['name'] ?? '',
          contactAvatar: user['avatar'] ?? '',
          isOnline: user['status'] == 'متصل' || user['status'] == 'متصلة',
        ),
      ),
    );
  }
}