import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'user_profile_page.dart';
import 'home_page.dart';
import 'widgets/social_auth_buttons.dart';
import 'services/auth_service.dart';
import 'utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      begin: const Offset(0, 0.5),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // WhatsApp Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chat,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // App Name
                      const Text(
                        'وصل',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'تطبيق المراسلة الذكي',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      const Text(
                        'مرحباً بك',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'سجل دخولك للمتابعة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Login Form
                      Container(
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email Field
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF25D366),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال البريد الإلكتروني';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'يرجى إدخال بريد إلكتروني صحيح';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF25D366),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF666666),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال كلمة المرور';
                                  }
                                  if (value.length < 6) {
                                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'تسجيل الدخول',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Forgot Password
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    color: Color(0xFF25D366),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Social Authentication Buttons
                      SocialAuthButtons(
                        onSuccess: () {
                          // Navigate to user profile page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserProfilePage(),
                            ),
                          );
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Demo Accounts Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'حسابات تجريبية للاختبار',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'كلمة المرور لجميع الحسابات: 123456',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildDemoButton('admin@wasl.com'),
                                _buildDemoButton('user@wasl.com'),
                                _buildDemoButton('test@wasl.com'),
                                _buildDemoButton('demo@wasl.com'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ليس لديك حساب؟ ',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'إنشاء حساب',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final result = await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          if (result != null && result['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الدخول بنجاح!'),
                backgroundColor: Color(0xFF25D366),
              ),
            );
            
            // الانتقال إلى الصفحة الرئيسية
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result?['message'] ?? 'حدث خطأ في تسجيل الدخول'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ في الاتصال'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildDemoButton(String email) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _emailController.text = email;
          _passwordController.text = '123456';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        email.split('@')[0],
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}