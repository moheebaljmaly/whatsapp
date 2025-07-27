import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/social_auth_service.dart';
import 'login_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await SocialAuthService.getSavedUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF25D366),
          ),
        ),
      );
    }

    if (userData == null) {
      return const LoginPage();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF075E54),
              Color(0xFF128C7E),
              Color(0xFF25D366),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الملف الشخصي',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: _handleSignOut,
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: const Color(0xFF25D366),
                            width: 4,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(56),
                          child: userData!['photoUrl'] != null || userData!['avatar_url'] != null
                              ? Image.network(
                                  userData!['photoUrl'] ?? userData!['avatar_url'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar();
                                  },
                                )
                              : _buildDefaultAvatar(),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // User Name
                      Text(
                        userData!['displayName'] ?? userData!['name'] ?? userData!['login'] ?? 'مستخدم',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Email
                      if (userData!['email'] != null)
                        Text(
                          userData!['email'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // Provider Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getProviderColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getProviderColor(),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              _getProviderIcon(),
                              color: _getProviderColor(),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'تم تسجيل الدخول عبر ${_getProviderName()}',
                              style: TextStyle(
                                color: _getProviderColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // User Info Cards
                if (userData!['id'] != null)
                  _buildInfoCard(
                    'معرف المستخدم',
                    userData!['id'].toString(),
                    Icons.fingerprint,
                  ),
                
                if (userData!['login'] != null)
                  _buildInfoCard(
                    'اسم المستخدم',
                    userData!['login'],
                    Icons.alternate_email,
                  ),
                
                const SizedBox(height: 30),
                
                // Action Buttons
                _buildActionButton(
                  'تحديث الملف الشخصي',
                  Icons.edit,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ميزة تحديث الملف الشخصي قريباً!'),
                        backgroundColor: Color(0xFF25D366),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                _buildActionButton(
                  'الإعدادات',
                  Icons.settings,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('صفحة الإعدادات قريباً!'),
                        backgroundColor: Color(0xFF25D366),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                _buildActionButton(
                  'تسجيل الخروج',
                  Icons.logout,
                  _handleSignOut,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFF25D366),
      child: const Icon(
        Icons.person,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF25D366),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed, {bool isDestructive = false}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? Colors.red : Colors.white,
          foregroundColor: isDestructive ? Colors.white : const Color(0xFF25D366),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getProviderColor() {
    switch (userData!['provider']) {
      case 'google':
        return Colors.red;
      case 'github':
        return const Color(0xFF24292e);
      default:
        return const Color(0xFF25D366);
    }
  }

  IconData _getProviderIcon() {
    switch (userData!['provider']) {
      case 'google':
        return FontAwesomeIcons.google;
      case 'github':
        return FontAwesomeIcons.github;
      default:
        return Icons.person;
    }
  }

  String _getProviderName() {
    switch (userData!['provider']) {
      case 'google':
        return 'Google';
      case 'github':
        return 'GitHub';
      default:
        return 'النظام';
    }
  }

  Future<void> _handleSignOut() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                
                final navigator = Navigator.of(context);
                
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF25D366),
                    ),
                  ),
                );
                
                await SocialAuthService.signOut();
                
                if (mounted) {
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}