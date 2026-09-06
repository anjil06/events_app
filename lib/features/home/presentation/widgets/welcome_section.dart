import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WelcomeSection extends StatelessWidget {
const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
20,
20,
0,
      ),

child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

children: [
          Text(
            'Hello, Developer 👋',
style: TextStyle(
              fontSize: 16,
color: Colors.grey.shade600,
            ),
          ),

const SizedBox(height: 6),

const Text(
            'Welcome to\nTechCulture',
style: TextStyle(
              fontSize: 28,
height: 1.15,
fontWeight: FontWeight.w800,
color: Colors.black,
            ),
          ),

const SizedBox(height: 8),

const Text(
            'Discover. Learn. Connect. Build.',
style: TextStyle(
              fontSize: 15,
fontWeight: FontWeight.w700,
color: AppTheme.primaryOrange,
            ),
          ),

const SizedBox(height: 6),

Text(
            'Your home for developer communities, tech trends, '
            'hackathons, and software culture.',
style: TextStyle(
              fontSize: 14,
color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
} 