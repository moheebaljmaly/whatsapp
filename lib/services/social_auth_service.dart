import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialAuthService {
  // GitHub OAuth Configuration
  static const String _githubClientId = 'your_github_client_id'; // يجب استبداله بالـ Client ID الحقيقي
  static const String _githubClientSecret = 'your_github_client_secret'; // يجب استبداله بالـ Client Secret الحقيقي
  static const String _githubRedirectUri = 'your_app://github_callback'; // يجب استبداله بالـ Redirect URI الحقيقي

  // محاكاة تسجيل الدخول عبر Google (للاختبار)
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 2));
      
      // محاكاة بيانات المستخدم
      final userData = {
        'id': 'google_123456',
        'email': 'user@gmail.com',
        'displayName': 'مستخدم Google',
        'photoUrl': 'https://lh3.googleusercontent.com/a/default-user',
        'provider': 'google',
      };
      
      // حفظ معلومات المستخدم
      await _saveUserData('google', userData);
      
      return userData;
    } catch (error) {
      debugPrint('خطأ في تسجيل الدخول عبر Google: $error');
      return null;
    }
  }

  // GitHub Sign In
  static Future<Map<String, dynamic>?> signInWithGitHub(BuildContext context) async {
    try {
      // إنشاء state عشوائي للأمان
      final state = _generateRandomString(32);
      
      // بناء رابط المصادقة
      final authUrl = Uri.https('github.com', '/login/oauth/authorize', {
        'client_id': _githubClientId,
        'redirect_uri': _githubRedirectUri,
        'scope': 'user:email',
        'state': state,
      });

      // حفظ الـ state للتحقق لاحقاً
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('github_oauth_state', state);

      // فتح المتصفح للمصادقة
      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
        
        // في التطبيق الحقيقي، ستحتاج إلى معالجة الـ callback
        // هنا سنقوم بمحاكاة نجاح العملية
        await Future.delayed(const Duration(seconds: 3));
        
        // محاكاة بيانات المستخدم من GitHub
        final userData = {
          'id': '12345678',
          'login': 'user_example',
          'name': 'مستخدم GitHub',
          'email': 'user@example.com',
          'avatar_url': 'https://avatars.githubusercontent.com/u/12345678',
          'provider': 'github',
        };
        
        // حفظ معلومات المستخدم
        await _saveUserData('github', userData);
        
        return userData;
      } else {
        throw 'لا يمكن فتح رابط المصادقة';
      }
    } catch (error) {
      debugPrint('خطأ في تسجيل الدخول عبر GitHub: $error');
      return null;
    }
  }

  // معالجة callback من GitHub (يجب استدعاؤها عند استقبال الـ callback)
  static Future<Map<String, dynamic>?> handleGitHubCallback(String code, String state) async {
    try {
      // التحقق من الـ state
      final prefs = await SharedPreferences.getInstance();
      final savedState = prefs.getString('github_oauth_state');
      
      if (savedState != state) {
        throw 'State غير متطابق - محاولة هجوم محتملة';
      }

      // تبديل الـ code بـ access token
      final tokenResponse = await http.post(
        Uri.parse('https://github.com/login/oauth/access_token'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': _githubClientId,
          'client_secret': _githubClientSecret,
          'code': code,
        },
      );

      if (tokenResponse.statusCode == 200) {
        final tokenData = json.decode(tokenResponse.body);
        final accessToken = tokenData['access_token'];

        // الحصول على معلومات المستخدم
        final userResponse = await http.get(
          Uri.parse('https://api.github.com/user'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/vnd.github.v3+json',
          },
        );

        if (userResponse.statusCode == 200) {
          final userData = json.decode(userResponse.body);
          userData['provider'] = 'github';
          
          // حفظ معلومات المستخدم
          await _saveUserData('github', userData);
          
          return userData;
        }
      }
      
      return null;
    } catch (error) {
      debugPrint('خطأ في معالجة callback من GitHub: $error');
      return null;
    }
  }

  // حفظ بيانات المستخدم
  static Future<void> _saveUserData(String provider, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_provider', provider);
    await prefs.setString('user_data', json.encode(userData));
    await prefs.setBool('is_logged_in', true);
  }

  // الحصول على بيانات المستخدم المحفوظة
  static Future<Map<String, dynamic>?> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    
    if (isLoggedIn) {
      final userDataString = prefs.getString('user_data');
      final provider = prefs.getString('auth_provider');
      
      if (userDataString != null && provider != null) {
        final userData = json.decode(userDataString);
        userData['provider'] = provider;
        return userData;
      }
    }
    
    return null;
  }

  // تسجيل الخروج
  static Future<void> signOut() async {
    try {
      // مسح البيانات المحفوظة
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_provider');
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('github_oauth_state');
      
    } catch (error) {
      debugPrint('خطأ في تسجيل الخروج: $error');
    }
  }

  // التحقق من حالة تسجيل الدخول
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // إنشاء نص عشوائي للأمان
  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // محاكاة تسجيل الدخول عبر GitHub (للاختبار)
  static Future<Map<String, dynamic>?> mockGitHubSignIn() async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 2));
      
      // مح��كاة بيانات المستخدم
      final userData = {
        'id': '87654321',
        'login': 'github_user',
        'name': 'مستخدم GitHub تجريبي',
        'email': 'github.user@example.com',
        'avatar_url': 'https://avatars.githubusercontent.com/u/87654321',
        'provider': 'github',
      };
      
      // حفظ معلومات المستخدم
      await _saveUserData('github', userData);
      
      return userData;
    } catch (error) {
      debugPrint('خطأ في محاكاة تسجيل الدخول عبر GitHub: $error');
      return null;
    }
  }
}