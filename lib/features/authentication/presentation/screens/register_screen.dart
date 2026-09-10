import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
password: _passwordController.text.trim(),
      );

      final user = credential.user;

if (user == null) {
        throw Exception('Unable to create user.');
      }

      await FirebaseFirestore.instance
.collection('users')
.doc(user.uid)
.set({
        'uid': user.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'student',
        'profileImage': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await user.updateDisplayName(
        _nameController.text.trim(),
      );

if (!mounted) return;

      context.go(AppRoutes.authGate);
    } on FirebaseAuthException catch (e) {
if (!mounted) return;

      _showError(_getFirebaseErrorMessage(e));
    } on FirebaseException catch (e) {
if (!mounted) return;

      _showError(
        e.message ?? 'Unable to save your profile.',
      );
    } catch (e) {
if (!mounted) return;

      _showError(
        'Something went wrong. Please try again.',
      );
    } finally {
if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';

      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return e.message ??
            'Registration failed. Please try again.';
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

  String? _validateName(String? value) {
if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

if (value.trim().length < 2) {
      return 'Enter a valid name';
    }

    return null;
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

  String? _validateConfirmPassword(String? value) {
if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
appBar: AppBar(
        backgroundColor: Colors.white,
elevation: 0,
title: const Text('Create Account'),
      ),
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
                      _buildHeader(),
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
                              controller: _nameController,
label: 'Full Name',
hint: 'Enter your full name',
prefixIcon: Icons.person_outline,
keyboardType: TextInputType.name,
validator: _validateName,
                            ),
const SizedBox(height: 18),
AppTextField(
                              controller: _emailController,
label: 'Email',
hint: 'Enter your email',
prefixIcon: Icons.email_outlined,
keyboardType: TextInputType.emailAddress,
validator: _validateEmail,
                            ),
const SizedBox(height: 18),
_buildPasswordField(),
const SizedBox(height: 18),
_buildConfirmPasswordField(),
const SizedBox(height: 28),
AppButton(
                              text: 'Create Account',
onPressed: _register,
isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
const SizedBox(height: 24),
_buildLoginSection(),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        Container(
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
        ),

const SizedBox(height: 20),

const Text(
          'Join TechCulture 🚀',
style: TextStyle(
            fontSize: 30,
fontWeight: FontWeight.w800,
color: Colors.black,
          ),
        ),

const SizedBox(height: 8),

Text(
          'Create an account to discover, participate, '
          'and celebrate college fests and cultural events.',
style: TextStyle(
            fontSize: 15,
height: 1.5,
color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      controller: _passwordController,
label: 'Password',
hint: 'Create a password',
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

  Widget _buildConfirmPasswordField() {
    return AppTextField(
      controller: _confirmPasswordController,
label: 'Confirm Password',
hint: 'Re-enter your password',
obscureText: _obscureConfirmPassword,
validator: _validateConfirmPassword,
prefixIcon: Icons.lock_reset_outlined,
suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
icon: Icon(
          _obscureConfirmPassword
? Icons.visibility_outlined
: Icons.visibility_off_outlined,
color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
children: [
        Text(
          'Already have an account?',
style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
TextButton(
          onPressed: () {
            context.go(AppRoutes.login);
          },
child: const Text(
            'Login',
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