import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';
import 'utils/app_colors.dart';

class SettingsPage extends StatefulWidget {
  final bool showProfile;
  
  const SettingsPage({super.key, this.showProfile = false});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  Map<String, dynamic>? currentUser;
  bool _notificationsEnabled = true;
  bool _readReceiptsEnabled = true;
  bool _lastSeenEnabled = true;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    
    _loadCurrentUser();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              // Header
              _buildHeader(isDark),
              
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
                  child: currentUser == null
                      ? const Center(child: CircularProgressIndicator())
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildContent(isDark, themeService),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textWhite,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              widget.showProfile ? 'الملف الشخصي' : 'الإعدادات',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark, ThemeService themeService) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // User Profile Section
          _buildUserProfile(isDark),
          
          const SizedBox(height: 30),
          
          if (!widget.showProfile) ...[
            // Theme Settings
            _buildSettingsSection(
              'المظهر والخط',
              [
                _buildSwitchTile(
                  Icons.dark_mode,
                  'الوضع الليلي',
                  'تفعيل المظهر المظلم',
                  themeService.isDarkMode,
                  (value) async {
                    await themeService.setTheme(value);
                  },
                  isDark,
                ),
                _buildFontTile(isDark, themeService),
              ],
              isDark,
            ),
            
            // Privacy Settings
            _buildSettingsSection(
              'الخصوصية والأمان',
              [
                _buildSwitchTile(
                  Icons.done_all,
                  'إيصالات القراءة',
                  'إظهار علامات القراءة للآخرين',
                  _readReceiptsEnabled,
                  (value) {
                    setState(() {
                      _readReceiptsEnabled = value;
                    });
                  },
                  isDark,
                ),
                _buildSwitchTile(
                  Icons.access_time,
                  'آخر ظهور',
                  'إظهار وقت آخر ظهور للآخرين',
                  _lastSeenEnabled,
                  (value) {
                    setState(() {
                      _lastSeenEnabled = value;
                    });
                  },
                  isDark,
                ),
                _buildSettingsTile(
                  Icons.block,
                  'المستخدمون المحظورون',
                  'إدارة قائمة الحظر',
                  () => _showBlockedUsers(),
                  isDark,
                ),
              ],
              isDark,
            ),
            
            // App Settings
            _buildSettingsSection(
              'إعدادات التطبيق',
              [
                _buildSwitchTile(
                  Icons.notifications_active,
                  'الإشعارات',
                  'تفعيل إشعارات التطبيق',
                  _notificationsEnabled,
                  (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  isDark,
                ),
                _buildSettingsTile(
                  Icons.chat,
                  'إعدادات المحادثة',
                  'النسخ الاحتياطي، التاريخ',
                  () => _showChatSettings(),
                  isDark,
                ),
                _buildSettingsTile(
                  Icons.storage,
                  'التخزين والبيانات',
                  'استخدام الشبكة، التنزيل التلقائي',
                  () => _showStorageSettings(),
                  isDark,
                ),
              ],
              isDark,
            ),
            
            // Help and Support
            _buildSettingsSection(
              'المساعدة والدعم',
              [
                _buildSettingsTile(
                  Icons.help_outline,
                  'المساعدة',
                  'الأسئلة الشائعة، اتصل بنا',
                  () => _showHelp(),
                  isDark,
                ),
                _buildSettingsTile(
                  Icons.info_outline,
                  'حول التطبيق',
                  'معلومات التطبيق والإصدار',
                  () => _showAbout(),
                  isDark,
                ),
                _buildSettingsTile(
                  Icons.star_outline,
                  'تقييم التطبيق',
                  'قيم تجربتك معنا',
                  () => _rateApp(),
                  isDark,
                ),
              ],
              isDark,
            ),
          ],
          
          const SizedBox(height: 30),
          
          // Logout Button
          _buildLogoutButton(isDark),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildUserProfile(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: currentUser!['avatar'] != null
                      ? NetworkImage(currentUser!['avatar'])
                      : null,
                  backgroundColor: Colors.transparent,
                  child: currentUser!['avatar'] == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.textWhite,
                        )
                      : null,
                ),
              ),
              if (currentUser!['isVerified'] == 'true')
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 18,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // User Name
          Text(
            currentUser!['name'] ?? 'مستخدم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // User Bio
          if (currentUser!['bio'] != null && currentUser!['bio'].isNotEmpty)
            Text(
              currentUser!['bio'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.getTextSecondaryColor(isDark),
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Email
          Text(
            currentUser!['email'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Edit Profile Button
          Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton.icon(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.edit,
                color: AppColors.textWhite,
              ),
              label: const Text(
                'تحرير الملف الشخصي',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.getSurfaceColor(isDark),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.getTextSecondaryColor(isDark),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.getTextSecondaryColor(isDark),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.getTextSecondaryColor(isDark),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildFontTile(bool isDark, ThemeService themeService) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.font_download,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        'نوع الخط',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
      ),
      subtitle: Text(
        'الخط الحالي: ${themeService.fontFamily}',
        style: TextStyle(
          color: AppColors.getTextSecondaryColor(isDark),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.getTextSecondaryColor(isDark),
      ),
      onTap: () => _showFontSelector(themeService),
    );
  }

  Widget _buildLogoutButton(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.error, Color(0xFFFF6B6B)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: const Icon(
          Icons.logout,
          color: AppColors.textWhite,
        ),
        label: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );
    
    if (result == true) {
      await _loadCurrentUser();
    }
  }

  void _showFontSelector(ThemeService themeService) {
    final fonts = ['Cairo', 'Amiri', 'Tajawal', 'Almarai', 'Changa'];
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع الخط',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...fonts.map((font) => ListTile(
              title: Text(
                font,
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 18,
                ),
              ),
              trailing: themeService.fontFamily == font
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () async {
                final navigator = Navigator.of(context);
                await themeService.setFontFamily(font);
                navigator.pop();
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showBlockedUsers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المستخدمون المحظورون'),
        content: const Text('لا توجد مستخدمون محظورون حالياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showChatSettings() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('إعدادات المحادثات قريباً!'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  void _showStorageSettings() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('إعدادات التخزين قريباً!'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المساعدة'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الأسئلة الشائعة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• كيفية البحث عن مستخدمين جدد؟'),
              Text('• كيفية تغيير صورة الملف الشخصي؟'),
              Text('• كيفية تفعيل الوضع الليلي؟'),
              Text('• كيفية تغيير نوع الخط؟'),
              SizedBox(height: 16),
              Text(
                'للمزيد من المساعدة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('📧 support@wasl.com'),
              Text('📱 +966 50 123 4567'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول التطبيق'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تطبيق وصل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('الإصدار: 1.0.0'),
            SizedBox(height: 16),
            Text(
              'تطبيق مراسلة فورية حديث يتيح لك التواصل مع الأصدقاء والعائلة بسهولة وأمان. يتميز بتصميم عصري وألوان جذابة.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text('© 2024 وصل. جميع الحقوق محفوظة.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقييم التطبيق'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ما رأيك في تطبيق وصل؟'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: AppColors.accent, size: 30),
                Icon(Icons.star, color: AppColors.accent, size: 30),
                Icon(Icons.star, color: AppColors.accent, size: 30),
                Icon(Icons.star, color: AppColors.accent, size: 30),
                Icon(Icons.star, color: AppColors.accent, size: 30),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('شكراً لتقييمك! ❤️'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('تقييم'),
          ),
        ],
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
              navigator.pop(); // إغلاق الحوار أولاً
              await AuthService.logout();
              if (mounted) {
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
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