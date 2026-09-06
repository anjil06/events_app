import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    Timer(
      const Duration(seconds: 3),
_navigateToNextScreen,
    );
  }

  void _navigateToNextScreen() {
if (!mounted) return;

    context.go(AppRoutes.authGate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryOrange,

body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundDecorations(),

Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
child: FadeTransition(
                      opacity: _fadeAnimation,
child: _buildLogo(),
                    ),
                  ),

const SizedBox(height: 24),

SlideTransition(
                    position: _slideAnimation,
child: FadeTransition(
                      opacity: _fadeAnimation,
child: Column(
                        children: [
                          const Text(
                            AppConstants.appName,
style: TextStyle(
                              fontSize: 36,
fontWeight: FontWeight.w800,
letterSpacing: 1.2,
color: Colors.white,
                            ),
                          ),

const SizedBox(height: 8),

Text(
                            AppConstants.appTagline,
textAlign: TextAlign.center,
style: TextStyle(
                              fontSize: 14,
color: Colors.white.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

Positioned(
              left: 0,
right: 0,
bottom: 40,
child: FadeTransition(
                opacity: _fadeAnimation,
child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
width: 24,
child: CircularProgressIndicator(
                        strokeWidth: 2.5,
color: Colors.white,
                      ),
                    ),

const SizedBox(height: 12),

Text(
                      'Loading...',
style: TextStyle(
                        fontSize: 12,
color: Colors.white.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 110,
width: 110,
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
        color: Colors.white,
borderRadius: BorderRadius.circular(30),
boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
blurRadius: 25,
offset: const Offset(0, 10),
          ),
        ],
      ),
child: Center(
        child: Image.asset(
          'assets/images/techculture_icon_mark.png',
fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
right: -60,
child: _circle(
              size: 200,
opacity: 0.12,
            ),
          ),

Positioned(
            bottom: -100,
left: -80,
child: _circle(
              size: 250,
opacity: 0.12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle({
    required double size,
 required double opacity,
  }) {
    return Container(
      height: size,
width: size,
decoration: BoxDecoration(
        shape: BoxShape.circle,
color: Colors.white.withValues(
          alpha: opacity,
        ),
      ),
    );
  }
}