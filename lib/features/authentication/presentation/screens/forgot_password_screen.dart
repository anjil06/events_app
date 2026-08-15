import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      _showSuccess();

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _showError(
        _getFirebaseErrorMessage(e),
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

  String _getFirebaseErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return e.message ??
            'Unable to send reset email.';
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          icon: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppTheme.lightOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              color: AppTheme.primaryOrange,
              size: 34,
            ),
          ),

          title: const Text(
            'Check Your Email',
            textAlign: TextAlign.center,
          ),

          content: Text(
            'We sent a password reset link to '
            '${_emailController.text.trim()}. '
            'Please check your inbox and follow the instructions.',
            textAlign: TextAlign.center,
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.login);
                },
                child: const Text('Back to Login'),
              ),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Forgot Password'),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 30),

                      _buildHeader(),

                      const SizedBox(height: 36),

                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your registered email',
                        keyboardType:
                            TextInputType.emailAddress,
                        prefixIcon:
                            Icons.email_outlined,
                        validator: _validateEmail,
                      ),

                      const SizedBox(height: 28),

                      AppButton(
                        text: 'Send Reset Link',
                        onPressed: _sendResetEmail,
                        isLoading: _isLoading,
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            context.go(
                              AppRoutes.login,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                          ),
                          label: const Text(
                            'Back to Login',
                          ),
                        ),
                      ),
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
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          height: 72,
          width: 72,

          decoration: BoxDecoration(
            color: AppTheme.lightOrange,
            borderRadius: BorderRadius.circular(20),
          ),

          child: const Icon(
            Icons.lock_reset_rounded,
            color: AppTheme.primaryOrange,
            size: 40,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Reset Your Password',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Enter your registered email address and '
          'we will send you a link to reset your password.',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}