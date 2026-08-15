import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class TechScopeApp extends StatelessWidget {
  const TechScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TechScope',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.theme,

      routerConfig: AppRoutes.router,
    );
  }
}