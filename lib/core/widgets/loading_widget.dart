import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.size = 30,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(
          color: AppTheme.primaryOrange,
          strokeWidth: 3,
        ),
      ),
    );
  }
}