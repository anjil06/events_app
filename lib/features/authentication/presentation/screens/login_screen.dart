import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.login(
        email: _emailController.text.trim(),
password: _passwordController.text.trim(),
      );

if (!mounted) return;

      context.go(AppRoutes.authGate);
    } on FirebaseAuthException catch (e) {
if (!mounted) return;

      _showError(_getFirebaseErrorMessage(e));
    } catch (e) {
if (!mounted) return;

      _showError('Something went wrong. Please try again.');
    } finally {
if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
backgroundColor: Colors.red.shade700,
behavior: SnackBarBehavior.floating,
margin: const EdgeInsets.all(16),
      ),
    );
  }

  String? _validateEmail(String? value) {
if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
if (value == null || value.isEmpty) {
      return 'Password is required';
    }

if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
vertical: 24,
              ),
child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
child: Form(
                  key: _formKey,
child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
children: [
                      const SizedBox(height: 12),
_buildLogo(),
const SizedBox(height: 24),
const Text(
                        'Welcome Back 👋',
style: TextStyle(
                          fontSize: 30,
fontWeight: FontWeight.w800,
color: Colors.black,
                        ),
                      ),
const SizedBox(height: 8),
Text(
                        'Login to connect with the TechCulture community.',
style: TextStyle(
                          fontSize: 15,
color: Colors.grey.shade600,
                        ),
                      ),
const SizedBox(height: 28),
Container(
                        padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
                          color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(color: Colors.grey.shade200),
boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
blurRadius: 12,
offset: const Offset(0, 4),
                            ),
                          ],
                        ),
child: Column(
                          children: [
                            AppTextField(
                              controller: _emailController,
label: 'Email',
hint: 'Enter your email',
keyboardType: TextInputType.emailAddress,
prefixIcon: Icons.email_outlined,
validator: _validateEmail,
                            ),
const SizedBox(height: 18),
_buildPasswordField(),
const SizedBox(height: 10),
Align(
                              alignment: Alignment.centerRight,
child: TextButton(
                                onPressed: () {
                                  context.push(
                                    AppRoutes.forgotPassword,
                                  );
                                },
child: const Text(
                                  'Forgot Password?',
style: TextStyle(
                                    color: AppTheme.primaryOrange,
fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
const SizedBox(height: 14),
AppButton(
                              text: 'Login',
onPressed: _login,
isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
const SizedBox(height: 28),
_buildRegisterSection(),
const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 64,
width: 64,
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
        color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(18),
      ),
child: Image.asset(
        'assets/images/techculture_icon_mark.png',
fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      controller: _passwordController,
label: 'Password',
hint: 'Enter your password',
obscureText: _obscurePassword,
validator: _validatePassword,
prefixIcon: Icons.lock_outline_rounded,
suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
icon: Icon(
          _obscurePassword
? Icons.visibility_outlined
: Icons.visibility_off_outlined,
color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
children: [
        Text(
          "Don't have an account?",
style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),

TextButton(
          onPressed: () {
            context.push(
              AppRoutes.register,
            );
          },
child: const Text(
            'Register',
style: TextStyle(
              color: AppTheme.primaryOrange,
fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}