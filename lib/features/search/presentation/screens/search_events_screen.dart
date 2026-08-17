import 'package:flutter/material.dart';
import '../../../../../features/events/domain/models/event_model.dart';
import '../../../events/data/services/event_services.dart';

class SearchEventsScreen extends StatefulWidget {
  const SearchEventsScreen({
    super.key,
  });

  @override
  State<SearchEventsScreen> createState() =>
      _SearchEventsScreenState();
}

class _SearchEventsScreenState
    extends State<SearchEventsScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';
  List<EventModel> _results = [];

  bool _isLoading = false;

  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final query = value.trim();

    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _errorMessage = null;
      });

      return;
    }

    _searchEvents(query);
  }

  Future<void> _searchEvents(
  String query,
) async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    final results =
        await EventService.instance.searchEvents(
      query,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _results = results;
      _isLoading = false;
    });
  } catch (e) {
    debugPrint(
      'Search error: $e',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage =
          'Unable to search events.';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Events',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),

            const SizedBox(height: 20),

            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,

      decoration: InputDecoration(
        hintText: 'Search events...',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),

        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();

                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: const Icon(
                  Icons.clear_rounded,
                ),
              )
            : null,

        filled: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
  if (_isLoading) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.orange,
      ),
    );
  }

  if (_errorMessage != null) {
    return Center(
      child: Text(
        _errorMessage!,
      ),
    );
  }

  if (_searchQuery.isEmpty) {
    return _buildSearchEmptyState();
  }

  if (_results.isEmpty) {
    return _buildNoResults();
  }

  return ListView.separated(
    itemCount: _results.length,

    separatorBuilder: (
      context,
      index,
    ) {
      return const SizedBox(
        height: 12,
      );
    },

    itemBuilder: (
      context,
      index,
    ) {
      final event = _results[index];

      return _buildSearchEventCard(
        event,
      );
    },
  );
}

Widget _buildSearchEventCard(
  EventModel event,
) {
  return Card(
    elevation: 0,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: Colors.grey.shade200,
      ),
    ),

    child: InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        // Event details navigation
      },

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,

              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Icon(
                Icons.event_rounded,
                color: Colors.orange.shade700,
                size: 32,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    event.category,
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color:
                            Colors.grey.shade600,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildNoResults() {
  return Center(
    child: Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        Icon(
          Icons.search_off_rounded,
          size: 65,
          color: Colors.orange.shade400,
        ),

        const SizedBox(height: 16),

        const Text(
          'No Events Found',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Try searching with a different keyword.',
          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSearchEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            Icons.search_rounded,
            size: 70,
            color: Colors.orange.shade400,
          ),

          const SizedBox(height: 16),

          const Text(
            'Search for Events',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Find hackathons, workshops, contests and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}