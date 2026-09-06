import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../bookmarks/data/services/bookmark_service.dart';
import '../../../bookmarks/domain/models/bookmark_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../../home/presentation/widgets/category_chip.dart';

class ExploreEventsScreen extends StatefulWidget {
const ExploreEventsScreen({super.key});

  @override
  State<ExploreEventsScreen> createState() => _ExploreEventsScreenState();
}

class _ExploreEventsScreenState extends State<ExploreEventsScreen> {
static const _categories = [
    'All',
'AI',
'Web Development',
'App Development',
'Cybersecurity',
'Cloud',
'Data Science',
'Blockchain',
'DevOps',
'Programming',
'Startups',
  ];

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

appBar: AppBar(
        title: const Text(
          'Explore TechCulture',
style: TextStyle(
            fontSize: 22,
fontWeight: FontWeight.w800,
          ),
        ),

actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.search);
            },
icon: const Icon(Icons.search_rounded),
          ),

const SizedBox(width: 8),
        ],
      ),

body: StreamBuilder<List<EventModel>>(
        stream: EventService.instance.getEvents(),

builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }

if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load events.',
style: TextStyle(
                  fontSize: 15,
fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final events = (snapshot.data ?? []).where((event) {
if (_selectedCategory == 'All') return true;
            final cat = _selectedCategory.toLowerCase();
            return event.category.toLowerCase() == cat ||
                event.domain.toLowerCase().contains(cat) ||
                (cat == 'ai' && event.domain.toLowerCase().contains('ai'));
          }).toList();

          return Column(
            children: [
              // --------------------------------
              // CATEGORIES
              // --------------------------------
              SizedBox(
                height: 58,

child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
vertical: 8,
                  ),

scrollDirection: Axis.horizontal,

itemCount: _categories.length,

separatorBuilder: (_, index) {
                    return const SizedBox(width: 8);
                  },

itemBuilder: (context, index) {
                    final category = _categories[index];

                    return CategoryChip(
                      label: category,
selected: _selectedCategory == category,
onSelected: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),

              // --------------------------------
              // EVENT FEED
              // --------------------------------
Expanded(
                child: events.isEmpty
? const Center(
                  child: Text(
                    'No events found in this category.',
style: TextStyle(
                      fontSize: 15,
fontWeight: FontWeight.w600,
                    ),
                  ),
                )
: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    16,
8,
16,
24,
                  ),

itemCount: events.length,

separatorBuilder: (_, index) {
                    return const SizedBox(height: 20);
                  },

itemBuilder: (context, index) {
                    return _EventPost(
                      event: events[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              break;
            case 2:
              context.go(AppRoutes.savedEvents);
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

// ============================================================
// EVENT POST
// ============================================================

class _EventPost extends StatefulWidget {
const _EventPost({
    required this.event,
  });

  final EventModel event;

  @override
  State<_EventPost> createState() => _EventPostState();
}

class _EventPostState extends State<_EventPost> {
  bool _isSaved = false;
  bool _isLoading = false;

  EventModel get event => widget.event;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _shareEvent() async {
    final event = widget.event;

    final message = '''
🎉 ${event.title}

📅 ${_formatDate(event.date)}
⏰ ${event.time}
📍 ${event.location}

Join this event on TechCulture!
''';

    await SharePlus.instance.share(
      ShareParams(
        text: message,
      ),
    );
  }

  Future<void> _checkBookmark() async {
    final user = FirebaseAuth.instance.currentUser;

if (user == null || event.id.isEmpty) {
      return;
    }

    try {
      final bookmarked = await BookmarkService.instance.isBookmarked(
        userId: user.uid,
eventId: event.id,
      );

if (!mounted) return;

      setState(() {
        _isSaved = bookmarked;
      });
    } catch (e) {
      debugPrint('Bookmark check error: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    final user = FirebaseAuth.instance.currentUser;

if (user == null || event.id.isEmpty) {
      return;
    }

if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final existingBookmark = await BookmarkService.instance.getBookmark(
        userId: user.uid,
eventId: event.id,
      );

if (existingBookmark != null) {
        await BookmarkService.instance.removeBookmark(
          userId: user.uid,
eventId: event.id,
        );

if (!mounted) return;

        setState(() {
          _isSaved = false;
          _isLoading = false;
        });
      } else {
        final bookmark = BookmarkModel(
          id: '',
userId: user.uid,
eventId: event.id,
eventTitle: event.title,
savedAt: DateTime.now(),
        );

        await BookmarkService.instance.addBookmark(bookmark);

if (!mounted) return;

        setState(() {
          _isSaved = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('BOOKMARK ERROR: $e');

if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
clipBehavior: Clip.antiAlias,

child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
children: [
          GestureDetector(
            onTap: () {
              context.push(
                AppRoutes.eventDetails,
extra: event,
              );
            },
child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
height: 230,
child: _EventImage(
                    imageUrl: event.imageUrl,
                  ),
                ),

                // Category
Positioned(
                  top: 12,
left: 12,
child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
vertical: 6,
                    ),
decoration: BoxDecoration(
                      color: Colors.white,
borderRadius: BorderRadius.circular(10),
                    ),
child: Text(
                      event.category,
style: const TextStyle(
                        color: AppTheme.primaryOrange,
fontSize: 12,
fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Save + Share
Positioned(
                  top: 10,
right: 10,
child: Row(
                    children: [
                      _PostIconButton(
                        icon: _isSaved
? Icons.bookmark_rounded
: Icons.bookmark_border_rounded,
isLoading: _isLoading,
onPressed: _toggleBookmark,
                      ),

const SizedBox(width: 8),

_PostIconButton(
                        icon: Icons.share_rounded,
onPressed: _shareEvent
),
                    ],
                  ),
                ),
              ],
            ),
          ),

Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
14,
16,
16,
            ),
child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
children: [
                Text(
                  event.title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
                    fontSize: 19,
fontWeight: FontWeight.w800,
color: Colors.black,
height: 1.2,
                  ),
                ),

const SizedBox(height: 12),

_EventInfoRow(
                  icon: Icons.calendar_month_rounded,
text:
                  '${_formatDate(event.date)} • ${event.time}',
                ),

const SizedBox(height: 8),

_EventInfoRow(
                  icon: event.isOnline
? Icons.language_rounded
: Icons.location_on_rounded,
text: event.location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
'Feb',
'Mar',
'Apr',
'May',
'Jun',
'Jul',
'Aug',
'Sep',
'Oct',
'Nov',
'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ============================================================
// EVENT IMAGE
// ============================================================

class _EventImage extends StatelessWidget {
const _EventImage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
if (imageUrl.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      imageUrl,

fit: BoxFit.cover,

width: double.infinity,

errorBuilder: (
          context,
 error,
 stackTrace,
          ) {
        return _placeholder();
      },

loadingBuilder: (
          context,
 child,
 loadingProgress,
          ) {
if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: AppTheme.lightOrange,

child: const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryOrange,
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.lightOrange,

child: const Center(
        child: Icon(
          Icons.event_rounded,
size: 70,
color: AppTheme.primaryOrange,
        ),
      ),
    );
  }
}

// ============================================================
// POST ICON BUTTON
// ============================================================

class _PostIconButton extends StatelessWidget {
const _PostIconButton({
    required this.icon,
 required this.onPressed,
 this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
shape: const CircleBorder(),

child: InkWell(
        onTap: isLoading ? null : onPressed,
customBorder: const CircleBorder(),

child: SizedBox(
          height: 40,
width: 40,

child: isLoading
? const Padding(
            padding: EdgeInsets.all(11),
child: CircularProgressIndicator(
              strokeWidth: 2,
color: AppTheme.primaryOrange,
            ),
          )
: Icon(
            icon,
color: AppTheme.primaryOrange,
size: 21,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EVENT INFO ROW
// ============================================================

class _EventInfoRow extends StatelessWidget {
const _EventInfoRow({
    required this.icon,
 required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

children: [
        Icon(
          icon,
size: 19,
color: AppTheme.primaryOrange,
        ),

const SizedBox(width: 8),

Expanded(
          child: Text(
            text,
maxLines: 2,
overflow: TextOverflow.ellipsis,

style: TextStyle(
              fontSize: 14,
color: Colors.grey.shade700,
fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}