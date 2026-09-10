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
            'Hello, Fest & Tech Explorer 👋',
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
            'Discover. Code. Celebrate. Perform.',
style: TextStyle(
              fontSize: 15,
fontWeight: FontWeight.w700,
color: AppTheme.primaryOrange,
            ),
          ),

const SizedBox(height: 6),

Text(
            'Your all-in-one hub for technical hackathons, coding contests, '
            'college fests, dance, music, and cultural celebrations.',
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