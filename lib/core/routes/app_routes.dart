import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/auth_gate.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/events/presentation/screens/event_details_screen.dart';
import '../../features/events/domain/models/event_model.dart';
import '../../features/bookmarks/presentation/screens/saved_events_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String authGate = '/auth-gate';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String explore = "/explore";
  static const String profile = '/profile';
  static const String eventDetails = '/event-details';
  static const String savedEvents = '/saved-events';

  static final GoRouter router = GoRouter(
    initialLocation: splash,

    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: authGate,
        builder: (context, state) {
          return const AuthGate();
        },
      ),

      GoRoute(
        path: login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        path: register,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      GoRoute(
        path: forgotPassword,
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),

      GoRoute(
        path: home,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: profile,
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Profile Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: eventDetails,
        builder: (context, state) {
          final event = state.extra as EventModel;

          return EventDetailsScreen(event: event);
        },
      ),
      GoRoute(
        path: explore,
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Explore",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: savedEvents,
        builder: (context, state) {
          return const SavedEventsScreen();
        },
      ),
    ],
  );
}
