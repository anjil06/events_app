import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';
import '../../data/services/bookmark_service.dart';
import '../../domain/models/bookmark_model.dart';

class SavedEventsScreen extends StatelessWidget {
  const SavedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please log in to view saved events.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Events')),
      body: StreamBuilder<List<BookmarkModel>>(
        stream: BookmarkService.instance.getUserBookmarks(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Unable to load saved events.'));
          final bookmarks = snapshot.data ?? [];
          if (bookmarks.isEmpty) return _EmptySavedEvents(onExplore: () => context.go(AppRoutes.explore));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _SavedEventTile(bookmark: bookmarks[index], userId: user.uid),
          );
        },
      ),
      bottomNavigationBar: const TechScopeBottomNavBar(currentIndex: 2),
    );
  }
}

class _SavedEventTile extends StatelessWidget {
  const _SavedEventTile({required this.bookmark, required this.userId});
  final BookmarkModel bookmark;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventModel?>(
      future: EventService.instance.getEventById(bookmark.eventId),
      builder: (context, snapshot) {
        final event = snapshot.data;
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: const CircleAvatar(
              backgroundColor: AppTheme.lightOrange,
              child: Icon(Icons.event_rounded, color: AppTheme.primaryOrange),
            ),
            title: Text(event?.title ?? bookmark.eventTitle, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(event == null ? 'Event details are no longer available' : '${event.date.day}/${event.date.month}/${event.date.year} • ${event.location}', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: event == null ? null : () => context.push(AppRoutes.eventDetails, extra: event),
            trailing: IconButton(
              tooltip: 'Remove saved event',
              icon: const Icon(Icons.bookmark_remove_outlined),
              onPressed: () => _removeBookmark(context),
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeBookmark(BuildContext context) async {
    try {
      await BookmarkService.instance.removeBookmark(userId: userId, eventId: bookmark.eventId);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from saved events.')));
    } catch (_) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to remove saved event.')));
    }
  }
}

class _EmptySavedEvents extends StatelessWidget {
  const _EmptySavedEvents({required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border_rounded, size: 70, color: AppTheme.primaryOrange),
            const SizedBox(height: 18),
            const Text('No Saved Events', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Save an event to find it quickly later.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onExplore, child: const Text('Explore events')),
          ],
        ),
      ),
    );
  }
}
