import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'login_page.dart';
import 'chat_page.dart';
import 'search_users_page.dart';
import 'settings_page.dart';
import 'utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Map<String, dynamic>? currentUser;
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // قائمة المحادثات الوهمية - محدثة
  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': 'سارة أحمد',
      'username': 'sara_ahmed',
      'lastMessage': 'مرحباً! كيف حالك؟ أتمنى أن تكون بخير 😊',
      'time': '10:30 ص',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'unreadCount': 3,
      'isOnline': true,
      'isVerified': true,
    },
    {
      'id': '2',
      'name': 'محمد علي',
      'username': 'mohammed_ali',
      'lastMessage': 'شكراً لك على التصميم الرائع! 🎨',
      'time': '09:45 ص',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'unreadCount': 0,
      'isOnline': true,
      'isVerified': false,
    },
    {
      'id': '3',
      'name': 'فاطمة حسن',
      'username': 'fatima_hassan',
      'lastMessage': 'هل يمكننا مناقشة المقال الجديد؟',
      'time': 'أمس',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'unreadCount': 1,
      'isOnline': false,
      'isVerified': true,
    },
    {
      'id': '4',
      'name': 'عمر سالم',
      'username': 'omar_salem',
      'lastMessage': 'تم إرسال الكود، راجعه من فضلك 💻',
      'time': 'أمس',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'unreadCount': 0,
      'isOnline': true,
      'isVerified': false,
    },
    {
      'id': '5',
      'name': 'ليلى محمود',
      'username': 'layla_mahmoud',
      'lastMessage': 'اجتماع المشروع غداً الساعة 2 ظهراً',
      'time': 'الأحد',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'unreadCount': 2,
      'isOnline': true,
      'isVerified': true,
    },
    {
      'id': '6',
      'name': 'خالد ناصر',
      'username': 'khalid_nasser',
      'lastMessage': 'الصور جاهزة للمراجعة 📸',
      'time': 'الأحد',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'unreadCount': 0,
      'isOnline': false,
      'isVerified': false,
    },
    {
      'id': '7',
      'name': 'نور عبدالله',
      'username': 'nour_abdallah',
      'lastMessage': 'شكراً لك على النصائح الطبية 🩺',
      'time': 'الاثنين',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'unreadCount': 1,
      'isOnline': true,
      'isVerified': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _loadCurrentUser();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getMainGradient(isDark),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(isDark),
              
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.getBackgroundColor(isDark),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Tab Bar
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceColor(isDark),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelColor: AppColors.textWhite,
                          unselectedLabelColor: AppColors.getTextSecondaryColor(isDark),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          tabs: const [
                            Tab(text: 'المحادثات'),
                            Tab(text: 'المكالمات'),
                          ],
                        ),
                      ),
                      
                      // Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildChatsTab(isDark),
                            _buildCallsTab(isDark),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchUsersPage(),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.person_add,
              color: AppColors.textWhite,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile Avatar
          GestureDetector(
            onTap: _navigateToProfile,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 23,
                backgroundImage: currentUser?['avatar'] != null
                    ? NetworkImage(currentUser!['avatar'])
                    : null,
                backgroundColor: Colors.transparent,
                child: currentUser?['avatar'] == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.textWhite,
                        size: 25,
                      )
                    : null,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // App Title and User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'وصل',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
                Text(
                  'مرحباً ${currentUser?['name'] ?? 'المستخدم'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // Search Button
          Container(
            decoration: BoxDecoration(
              color: AppColors.textWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchUsersPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                color: AppColors.textWhite,
                size: 24,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Menu Button
          Container(
            decoration: BoxDecoration(
              color: AppColors.textWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.textWhite,
                size: 24,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    _navigateToProfile();
                    break;
                  case 'settings':
                    _navigateToSettings();
                    break;
                  case 'logout':
                    _handleLogout();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: AppColors.primary),
                      SizedBox(width: 12),
                      Text('الملف الشخصي'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: AppColors.primary),
                      SizedBox(width: 12),
                      Text('الإعدادات'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: AppColors.error),
                      SizedBox(width: 12),
                      Text('تسجيل الخروج'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsTab(bool isDark) {
    if (_chats.isEmpty) {
      return _buildEmptyChats(isDark);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return _buildChatTile(chat, index, isDark);
      },
    );
  }

  Widget _buildEmptyChats(bool isDark) {
    return Center(
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
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد محادثات بعد',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'ابحث عن أصدقاء وابدأ محادثة جديدة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchUsersPage(),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('البحث عن أصدقاء'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat, int index, bool isDark) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                        backgroundImage: NetworkImage(chat['avatar']),
                        onBackgroundImageError: (_, __) {},
                        backgroundColor: Colors.transparent,
                        child: chat['avatar'] == null
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: AppColors.textWhite,
                              )
                            : null,
                      ),
                    ),
                    if (chat['isVerified'])
                      Positioned(
                        top: 0,
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
                    if (chat['isOnline'])
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
                  chat['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    chat['lastMessage'],
                    style: TextStyle(
                      color: chat['unreadCount'] > 0
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: chat['unreadCount'] > 0
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat['time'],
                      style: TextStyle(
                        color: chat['unreadCount'] > 0
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: chat['unreadCount'] > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (chat['unreadCount'] > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          chat['unreadCount'].toString(),
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        contactName: chat['name'],
                        contactAvatar: chat['avatar'],
                        isOnline: chat['isOnline'],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallsTab(bool isDark) {
    final calls = [
      {
        'name': 'سارة أحمد',
        'time': '10:30 ص',
        'type': 'incoming',
        'avatar': 'https://i.pravatar.cc/150?img=2',
        'duration': '5:23',
      },
      {
        'name': 'محمد علي',
        'time': '09:45 ص',
        'type': 'outgoing',
        'avatar': 'https://i.pravatar.cc/150?img=3',
        'duration': '12:45',
      },
      {
        'name': 'فاطمة حسن',
        'time': 'أمس',
        'type': 'missed',
        'avatar': 'https://i.pravatar.cc/150?img=4',
        'duration': '0:00',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(call['avatar']!),
              onBackgroundImageError: (_, __) {},
              child: call['avatar'] == null
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            title: Text(
              call['name']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  call['type'] == 'incoming'
                      ? Icons.call_received
                      : call['type'] == 'outgoing'
                          ? Icons.call_made
                          : Icons.call_received,
                  size: 16,
                  color: call['type'] == 'missed' ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  '${call['time']} • ${call['duration']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.call, color: AppColors.accent),
                onPressed: () {
                  _makeCall(call['name']!);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(showProfile: true),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _makeCall(String contactName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $contactName...'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await AuthService.logout();
              if (mounted) {
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}