import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../events/data/services/event_services.dart';
import '../../../events/domain/models/event_model.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';

class ExploreEventsScreen extends StatefulWidget {
  const ExploreEventsScreen({super.key});

  @override
  State<ExploreEventsScreen> createState() => _ExploreEventsScreenState();
}

class _ExploreEventsScreenState extends State<ExploreEventsScreen> {
  static const _categories = ['All', 'Hackathons', 'Coding', 'Workshops', 'Webinars', 'Meetups'];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Events'),
        actions: [IconButton(onPressed: () => context.push(AppRoutes.search), icon: const Icon(Icons.search_rounded))],
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: EventService.instance.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Unable to load events.'));
          final events = (snapshot.data ?? []).where((event) => _selectedCategory == 'All' || event.category == _selectedCategory).toList();
          return Column(
            children: [
              SizedBox(
                height: 58,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (_) => setState(() => _selectedCategory = category),
                    );
                  },
                ),
              ),
              Expanded(
                child: events.isEmpty
                    ? const Center(child: Text('No events found in this category.'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _EventListTile(event: events[index]),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const TechScopeBottomNavBar(currentIndex: 1),
    );
  }
}

class _EventListTile extends StatelessWidget {
  const _EventListTile({required this.event});
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(child: Text('${event.date.day}')),
        title: Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('${event.category} • ${event.location}', maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push(AppRoutes.eventDetails, extra: event),
      ),
    );
  }
}
