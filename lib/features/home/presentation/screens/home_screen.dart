import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/event_card.dart';
import '../widgets/featured_event_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/welcome_section.dart';
import '../../../../features/events/domain/models/event_model.dart';
import '../../../../features/events/data/services/event_services.dart';
import '../../../../features/events/data/mock/techculture_data.dart';
import '../../../../core/routes/app_routes.dart';

import '../../../bookmarks/data/services/bookmark_service.dart';
import '../../../bookmarks/domain/models/bookmark_model.dart';
import '../../../notifications/data/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  final Map<String, bool> _savedEvents = {};
  final Map<String, bool> _bookmarkLoading = {};

  final List<String> _categories = [
    'All',
'Hackathons',
'Coding',
'Workshops',
'Webinars',
'Meetups',
  ];

  @override
  void initState() {
    super.initState();
    _checkUpcomingReminders();
  }

  void _checkUpcomingReminders() {
    final user = FirebaseAuth.instance.currentUser;
if (user != null) {
      NotificationService.instance.checkAndNotifyUpcomingEvents(userId: user.uid);
    }
  }

  Stream<List<EventModel>> get _eventsStream {
    return EventService.instance.getEvents();
  }
  Future<void> _loadSavedEvents(List<EventModel> events) async {
    final user = FirebaseAuth.instance.currentUser;

if (user == null) return;

    for (final event in events) {
if (event.id.isEmpty) continue;

      try {
        final isSaved = await BookmarkService.instance.isBookmarked(
          userId: user.uid,
eventId: event.id,
        );

if (!mounted) return;

        setState(() {
          _savedEvents[event.id] = isSaved;
        });
      } catch (e) {
        debugPrint('LOAD BOOKMARK ERROR: $e');
      }
    }
  }

  Future<void> _toggleBookmark(EventModel event) async {
    final user = FirebaseAuth.instance.currentUser;

if (user == null || event.id.isEmpty) {
      return;
    }

if (_bookmarkLoading[event.id] == true) {
      return;
    }

    final oldValue = _savedEvents[event.id] ?? false;

    // Immediately update UI.
    setState(() {
      _savedEvents[event.id] = !oldValue;
      _bookmarkLoading[event.id] = true;
    });

    try {
if (oldValue) {
        await BookmarkService.instance.removeBookmark(
          userId: user.uid,
eventId: event.id,
        );
      } else {
        final bookmark = BookmarkModel(
          id: '',
userId: user.uid,
eventId: event.id,
eventTitle: event.title,
savedAt: DateTime.now(),
        );

        await BookmarkService.instance.addBookmark(bookmark);
      }
    } catch (e) {
      debugPrint('BOOKMARK ERROR: $e');

      // Firebase failed → restore previous state.
if (!mounted) return;

      setState(() {
        _savedEvents[event.id] = oldValue;
      });
    } finally {
if (mounted) {
        setState(() {
          _bookmarkLoading[event.id] = false;
        });
      }
    }
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
children: [
            const Icon(
              Icons.cloud_off_rounded,
size: 60,
color: AppTheme.primaryOrange,
            ),

const SizedBox(height: 16),

const Text(
              'Unable to load events',
style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

const SizedBox(height: 8),

Text(
              'Please check your internet connection '
              'and try again.',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.grey.shade600),
            ),

const SizedBox(height: 20),

ElevatedButton(
              onPressed: () {
                setState(()  {});
              },
child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
children: [
            const Icon(
              Icons.event_busy_rounded,
size: 64,
color: AppTheme.primaryOrange,
            ),

const SizedBox(height: 16),

const Text(
              'No events available',
style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

const SizedBox(height: 8),

Text(
              'New technical events will appear here.',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

appBar: const HomeAppBar(),

body: RefreshIndicator(
        color: AppTheme.primaryOrange,
onRefresh: () async {
          _checkUpcomingReminders();
          await Future.delayed(const Duration(milliseconds: 800));
        },

child: StreamBuilder<List<EventModel>>(
          stream: _eventsStream,

builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            final events = snapshot.data ?? [];

if (events.isEmpty) {
              return _buildEmptyState();
            }

if (_savedEvents.isEmpty) {
              _loadSavedEvents(events);
            }

            return RefreshIndicator(
              color: AppTheme.primaryOrange,

onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 500));
              },

child: ListView(
                padding: const EdgeInsets.only(bottom: 100),

children: [
                  const WelcomeSection(),

const SizedBox(height: 20),

const HomeSearchBar(),

const SizedBox(height: 28),

_buildTrendingTech(),

const SizedBox(height: 28),

_buildLatestStories(),

const SizedBox(height: 28),

_buildCategories(),

const SizedBox(height: 24),

_buildFeaturedEvents(events),

const SizedBox(height: 28),

_buildUpcomingEvents(events),

const SizedBox(height: 28),

_buildTrendingEvents(events),
                ],
              ),
            );
          },
        ),
      ),

bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTrendingTech() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        const SectionHeader(title: 'Trending Tech 🔥'),
const SizedBox(height: 14),
SizedBox(
          height: 130,
child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
scrollDirection: Axis.horizontal,
itemCount: TechCultureData.trendingTopics.length,
separatorBuilder: (_, index) => const SizedBox(width: 14),
itemBuilder: (context, index) {
              final topic = TechCultureData.trendingTopics[index];
              return InkWell(
                borderRadius: BorderRadius.circular(18),
onTap: () {
                  context.push(AppRoutes.explore);
                },
child: Container(
                  width: 180,
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
                    color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: Colors.grey.shade200),
boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
blurRadius: 10,
offset: const Offset(0, 4),
                      ),
                    ],
                  ),
child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
                          Container(
                            height: 38,
width: 38,
decoration: BoxDecoration(
                              color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(10),
                            ),
child: Icon(
                              topic.icon,
color: AppTheme.primaryOrange,
size: 20,
                            ),
                          ),
Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
vertical: 3,
                            ),
decoration: BoxDecoration(
                              color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(8),
                            ),
child: Text(
                              '${topic.postCount}+',
style: const TextStyle(
                                color: AppTheme.primaryOrange,
fontSize: 11,
fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
children: [
                          Text(
                            topic.title,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
                              fontSize: 14,
fontWeight: FontWeight.w700,
color: Colors.black,
                            ),
                          ),
const SizedBox(height: 3),
Text(
                            topic.subtitle,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
                              fontSize: 11,
color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestStories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        const SectionHeader(title: 'Latest Tech Stories 📖'),
const SizedBox(height: 14),
SizedBox(
          height: 240,
child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
scrollDirection: Axis.horizontal,
itemCount: TechCultureData.latestStories.length,
separatorBuilder: (_, index) => const SizedBox(width: 16),
itemBuilder: (context, index) {
              final story = TechCultureData.latestStories[index];
              return InkWell(
                borderRadius: BorderRadius.circular(18),
onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening story: ${story.title}'),
duration: const Duration(seconds: 1),
                    ),
                  );
                },
child: Container(
                  width: 270,
decoration: BoxDecoration(
                    color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: Colors.grey.shade200),
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
                      Stack(
                        children: [
                          Image.network(
                            story.imageUrl,
height: 120,
width: 270,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) => Container(
                              height: 120,
color: AppTheme.lightOrange,
child: const Center(
                                child: Icon(
                                  Icons.article_rounded,
color: AppTheme.primaryOrange,
size: 32,
                                ),
                              ),
                            ),
                          ),
Positioned(
                            top: 8,
left: 8,
child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
vertical: 4,
                              ),
decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
borderRadius: BorderRadius.circular(6),
                              ),
child: Text(
                                story.category,
style: const TextStyle(
                                  color: Colors.white,
fontSize: 10,
fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
Padding(
                        padding: const EdgeInsets.all(12),
child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
children: [
                            Text(
                              story.title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
                                fontSize: 14,
fontWeight: FontWeight.w700,
height: 1.25,
                              ),
                            ),
const SizedBox(height: 8),
Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
                                Text(
                                  '${story.author} • ${story.readTime}',
style: TextStyle(
                                    fontSize: 11,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
                                  ),
                                ),
Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite_rounded,
size: 13,
color: AppTheme.primaryOrange,
                                    ),
const SizedBox(width: 3),
Text(
                                      '${story.likes}',
style: TextStyle(
                                        fontSize: 11,
color: Colors.grey.shade700,
fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        const SectionHeader(title: 'Explore Categories'),
const SizedBox(height: 14),
SizedBox(
          height: 42,
child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
scrollDirection: Axis.horizontal,
itemCount: _categories.length,
separatorBuilder: (_, index) {
              return const SizedBox(width: 10);
            },
itemBuilder: (context, index) {
              return CategoryChip(
                label: _categories[index],
selected: _selectedCategory == index,
onSelected: () {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedEvents(List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        const SectionHeader(title: 'Featured Events', showViewAll: true),

const SizedBox(height: 14),

SizedBox(
          height: 230,

child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),

scrollDirection: Axis.horizontal,

itemCount: events.length,

separatorBuilder: (_, index) {
              return const SizedBox(width: 16);
            },

itemBuilder: (context, index) {
              final event = events[index];

              return FeaturedEventCard(
                event: event,
isSaved: _savedEvents[event.id] ?? false,
isBookmarkLoading: _bookmarkLoading[event.id] ?? false,
onBookmarkPressed: () {
                  _toggleBookmark(event);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(List<EventModel> events) {
    final filteredEvents = _selectedCategory == 0
? events
: events
.where(
(event) => event.category == _categories[_selectedCategory],
              )
.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        const SectionHeader(title: 'Upcoming Events', showViewAll: true),

const SizedBox(height: 14),

if (filteredEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
child: Text('No events found in this category.'),
          )
        else
          ListView.separated(
            shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),

padding: const EdgeInsets.symmetric(horizontal: 20),

itemCount: filteredEvents.length,

separatorBuilder: (_, index) {
              return const SizedBox(height: 14);
            },

itemBuilder: (context, index) {
              final event = filteredEvents[index];

              return EventCard(
                event: event,
isSaved: _savedEvents[event.id] ?? false,
isBookmarkLoading: _bookmarkLoading[event.id] ?? false,
onBookmarkPressed: () {
                  _toggleBookmark(event);
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildTrendingEvents(List<EventModel> events) {
if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        const SectionHeader(title: 'Trending Now 🔥', showViewAll: true),

const SizedBox(height: 14),

SizedBox(
          height: 135,

child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),

scrollDirection: Axis.horizontal,

itemCount: events.length,

separatorBuilder: (_, index) {
              return const SizedBox(width: 14);
            },

itemBuilder: (context, index) {
              final event = events[index];

              return SizedBox(
                width: 310,
child: EventCard(
                  event: event,
isSaved: _savedEvents[event.id] ?? false,
isBookmarkLoading: _bookmarkLoading[event.id] ?? false,
onBookmarkPressed: () {
                    _toggleBookmark(event);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: 0,

onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go(AppRoutes.home);
            break;

          case 1:
            context.go(AppRoutes.explore);
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
    );
  }
}
