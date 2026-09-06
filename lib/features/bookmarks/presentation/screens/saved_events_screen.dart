import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../data/services/bookmark_service.dart';
import '../../domain/models/bookmark_model.dart';

class SavedEventsScreen extends StatelessWidget {
const SavedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view saved events.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

appBar: AppBar(
        elevation: 0,
backgroundColor: Colors.white,
surfaceTintColor: Colors.transparent,
titleSpacing: 20,
title: const Text(
          'Saved',
style: TextStyle(
            fontSize: 22,
fontWeight: FontWeight.w700,
color: Color(0xFF1F1F1F),
          ),
        ),
      ),

body: StreamBuilder<List<BookmarkModel>>(
        stream: BookmarkService.instance.getUserBookmarks(user.uid),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }

if (snapshot.hasError) {
            return const _ErrorState();
          }

          final bookmarks = snapshot.data ?? [];

if (bookmarks.isEmpty) {
            return _EmptySavedEvents(
              onExplore: () => context.go(AppRoutes.explore),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
itemCount: bookmarks.length,
separatorBuilder: (_, index) => const SizedBox(height: 14),
itemBuilder: (context, index) {
              return _SavedEventTile(
                bookmark: bookmarks[index],
userId: user.uid,
              );
            },
          );
        },
      ),

bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.explore);
              break;
            case 2:
              break;
            case 3:
              context.go(AppRoutes.profile);
              break;
          }
        },
destinations: const[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
selectedIcon: Icon(Icons.home_rounded),
label: 'Home',
          ),
NavigationDestination(
            icon: Icon(Icons.explore_outlined),
selectedIcon: Icon(Icons.explore_rounded),
label: 'Explore',
          ),
NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
selectedIcon: Icon(Icons.bookmark_rounded),
label: 'Saved',
          ),
NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
selectedIcon: Icon(Icons.person_rounded),
label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _SavedEventTile extends StatelessWidget {
const _SavedEventTile({
    required this.bookmark,
 required this.userId,
  });

  final BookmarkModel bookmark;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventModel?>(
      future: EventService.instance.getEventById(bookmark.eventId),
builder: (context, snapshot) {
        final event = snapshot.data;

        return Material(
          color: Colors.white,
borderRadius: BorderRadius.circular(18),
child: InkWell(
            borderRadius: BorderRadius.circular(18),
onTap: event == null
? null
: () => context.push(
              AppRoutes.eventDetails,
extra: event,
            ),
child: Container(
              padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
border: Border.all(
                  color: Colors.grey.shade200,
                ),
boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
blurRadius: 10,
offset: const Offset(0, 4),
                  ),
                ],
              ),
child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
children: [
                  _EventImage(
                    event: event,
                  ),

const SizedBox(width: 14),

Expanded(
                    child: _EventContent(
                      event: event,
bookmark: bookmark,
                    ),
                  ),

const SizedBox(width: 6),

IconButton(
                    tooltip: 'Remove saved event',
onPressed: () => _removeBookmark(context),
padding: EdgeInsets.zero,
constraints: const BoxConstraints(
                      minWidth: 36,
minHeight: 36,
                    ),
icon: const Icon(
                      Icons.bookmark_rounded,
color: AppTheme.primaryOrange,
size: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeBookmark(BuildContext context) async {
    try {
      await BookmarkService.instance.removeBookmark(
        userId: userId,
eventId: bookmark.eventId,
      );

if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Removed from saved events'),
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (_) {
if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unable to remove saved event'),
behavior: SnackBarBehavior.floating,
backgroundColor: Colors.red.shade700,
shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}

class _EventImage extends StatelessWidget {
const _EventImage({
    required this.event,
  });

  final EventModel? event;

  @override
  Widget build(BuildContext context) {
    // Change `event.imageUrl` to your actual EventModel image field.
    final imageUrl = event?.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
child: Container(
        width: 82,
height: 92,
color: AppTheme.lightOrange,
child: imageUrl != null && imageUrl.isNotEmpty
? Image.network(
          imageUrl,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
            return const _EventPlaceholder();
          },
        )
: const _EventPlaceholder(),
      ),
    );
  }
}

class _EventPlaceholder extends StatelessWidget {
const _EventPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.event_rounded,
size: 34,
color: AppTheme.primaryOrange,
      ),
    );
  }
}

class _EventContent extends StatelessWidget {
const _EventContent({
    required this.event,
 required this.bookmark,
  });

  final EventModel? event;
  final BookmarkModel bookmark;

  @override
  Widget build(BuildContext context) {
if (event == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
children: [
          Text(
            bookmark.eventTitle,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
              fontSize: 16,
fontWeight: FontWeight.w700,
color: Color(0xFF222222),
            ),
          ),
const SizedBox(height: 8),
Text(
            'Event details are no longer available',
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
              fontSize: 12,
color: Colors.grey.shade600,
            ),
          ),
        ],
      );
    }

    final date = event!.date;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        Text(
          event!.title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
            fontSize: 16,
height: 1.25,
fontWeight: FontWeight.w700,
color: Color(0xFF1F1F1F),
          ),
        ),

const SizedBox(height: 10),

Row(
          children: [
            const Icon(
              Icons.calendar_month_rounded,
size: 15,
color: AppTheme.primaryOrange,
            ),
const SizedBox(width: 5),
Expanded(
              child: Text(
                '${date.day}/${date.month}/${date.year}',
style: TextStyle(
                  fontSize: 12,
fontWeight: FontWeight.w500,
color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),

const SizedBox(height: 6),

Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
size: 15,
color: AppTheme.primaryOrange,
            ),
const SizedBox(width: 5),
Expanded(
              child: Text(
                event!.location,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
                  fontSize: 12,
color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptySavedEvents extends StatelessWidget {
const _EmptySavedEvents({
    required this.onExplore,
  });

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
child: Column(
          mainAxisSize: MainAxisSize.min,
children: [
            Container(
              width: 92,
height: 92,
decoration: BoxDecoration(
                color: AppTheme.lightOrange,
shape: BoxShape.circle,
              ),
child: const Icon(
                Icons.bookmark_border_rounded,
size: 46,
color: AppTheme.primaryOrange,
              ),
            ),

const SizedBox(height: 22),

const Text(
              'No Saved Items',
textAlign: TextAlign.center,
style: TextStyle(
                fontSize: 21,
fontWeight: FontWeight.w700,
color: Color(0xFF222222),
              ),
            ),

const SizedBox(height: 8),

Text(
              'Save technology articles, events, posts, and resources you are interested in and find them here anytime.',
textAlign: TextAlign.center,
style: TextStyle(
                fontSize: 14,
height: 1.45,
color: Colors.grey.shade600,
              ),
            ),

const SizedBox(height: 22),

SizedBox(
              height: 46,
child: ElevatedButton.icon(
                onPressed: onExplore,
icon: const Icon(
                  Icons.explore_outlined,
size: 19,
                ),
label: const Text(
                  'Explore TechCulture',
style: TextStyle(
                    fontSize: 14,
fontWeight: FontWeight.w600,
                  ),
                ),
style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
child: Column(
          mainAxisSize: MainAxisSize.min,
children: [
            Icon(
              Icons.cloud_off_rounded,
size: 50,
color: Colors.grey.shade400,
            ),
const SizedBox(height: 14),
const Text(
              'Something went wrong',
style: TextStyle(
                fontSize: 17,
fontWeight: FontWeight.w700,
              ),
            ),
const SizedBox(height: 6),
Text(
              'Unable to load your saved events.',
textAlign: TextAlign.center,
style: TextStyle(
                fontSize: 13,
color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}