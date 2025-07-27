import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'widgets/social_auth_buttons.dart';
import 'services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  
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
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      // Back Button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // App Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
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
                          size: 50,
                          color: Color(0xFF25D366),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // App Name
                      const Text(
                        'وصل',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'إنشاء ح��اب جديد',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        'انضم إلينا وابدأ المحادثة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Sign Up Form
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
                              // Name Field
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'الاسم الكامل',
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
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
                                    return 'يرجى إدخال الاسم الكامل';
                                  }
                                  if (value.length < 2) {
                                    return 'الاسم يجب أن يكون حرفين على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Username Field
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'اسم المستخدم',
                                  prefixIcon: const Icon(
                                    Icons.alternate_email,
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
                                  helperText: 'مثال: ahmed_mohamed',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال اسم المستخدم';
                                  }
                                  if (!AuthService.isValidUsername(value)) {
                                    return 'اسم المستخدم يجب أن يحتوي على أحرف وأرقام فقط (3-20 حرف)';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20),
                              
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
                                  if (!AuthService.isValidEmail(value)) {
                                    return 'يرجى إدخال بريد إلكتروني صحيح';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Bio Field
                              TextFormField(
                                controller: _bioController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  labelText: 'نبذة عنك (اختياري)',
                                  prefixIcon: const Icon(
                                    Icons.info_outline,
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
                                  helperText: 'اكتب شيئاً عن نفسك',
                                ),
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
                              
                              const SizedBox(height: 20),
                              
                              // Confirm Password Field
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'تأكيد كلمة المرور',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF25D366),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF666666),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                                    return 'يرجى تأكيد كلمة المرور';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'كلمة المرور غير متطابقة';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Terms and Conditions
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                    activeColor: const Color(0xFF25D366),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _agreeToTerms = !_agreeToTerms;
                                        });
                                      },
                                      child: const Text(
                                        'أوافق على الشروط والأحكام وسياسة الخصوصية',
                                        style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Sign Up Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: (_isLoading || !_agreeToTerms) ? null : _handleSignUp,
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
                                          'إنشاء الحساب',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
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
                      
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'لديك حساب بالفعل؟ ',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'تسجيل الدخول',
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

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final result = await AuthService.signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        );
        
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          if (result['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message']),
                backgroundColor: const Color(0xFF25D366),
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
                content: Text(result['message']),
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
}