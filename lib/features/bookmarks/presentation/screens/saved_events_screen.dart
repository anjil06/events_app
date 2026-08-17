import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/services/bookmark_service.dart';
import '../../domain/models/bookmark_model.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';

class SavedEventsScreen extends StatelessWidget {
  const SavedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view saved events.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Events')),

      body: StreamBuilder<List<BookmarkModel>>(
  stream: BookmarkService.instance
      .getUserBookmarks(user.uid),

  builder: (context, snapshot) {
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      debugPrint(
        'SAVED EVENTS ERROR: ${snapshot.error}',
      );

      return Center(
        child: Text(
          'Unable to load saved events',
        ),
      );
    }

    final bookmarks =
        snapshot.data ?? [];

    if (bookmarks.isEmpty) {
      return const Center(
        child: Text(
          'No Saved Events',
        ),
      );
    }

    return ListView.builder(
      itemCount: bookmarks.length,

      itemBuilder: (context, index) {
        final bookmark =
            bookmarks[index];

        return ListTile(
          leading: const Icon(
            Icons.event,
          ),

          title: Text(
            bookmark.eventTitle,
          ),

          trailing: const Icon(
            Icons.bookmark,
          ),
        );
      },
    );
  },
),
      bottomNavigationBar: TechScopeBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildBookmarkCard(BuildContext context, BookmarkModel bookmark) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,

            decoration: BoxDecoration(
              color: AppTheme.lightOrange,
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.event_rounded,
              color: AppTheme.primaryOrange,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              bookmark.eventTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),

          const Icon(Icons.bookmark_rounded, color: AppTheme.primaryOrange),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.bookmark_border_rounded,
              size: 70,
              color: AppTheme.primaryOrange,
            ),

            const SizedBox(height: 18),

            const Text(
              'No Saved Events',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 8),

            Text(
              'Events you bookmark will appear here.',
              textAlign: TextAlign.center,

              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text(
        'Unable to load saved events.',
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }
}
