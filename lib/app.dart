import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class TechCultureApp extends StatelessWidget {
const TechCultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TechCulture',
debugShowCheckedModeBanner: false,

theme: AppTheme.theme,

routerConfig: AppRoutes.router,
    );
  }
}

// Retain alias for backward compatibility if referenced elsewhere
typedef TechScopeApp = TechCultureApp;