import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/event_card.dart';
import '../widgets/featured_event_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/welcome_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All',
    'Hackathons',
    'Coding',
    'Workshops',
    'Webinars',
    'Meetups',
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'title': 'AI Innovation Hackathon',
      'organizer': 'Tech Community',
      'date': 'Aug 24, 2026',
      'time': '10:00 AM',
      'location': 'Online',
      'category': 'Hackathons',
      'image': 'assets/images/hackathon.jpg',
      'isOnline': true,
    },
    {
      'title': 'Flutter Development Workshop',
      'organizer': 'Google Developer Group',
      'date': 'Aug 28, 2026',
      'time': '2:00 PM',
      'location': 'Hyderabad',
      'category': 'Workshops',
      'image': 'assets/images/flutter.jpg',
      'isOnline': false,
    },
    {
      'title': 'Data Science & AI Webinar',
      'organizer': 'TechScope',
      'date': 'Sep 02, 2026',
      'time': '6:00 PM',
      'location': 'Online',
      'category': 'Webinars',
      'image': 'assets/images/data_science.jpg',
      'isOnline': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    if (_selectedCategory == 0) {
      return _events;
    }

    final selected = _categories[_selectedCategory];

    return _events
        .where(
          (event) => event['category'] == selected,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: const HomeAppBar(),

      body: RefreshIndicator(
        color: AppTheme.primaryOrange,
        onRefresh: () async {
          await Future.delayed(
            const Duration(milliseconds: 800),
          );
        },

        child: ListView(
          padding: const EdgeInsets.only(
            bottom: 100,
          ),
          children: [
            const WelcomeSection(),

            const SizedBox(height: 20),

            const HomeSearchBar(),

            const SizedBox(height: 24),

            _buildCategories(),

            const SizedBox(height: 28),

            _buildFeaturedEvents(),

            const SizedBox(height: 28),

            _buildUpcomingEvents(),

            const SizedBox(height: 28),

            _buildTrendingEvents(),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Explore Categories',
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 42,

          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            scrollDirection: Axis.horizontal,

            itemCount: _categories.length,

            separatorBuilder: (_, __) {
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

  Widget _buildFeaturedEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Featured Events',
          showViewAll: true,
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 230,

          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            scrollDirection: Axis.horizontal,

            itemCount: _events.length,

            separatorBuilder: (_, __) {
              return const SizedBox(width: 16);
            },

            itemBuilder: (context, index) {
              final event = _events[index];

              return FeaturedEventCard(
                title: event['title'],
                organizer: event['organizer'],
                date: event['date'],
                location: event['location'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    final events = _filteredEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Upcoming Events',
          showViewAll: true,
        ),

        const SizedBox(height: 14),

        if (events.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'No events found in this category.',
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            itemCount: events.length,

            separatorBuilder: (_, __) {
              return const SizedBox(height: 14);
            },

            itemBuilder: (context, index) {
              final event = events[index];

              return EventCard(
                title: event['title'],
                organizer: event['organizer'],
                date: event['date'],
                time: event['time'],
                location: event['location'],
                isOnline: event['isOnline'],
              );
            },
          ),
      ],
    );
  }

  Widget _buildTrendingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Trending Now 🔥',
          showViewAll: true,
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 190,

          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            scrollDirection: Axis.horizontal,

            itemCount: _events.length,

            separatorBuilder: (_, __) {
              return const SizedBox(width: 14);
            },

            itemBuilder: (context, index) {
              final event = _events[index];

              return SizedBox(
                width: 280,

                child: EventCard(
                  title: event['title'],
                  organizer: event['organizer'],
                  date: event['date'],
                  time: event['time'],
                  location: event['location'],
                  isOnline: event['isOnline'],
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
        // Navigation will be connected in a later step.
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
          ),
          label: 'Home',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.explore_outlined,
          ),
          selectedIcon: Icon(
            Icons.explore_rounded,
          ),
          label: 'Explore',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.bookmark_outline_rounded,
          ),
          selectedIcon: Icon(
            Icons.bookmark_rounded,
          ),
          label: 'Saved',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline_rounded,
          ),
          selectedIcon: Icon(
            Icons.person_rounded,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}