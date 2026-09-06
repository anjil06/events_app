import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../registrations/data/services/registration_service.dart';
import '../../../registrations/domain/models/registration_model.dart';
import '../../../bookmarks/data/services/bookmark_service.dart';
import '../../../bookmarks/domain/models/bookmark_model.dart';
import '../../../notifications/data/services/notification_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isSaved = false;
  bool isRegistering = false;
  bool isRegistered = false;
  bool isBookmarkLoading = false;

  @override
  void initState() {
    super.initState();

    debugPrint('EVENT ID : ${widget.event.id}');
    _checkRegistration();
    _checkBookmark();
  }

  Future<void> _checkRegistration() async {
    final user = FirebaseAuth.instance.currentUser;

if (user == null) {
      return;
    }

    try {
      final registered = await RegistrationService.instance.isUserRegistered(
        userId: user.uid,
eventId: widget.event.id,
      );

if (!mounted) {
        return;
      }

      setState(() {
        isRegistered = registered;
      });
    } catch (e) {
      debugPrint('Registration check failed: $e');
    }
  }

  Future<void> _toggleBookmark() async {
  final user =
      FirebaseAuth.instance.currentUser;

if (user == null) {
    _showMessage(
      'Please login to save events.',
    );
    return;
  }

if (widget.event.id.isEmpty) {
    _showMessage(
      'Unable to save this event.',
    );

    debugPrint(
      'ERROR: Event ID is empty',
    );

    return;
  }

  setState(() {
    isBookmarkLoading = true;
  });

  try {
    final bookmark =
        await BookmarkService.instance
.getBookmark(
      userId: user.uid,
eventId: widget.event.id,
    );

if (bookmark != null) {
      // REMOVE BOOKMARK

      await BookmarkService.instance
.removeBookmark(
        userId: user.uid,
eventId: widget.event.id,
      );

if (!mounted) {
        return;
      }

      setState(() {
        isSaved = false;
        isBookmarkLoading = false;
      });

      _showMessage(
        'Removed from saved events.',
      );
    } else {
      // ADD BOOKMARK

      final newBookmark =
          BookmarkModel(
        id: '',
userId: user.uid,
eventId: widget.event.id,
eventTitle: widget.event.title,
savedAt: DateTime.now(),
      );

      await BookmarkService.instance
.addBookmark(
        newBookmark,
      );

if (!mounted) {
        return;
      }

      setState(() {
        isSaved = true;
        isBookmarkLoading = false;
      });

      _showMessage(
        'Event saved successfully! 🔖',
      );
    }
  } catch (e) {
if (!mounted) {
      return;
    }

    setState(() {
      isBookmarkLoading = false;
    });

    debugPrint(
      'BOOKMARK ERROR: $e',
    );

    _showMessage(
      'Unable to update saved event.',
    );
  }
}

  Future<void> _checkBookmark() async {
  final user =
      FirebaseAuth.instance.currentUser;

if (user == null) {
    return;
  }

if (widget.event.id.isEmpty) {
    debugPrint(
      'ERROR: Event ID is empty',
    );
    return;
  }

  try {
    final bookmarked =
        await BookmarkService.instance
.isBookmarked(
      userId: user.uid,
eventId: widget.event.id,
    );

if (!mounted) {
      return;
    }

    setState(() {
      isSaved = bookmarked;
    });

    debugPrint(
      'Bookmark status: $bookmarked',
    );
  } catch (e) {
    debugPrint(
      'Bookmark check error: $e',
    );
  }
}

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

body: CustomScrollView(
        slivers: [
          _buildAppBar(event),

SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
children: [
                  _buildCategory(event),

const SizedBox(height: 14),

_buildTitle(event),

const SizedBox(height: 20),

_buildOrganizer(event),

const SizedBox(height: 24),

_buildEventInfo(event),

const SizedBox(height: 28),

_buildDescription(event),

const SizedBox(height: 28),

_buildRegistrationDeadline(event),
                ],
              ),
            ),
          ),
        ],
      ),

bottomNavigationBar: _buildRegistrationButton(),
    );
  }

  Widget _buildAppBar(EventModel event) {
    return SliverAppBar(
      expandedHeight: 250,

pinned: true,

backgroundColor: AppTheme.primaryOrange,

foregroundColor: Colors.white,

leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },

icon: const Icon(Icons.arrow_back_rounded),
      ),

actions: [
        IconButton(
          onPressed: isBookmarkLoading ? null : _toggleBookmark,

icon: isBookmarkLoading
? const SizedBox(
                  height: 20,
width: 20,
child: CircularProgressIndicator(
                    strokeWidth: 2,
color: Colors.white,
                  ),
                )
: Icon(
                  isSaved
? Icons.bookmark_rounded
: Icons.bookmark_border_rounded,
                ),
        ),

const SizedBox(width: 8),
      ],

flexibleSpace: FlexibleSpaceBar(background: _buildEventImage(event)),
    );
  }

  Widget _buildEventImage(EventModel event) {
if (event.imageUrl.isEmpty) {
      return Container(
        color: AppTheme.lightOrange,

child: const Center(
          child: Icon(
            Icons.event_rounded,
size: 80,
color: AppTheme.primaryOrange,
          ),
        ),
      );
    }

    return Image.network(
      event.imageUrl,

fit: BoxFit.cover,

errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppTheme.lightOrange,

child: const Center(
            child: Icon(
              Icons.event_rounded,
size: 80,
color: AppTheme.primaryOrange,
            ),
          ),
        );
      },

loadingBuilder: (context, child, loadingProgress) {
if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: AppTheme.lightOrange,

child: const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryOrange),
          ),
        );
      },
    );
  }

  Widget _buildCategory(EventModel event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

decoration: BoxDecoration(
        color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(10),
      ),

child: Text(
        event.category,
style: const TextStyle(
          color: AppTheme.primaryOrange,
fontWeight: FontWeight.w700,
fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTitle(EventModel event) {
    return Text(
      event.title,
style: const TextStyle(
        fontSize: 28,
height: 1.2,
fontWeight: FontWeight.w800,
color: Colors.black,
      ),
    );
  }

  Widget _buildOrganizer(EventModel event) {
    return Row(
      children: [
        Container(
          height: 44,
width: 44,

decoration: const BoxDecoration(
            color: AppTheme.lightOrange,
shape: BoxShape.circle,
          ),

child: const Icon(
            Icons.business_rounded,
color: AppTheme.primaryOrange,
          ),
        ),

const SizedBox(width: 12),

Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
children: [
              Text(
                'Organized by',
style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

const SizedBox(height: 3),

Text(
                event.organizerName,
style: const TextStyle(
                  fontSize: 15,
fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(18),

decoration: BoxDecoration(
        color: Colors.white,

borderRadius: BorderRadius.circular(18),

border: Border.all(color: Colors.grey.shade200),
      ),

child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.calendar_month_rounded,
title: 'Date',
value: _formatDate(event.date),
                ),
              ),

Expanded(
                child: _buildInfoItem(
                  icon: Icons.access_time_rounded,
title: 'Time',
value: event.time,
                ),
              ),
            ],
          ),

const SizedBox(height: 20),

Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: event.isOnline
? Icons.language_rounded
: Icons.location_on_rounded,
title: 'Location',
value: event.location,
                ),
              ),

Expanded(
                child: _buildInfoItem(
                  icon: Icons.signal_cellular_alt_rounded,
title: 'Level',
value: event.level,
                ),
              ),
            ],
          ),

const SizedBox(height: 20),

Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.code_rounded,
title: 'Domain',
value: event.domain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
 required String title,
 required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        Container(
          height: 38,
width: 38,

decoration: BoxDecoration(
            color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(10),
          ),

child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
        ),

const SizedBox(width: 10),

Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
children: [
              Text(
                title,
style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),

const SizedBox(height: 3),

Text(
                value,
maxLines: 2,
overflow: TextOverflow.ellipsis,

style: const TextStyle(
                  fontSize: 13,
fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

children: [
        const Text(
          'About this event',
style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),

const SizedBox(height: 12),

Text(
          event.description,
style: TextStyle(
            fontSize: 15,
height: 1.6,
color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationDeadline(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(16),

decoration: BoxDecoration(
        color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(16),
      ),

child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppTheme.primaryOrange),

const SizedBox(width: 12),

Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
children: [
                const Text(
                  'Registration Deadline',
style: TextStyle(fontWeight: FontWeight.w700),
                ),

const SizedBox(height: 4),

Text(
                  _formatDate(event.registrationDeadline),
style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),

decoration: BoxDecoration(
          color: Colors.white,

boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
blurRadius: 12,
offset: const Offset(0, -4),
            ),
          ],
        ),

child: SizedBox(
          height: 54,

child: ElevatedButton(
            onPressed: isRegistering || isRegistered ? null : _registerForEvent,

child: isRegistering
? const SizedBox(
                    height: 24,
width: 24,
child: CircularProgressIndicator(
                      strokeWidth: 2,
color: Colors.white,
                    ),
                  )
: Text(
                    isRegistered ? 'Registered ✓' : 'Register Now',
style: const TextStyle(
                      fontSize: 16,
fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerForEvent() async {
    final user = FirebaseAuth.instance.currentUser;

if (user == null) {
      _showMessage('Please login to register for an event.');
      return;
    }

    setState(() {
      isRegistering = true;
    });

    try {
      final alreadyRegistered = await RegistrationService.instance
.isUserRegistered(userId: user.uid, eventId: widget.event.id);

if (alreadyRegistered) {
if (!mounted) {
          return;
        }

        setState(() {
          isRegistered = true;
          isRegistering = false;
        });

        _showMessage('You are already registered.');

        return;
      }

      final registration = RegistrationModel(
        id: '',
userId: user.uid,
eventId: widget.event.id,
eventTitle: widget.event.title,
userEmail: user.email ?? '',
userName: user.displayName ?? '',
registeredAt: DateTime.now(),
status: 'registered',
      );

      await RegistrationService.instance.registerForEvent(registration);

      await NotificationService.instance.notifyRegistrationSuccess(
        userId: user.uid,
event: widget.event,
      );

if (!mounted) {
        return;
      }

      setState(() {
        isRegistered = true;
        isRegistering = false;
      });

      _showMessage('Successfully registered for the event! 🎉');
    } catch (e) {
if (!mounted) {
        return;
      }

      setState(() {
        isRegistering = false;
      });

      _showMessage('Registration failed. Please try again.');

      debugPrint('Registration error: $e');
    }
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}
