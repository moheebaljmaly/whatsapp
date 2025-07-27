import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // بيانات المستخدمين الوهمية - محدثة للاعتماد على البريد الإلكتروني
  static const List<Map<String, String>> _dummyUsers = [
    {
      'email': 'admin@wasl.com',
      'password': '123456',
      'username': 'admin_wasl',
      'name': 'أحمد محمد الإداري',
      'bio': 'مدير التطبيق - متاح دائماً للمساعدة',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'joinDate': '2024-01-01',
      'isVerified': 'true',
      'status': 'متصل',
    },
    {
      'email': 'sara.ahmed@wasl.com',
      'password': '123456',
      'username': 'sara_ahmed',
      'name': 'سارة أحمد',
      'bio': 'مطورة تطبيقات - أحب التقنية والإبداع',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'joinDate': '2024-01-15',
      'isVerified': 'true',
      'status': 'مشغولة',
    },
    {
      'email': 'mohammed.ali@wasl.com',
      'password': '123456',
      'username': 'mohammed_ali',
      'name': 'محمد علي',
      'bio': 'مصمم جرافيك - الإبداع هو شغفي',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'joinDate': '2024-02-01',
      'isVerified': 'false',
      'status': 'متصل',
    },
    {
      'email': 'fatima.hassan@wasl.com',
      'password': '123456',
      'username': 'fatima_hassan',
      'name': 'فاطمة حسن',
      'bio': 'كاتبة محتوى - أحب الكلمات والقصص',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'joinDate': '2024-02-10',
      'isVerified': 'true',
      'status': 'غير متصلة',
    },
    {
      'email': 'omar.salem@wasl.com',
      'password': '123456',
      'username': 'omar_salem',
      'name': 'عمر سالم',
      'bio': 'مهندس برمجيات - أبني المستقبل بالكود',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'joinDate': '2024-02-20',
      'isVerified': 'false',
      'status': 'متصل',
    },
    {
      'email': 'layla.mahmoud@wasl.com',
      'password': '123456',
      'username': 'layla_mahmoud',
      'name': 'ليلى محمود',
      'bio': 'مديرة مشاريع - أنظم الأفكار وأحقق الأهداف',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'joinDate': '2024-03-01',
      'isVerified': 'true',
      'status': 'متصلة',
    },
    {
      'email': 'khalid.nasser@wasl.com',
      'password': '123456',
      'username': 'khalid_nasser',
      'name': 'خالد ناصر',
      'bio': 'مصور فوتوغرافي - أصطاد اللحظات الجميلة',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'joinDate': '2024-03-10',
      'isVerified': 'false',
      'status': 'غير متصل',
    },
    {
      'email': 'nour.abdallah@wasl.com',
      'password': '123456',
      'username': 'nour_abdallah',
      'name': 'نور عبدالله',
      'bio': 'طالبة طب - أحلم بمساعدة الناس',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'joinDate': '2024-03-15',
      'isVerified': 'false',
      'status': 'متصلة',
    },
  ];

  // تسجيل الدخول بالبريد الإلكتروني أو اسم المستخدم
  static Future<Map<String, dynamic>?> login(String emailOrUsername, String password) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 2));

    // البحث عن المستخدم بالبريد الإلكتروني أو اسم المستخدم
    for (var user in _dummyUsers) {
      if ((user['email'] == emailOrUsername || user['username'] == emailOrUsername) && 
          user['password'] == password) {
        // حفظ بيانات المستخدم
        await _saveUserData({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'email': user['email']!,
          'username': user['username']!,
          'name': user['name']!,
          'bio': user['bio']!,
          'avatar': user['avatar']!,
          'joinDate': user['joinDate']!,
          'isVerified': user['isVerified']!,
          'status': user['status']!,
          'provider': 'email',
          'loginTime': DateTime.now().toIso8601String(),
        });
        
        return {
          'success': true,
          'user': {
            'email': user['email'],
            'username': user['username'],
            'name': user['name'],
            'bio': user['bio'],
            'avatar': user['avatar'],
            'isVerified': user['isVerified'],
            'status': user['status'],
          }
        };
      }
    }

    return {
      'success': false,
      'message': 'البريد الإلكتروني/اسم المستخدم أو كلمة المرور غير صحيحة'
    };
  }

  // إنشاء حساب جديد
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String username,
    required String password,
    String? bio,
  }) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 3));

    // التحقق من وجود البريد الإلكتروني أو اسم المستخدم
    for (var user in _dummyUsers) {
      if (user['email'] == email) {
        return {
          'success': false,
          'message': 'البريد الإلكتروني مستخدم بالفعل'
        };
      }
      if (user['username'] == username) {
        return {
          'success': false,
          'message': 'اسم المستخدم مستخدم بالفعل'
        };
      }
    }

    // إنشاء المستخدم الجديد
    await _saveUserData({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': email,
      'username': username,
      'name': name,
      'bio': bio ?? 'مرحباً! أنا أستخدم تطبيق وصل',
      'avatar': 'https://i.pravatar.cc/150?img=${DateTime.now().millisecond % 70 + 1}',
      'joinDate': DateTime.now().toIso8601String().split('T')[0],
      'isVerified': 'false',
      'status': 'متصل',
      'provider': 'email',
      'loginTime': DateTime.now().toIso8601String(),
    });

    return {
      'success': true,
      'message': 'تم إنشاء الحساب بنجاح'
    };
  }

  // إعادة تعيين كلمة المرور
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 2));

    // التحقق من وجود البريد الإلكتروني
    for (var user in _dummyUsers) {
      if (user['email'] == email) {
        return {
          'success': true,
          'message': 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'
        };
      }
    }

    return {
      'success': false,
      'message': 'البريد الإلكتروني غير مسجل في النظام'
    };
  }

  // البحث عن المستخدمين
  static Future<List<Map<String, String>>> searchUsers(String query) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) return [];

    return _dummyUsers.where((user) {
      return user['name']!.toLowerCase().contains(query.toLowerCase()) ||
             user['email']!.toLowerCase().contains(query.toLowerCase()) ||
             user['username']!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // الحصول على جميع المستخدمين (للمحادثات)
  static List<Map<String, String>> getAllUsers() {
    return _dummyUsers;
  }

  // حفظ بيانات المستخدم
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(userData));
    await prefs.setBool('is_logged_in', true);
  }

  // الحصول على بيانات المستخدم
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    
    return null;
  }

  // التحقق من حالة تسجيل الدخول
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.setBool('is_logged_in', false);
  }

  // تحديث بيانات المستخدم
  static Future<void> updateUserData(Map<String, dynamic> updates) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      // إذا كانت الصورة مسار محلي، احتفظ بها كما هي
      if (updates.containsKey('avatar')) {
        final avatarPath = updates['avatar'];
        if (avatarPath != null && avatarPath.toString().startsWith('/')) {
          // مسار محلي - احتفظ به
          currentUser['avatar'] = avatarPath;
        } else if (avatarPath != null && avatarPath.toString().startsWith('http')) {
          // رابط إنترنت - احتفظ به
          currentUser['avatar'] = avatarPath;
        }
        updates.remove('avatar'); // إزالة من التحديثات لتجنب الكتابة المضاعفة
      }
      
      currentUser.addAll(updates);
      await _saveUserData(currentUser);
    }
  }

  // الحصول على قائمة المستخدمين الوهمية (للاختبار)
  static List<Map<String, String>> getDummyUsers() {
    return _dummyUsers;
  }

  // تسجيل دخول سريع (للاختبار)
  static Future<Map<String, dynamic>?> quickLogin(int userIndex) async {
    if (userIndex >= 0 && userIndex < _dummyUsers.length) {
      final user = _dummyUsers[userIndex];
      return await login(user['email']!, user['password']!);
    }
    return null;
  }

  // التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // التحقق من صحة اسم المستخدم
  static bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username);
  }
}