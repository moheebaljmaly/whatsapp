import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/social_auth_service.dart';

class SocialAuthButtons extends StatefulWidget {
  final VoidCallback? onSuccess;
  final Function(String)? onError;

  const SocialAuthButtons({
    super.key,
    this.onSuccess,
    this.onError,
  });

  @override
  State<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends State<SocialAuthButtons> {
  bool _isGoogleLoading = false;
  bool _isGitHubLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "أو" text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Google Sign In Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: _isGoogleLoading || _isGitHubLoading ? null : _handleGoogleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            icon: _isGoogleLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                    ),
                  )
                : const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                    size: 20,
                  ),
            label: Text(
              _isGoogleLoading ? 'جاري التسجيل...' : 'تسجيل الدخول عبر Google',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // GitHub Sign In Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: _isGoogleLoading || _isGitHubLoading ? null : _handleGitHubSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF24292e),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            icon: _isGitHubLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                    size: 20,
                  ),
            label: Text(
              _isGitHubLoading ? 'جاري التسجيل...' : 'تسجيل الدخول عبر GitHub',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final account = await SocialAuthService.signInWithGoogle();
      
      if (account != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('مرحباً ${account['displayName'] ?? account['email']}!'),
              backgroundColor: const Color(0xFF25D366),
            ),
          );
          widget.onSuccess?.call();
        }
      } else {
        if (mounted) {
          widget.onError?.call('فشل في تسجيل الدخول عبر Google');
        }
      }
    } catch (error) {
      if (mounted) {
        widget.onError?.call('خطأ في تسجيل الدخول عبر Google: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _handleGitHubSignIn() async {
    setState(() {
      _isGitHubLoading = true;
    });

    try {
      // استخدام المحاكاة للاختبار
      final userData = await SocialAuthService.mockGitHubSignIn();
      
      if (userData != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('مرحباً ${userData['name'] ?? userData['login']}!'),
              backgroundColor: const Color(0xFF25D366),
            ),
          );
          widget.onSuccess?.call();
        }
      } else {
        if (mounted) {
          widget.onError?.call('فشل في تسجيل الدخول عبر GitHub');
        }
      }
    } catch (error) {
      if (mounted) {
        widget.onError?.call('خطأ في تسجيل الدخول عبر GitHub: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGitHubLoading = false;
        });
      }
    }
  }
}

// Widget منفصل لأزرار التسجيل السريع
class QuickSocialButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onGitHubPressed;
  final bool isLoading;

  const QuickSocialButtons({
    super.key,
    this.onGooglePressed,
    this.onGitHubPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Google Button
        Expanded(
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onGooglePressed,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                          ),
                        )
                      : const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                          size: 24,
                        ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // GitHub Button
        Expanded(
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF24292e),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onGitHubPressed,
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const FaIcon(
                          FontAwesomeIcons.github,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}