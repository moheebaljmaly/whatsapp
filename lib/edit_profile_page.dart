import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'utils/app_colors.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _showPasswordFields = false;
  File? _selectedImage;
  String? _currentAvatar;
  // Map<String, dynamic>? _currentUser; // Removed unused field
  
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
    
    _loadUserData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _nameController.text = user['name'] ?? '';
        _bioController.text = user['bio'] ?? '';
        _currentAvatar = user['avatar'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // تحديث البيانات الأساسية
        final updates = <String, dynamic>{
          'name': _nameController.text.trim(),
          'bio': _bioController.text.trim(),
        };
        
        // إضافة الصورة الجديدة إذا تم اختيارها
        if (_selectedImage != null) {
          // حفظ مسار الصورة المحلية
          updates['avatar'] = _selectedImage!.path;
        }
        
        // تحديث كلمة المرور إذا تم إدخالها
        if (_showPasswordFields && _newPasswordController.text.isNotEmpty) {
          // في التطبيق الحقيقي، سيتم التحقق من كلمة المرور الحالية
          updates['password'] = _newPasswordController.text;
        }
        
        await AuthService.updateUserData(updates);
        
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الملف الشخصي بنجاح!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ في تحديث الملف الشخصي'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
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
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildForm(isDark),
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
          const Expanded(
            child: Text(
              'تحرير الملف الشخصي',
              textAlign: TextAlign.center,
              style: TextStyle(
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

  Widget _buildForm(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Profile Picture Section
            _buildProfilePictureSection(isDark),
            
            const SizedBox(height: 30),
            
            // Name Field
            _buildTextField(
              controller: _nameController,
              label: 'الاسم الكامل',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الاسم';
                }
                return null;
              },
              isDark: isDark,
            ),
            
            const SizedBox(height: 20),
            
            // Bio Field
            _buildTextField(
              controller: _bioController,
              label: 'النبذة الشخصية',
              icon: Icons.info_outline,
              maxLines: 3,
              isDark: isDark,
            ),
            
            const SizedBox(height: 30),
            
            // Change Password Section
            _buildPasswordSection(isDark),
            
            const SizedBox(height: 40),
            
            // Save Button
            _buildSaveButton(isDark),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(bool isDark) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.accentGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : _currentAvatar != null
                            ? _currentAvatar!.startsWith('/')
                                ? Image.file(
                                    File(_currentAvatar!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.textWhite,
                                      );
                                    },
                                  )
                                : Image.network(
                                    _currentAvatar!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.textWhite,
                                      );
                                    },
                                  )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.textWhite,
                              ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.getSurfaceColor(isDark),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.textWhite,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'اضغط لتغيير الصورة الشخصية',
          style: TextStyle(
            color: AppColors.getTextSecondaryColor(isDark),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool obscureText = false,
    Widget? suffixIcon,
    required bool isDark,
  }) {
    return Container(
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
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        obscureText: obscureText,
        style: TextStyle(
          color: AppColors.getTextPrimaryColor(isDark),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          labelStyle: TextStyle(
            color: AppColors.getTextSecondaryColor(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordSection(bool isDark) {
    return Container(
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
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
            ),
            title: Text(
              'تغيير كلمة المرور',
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(isDark),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Switch(
              value: _showPasswordFields,
              onChanged: (value) {
                setState(() {
                  _showPasswordFields = value;
                  if (!value) {
                    _currentPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                  }
                });
              },
              activeColor: AppColors.primary,
            ),
          ),
          if (_showPasswordFields) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    style: TextStyle(
                      color: AppColors.getTextPrimaryColor(isDark),
                    ),
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الحالية',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.getBackgroundColor(isDark),
                      labelStyle: TextStyle(
                        color: AppColors.getTextSecondaryColor(isDark),
                      ),
                    ),
                    validator: _showPasswordFields
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور الحالية';
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    style: TextStyle(
                      color: AppColors.getTextPrimaryColor(isDark),
                    ),
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.getBackgroundColor(isDark),
                      labelStyle: TextStyle(
                        color: AppColors.getTextSecondaryColor(isDark),
                      ),
                    ),
                    validator: _showPasswordFields
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور الجديدة';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: TextStyle(
                      color: AppColors.getTextPrimaryColor(isDark),
                    ),
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور الجديدة',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.getBackgroundColor(isDark),
                      labelStyle: TextStyle(
                        color: AppColors.getTextSecondaryColor(isDark),
                      ),
                    ),
                    validator: _showPasswordFields
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى تأكيد كلمة المرور';
                            }
                            if (value != _newPasswordController.text) {
                              return 'كلمة المرور غير متطابقة';
                            }
                            return null;
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.textWhite,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'حفظ التغييرات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              ),
      ),
    );
  }
}