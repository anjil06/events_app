import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,

      titleSpacing: 20,

      title: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Tech',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: 'Scope',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {
            context.push(AppRoutes.search);
          },
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          onPressed: () {
            context.push(AppRoutes.profile);
          },
          icon: Container(
            height: 40,
            width: 40,

            decoration: BoxDecoration(
              color: AppTheme.lightOrange,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person_outline_rounded,
              color: AppTheme.primaryOrange,
            ),
          ),
        ),

        const SizedBox(width: 12),
      ],
    );
  }
}
