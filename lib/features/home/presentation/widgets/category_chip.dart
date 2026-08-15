import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryOrange
              : Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: selected
                ? AppTheme.primaryOrange
                : Colors.grey.shade300,
          ),
        ),

        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.grey.shade700,

            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}