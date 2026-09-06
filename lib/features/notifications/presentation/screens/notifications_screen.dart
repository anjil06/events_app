import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/data/services/event_services.dart';
import '../../data/services/notification_service.dart';
import '../../domain/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Unread', 'Reminders', 'Registrations'];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
children: [
              const Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
const SizedBox(height: 16),
const Text('Please sign in to view your notifications.'),
const SizedBox(height: 16),
ElevatedButton(
                onPressed: () => context.go(AppRoutes.login),
child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
onSelected: (value) async {
              final messenger = ScaffoldMessenger.of(context);
if (value == 'mark_all_read') {
                await NotificationService.instance.markAllAsRead(user.uid);
if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('All notifications marked as read.')),
                  );
                }
              } else if (value == 'clear_all') {
                final confirm = await _showClearAllConfirmation(context);
if (confirm == true) {
                  await NotificationService.instance.clearAll(user.uid);
if (mounted) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('All notifications cleared.')),
                    );
                  }
                }
              }
            },
itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 18, color: AppTheme.primaryOrange),
SizedBox(width: 10),
Text('Mark all as read'),
                  ],
                ),
              ),
const PopupMenuItem(
                value: 'clear_all',
child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.red),
SizedBox(width: 10),
Text('Clear all'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
body: Column(
        children: [
          _buildFilterBar(),
Expanded(
            child: StreamBuilder<List<NotificationModel>>(
              stream: NotificationService.instance.getNotificationsStream(user.uid),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryOrange),
                  );
                }

if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading notifications: ${snapshot.error}'),
                  );
                }

                final allNotifications = snapshot.data ?? [];
                final filtered = _filterNotifications(allNotifications);

if (filtered.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  color: AppTheme.primaryOrange,
onRefresh: () async {
                    await NotificationService.instance.checkAndNotifyUpcomingEvents(userId: user.uid);
                  },
child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
itemCount: filtered.length,
separatorBuilder: (_, index) => const SizedBox(height: 10),
itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _buildNotificationCard(user.uid, item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 48,
margin: const EdgeInsets.only(top: 8, bottom: 8),
child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
scrollDirection: Axis.horizontal,
itemCount: _filters.length,
separatorBuilder: (_, index) => const SizedBox(width: 8),
itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return ChoiceChip(
            label: Text(_filters[index]),
selected: isSelected,
selectedColor: AppTheme.primaryOrange,
backgroundColor: Colors.white,
labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
fontSize: 13,
            ),
shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
side: BorderSide(
                color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade300,
              ),
            ),
onSelected: (selected) {
if (selected) {
                setState(() => _selectedFilterIndex = index);
              }
            },
          );
        },
      ),
    );
  }

  List<NotificationModel> _filterNotifications(List<NotificationModel> list) {
    switch (_selectedFilterIndex) {
      case 1: // Unread
        return list.where((n) => !n.isRead).toList();
      case 2: // Reminders
        return list.where((n) => n.type == NotificationType.eventStartingSoon).toList();
      case 3: // Registrations
        return list.where((n) => n.type == NotificationType.registrationSuccess).toList();
      default:
        return list;
    }
  }

  Widget _buildNotificationCard(String userId, NotificationModel item) {
    final colors = _getTypeColors(item.type);
    final icon = _getTypeIcon(item.type);

    return Dismissible(
      key: Key(item.id),
direction: DismissDirection.endToStart,
background: Container(
        alignment: Alignment.centerRight,
padding: const EdgeInsets.only(right: 20),
decoration: BoxDecoration(
          color: Colors.red.shade400,
borderRadius: BorderRadius.circular(16),
        ),
child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
onDismissed: (_) {
        NotificationService.instance.deleteNotification(userId, item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification removed'),
duration: Duration(seconds: 2),
          ),
        );
      },
child: InkWell(
        borderRadius: BorderRadius.circular(16),
onTap: () async {
if (!item.isRead) {
            await NotificationService.instance.markAsRead(userId, item.id);
          }

          // If linked to an event, navigate to details
if (item.eventId != null && item.eventId!.isNotEmpty) {
            try {
              final event = await EventService.instance.getEventById(item.eventId!);
if (event != null && mounted) {
                context.push(AppRoutes.eventDetails, extra: event);
              }
            } catch (_) {
              // Ignore navigation error if event was deleted
            }
          }
        },
child: Container(
          padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
            color: item.isRead ? Colors.white : AppTheme.lightOrange.withValues(alpha: 0.35),
borderRadius: BorderRadius.circular(16),
border: Border.all(
              color: item.isRead ? Colors.grey.shade200 : AppTheme.primaryOrange.withValues(alpha: 0.4),
width: item.isRead ? 1 : 1.5,
            ),
boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
blurRadius: 8,
offset: const Offset(0, 3),
              ),
            ],
          ),
child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
children: [
              Container(
                height: 42,
width: 42,
decoration: BoxDecoration(
                  color: colors.backgroundColor,
shape: BoxShape.circle,
                ),
child: Icon(icon, color: colors.iconColor, size: 22),
              ),
const SizedBox(width: 14),
Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
                        Expanded(
                          child: Text(
                            item.title,
style: TextStyle(
                              fontSize: 15,
fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
color: Colors.black87,
                            ),
                          ),
                        ),
if (!item.isRead)
                          Container(
                            height: 8,
width: 8,
margin: const EdgeInsets.only(left: 8),
decoration: const BoxDecoration(
                              color: AppTheme.primaryOrange,
shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
const SizedBox(height: 5),
Text(
                      item.message,
style: TextStyle(
                        fontSize: 13,
color: Colors.grey.shade700,
height: 1.35,
                      ),
                    ),
const SizedBox(height: 8),
Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
                        Text(
                          _timeAgo(item.createdAt),
style: TextStyle(
                            fontSize: 11,
color: Colors.grey.shade500,
fontWeight: FontWeight.w500,
                          ),
                        ),
if (item.eventId != null && item.eventId!.isNotEmpty)
                          Row(
                            children: const[
                              Text(
                                'View Event',
style: TextStyle(
                                  fontSize: 11,
fontWeight: FontWeight.w700,
color: AppTheme.primaryOrange,
                                ),
                              ),
SizedBox(width: 2),
Icon(
                                Icons.arrow_forward_ios_rounded,
size: 10,
color: AppTheme.primaryOrange,
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
children: [
          Container(
            padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
              color: AppTheme.lightOrange,
shape: BoxShape.circle,
            ),
child: const Icon(
              Icons.notifications_none_rounded,
size: 56,
color: AppTheme.primaryOrange,
            ),
          ),
const SizedBox(height: 18),
const Text(
            'All caught up!',
style: TextStyle(
              fontSize: 18,
fontWeight: FontWeight.w700,
            ),
          ),
const SizedBox(height: 6),
Text(
            'You have no notifications in this category.',
style: TextStyle(
              fontSize: 13,
color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.registrationSuccess:
        return Icons.confirmation_number_rounded;
      case NotificationType.eventStartingSoon:
        return Icons.alarm_rounded;
      case NotificationType.eventPublished:
        return Icons.rocket_launch_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  _NotificationColors _getTypeColors(NotificationType type) {
    switch (type) {
      case NotificationType.registrationSuccess:
        return _NotificationColors(
          backgroundColor: const Color(0xFFE8F5E9),
iconColor: const Color(0xFF2E7D32),
        );
      case NotificationType.eventStartingSoon:
        return _NotificationColors(
          backgroundColor: AppTheme.lightOrange,
iconColor: AppTheme.primaryOrange,
        );
      case NotificationType.eventPublished:
        return _NotificationColors(
          backgroundColor: const Color(0xFFE3F2FD),
iconColor: const Color(0xFF1976D2),
        );
      case NotificationType.general:
        return _NotificationColors(
          backgroundColor: Colors.grey.shade100,
iconColor: Colors.grey.shade700,
        );
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
if (diff.inMinutes < 1) return 'Just now';
if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
if (diff.inHours < 24) return '${diff.inHours}h ago';
if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  Future<bool?> _showClearAllConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
builder: (ctx) => AlertDialog(
        title: const Text('Clear all notifications?'),
content: const Text('This action will delete all notifications from your history.'),
actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
child: const Text('Cancel'),
          ),
ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
onPressed: () => Navigator.pop(ctx, true),
child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _NotificationColors {
  final Color backgroundColor;
  final Color iconColor;

const _NotificationColors({
    required this.backgroundColor,
 required this.iconColor,
  });
}
