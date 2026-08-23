import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techscope/core/routes/app_routes.dart';

import '../../../../core/theme/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: GestureDetector(
        onTap: (){
          context.push(AppRoutes.search);
        },
        child: AbsorbPointer(
          child: TextField(
            readOnly: true,
          
            decoration: InputDecoration(
              hintText: 'Search events, contests, workshops...',
          
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppTheme.primaryOrange,
              ),
          
              suffixIcon: Container(
                margin: const EdgeInsets.all(6),
          
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
          
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}