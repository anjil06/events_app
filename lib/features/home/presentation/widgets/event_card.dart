import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/domain/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isSaved;
  final bool isBookmarkLoading;
  final VoidCallback onBookmarkPressed;

const EventCard({
    super.key,
 required this.event,
 required this.isSaved,
 required this.isBookmarkLoading,
 required this.onBookmarkPressed
});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

onTap: () {
        context.push(AppRoutes.eventDetails, extra: event);
      },

child: Container(
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

child: Row(
          children: [
            _buildDateContainer(),

const SizedBox(width: 12),

Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
mainAxisSize: MainAxisSize.min,
children: [
                  Text(
                    event.title,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
                      fontSize: 15,
fontWeight: FontWeight.w700,
                    ),
                  ),

const SizedBox(height: 4),

Text(
                    event.organizerName,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),

const SizedBox(height: 8),

Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
size: 13,
color: Colors.grey.shade600,
                      ),

const SizedBox(width: 4),

Expanded(
                        flex: 5,
child: Text(
                          event.time,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
                            fontSize: 11,
color: Colors.grey.shade600,
                          ),
                        ),
                      ),

const SizedBox(width: 8),

Icon(
                        event.isOnline
? Icons.language_rounded
: Icons.location_on_outlined,
size: 13,
color: AppTheme.primaryOrange,
                      ),

const SizedBox(width: 4),

Expanded(
                        flex: 6,
child: Text(
                          event.location,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
                            fontSize: 11,
color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

const SizedBox(width: 4),

IconButton(
              padding: EdgeInsets.zero,
constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
onPressed: isBookmarkLoading ? null : onBookmarkPressed,
icon: isBookmarkLoading
? const SizedBox(
                      height: 18,
width: 18,
child: CircularProgressIndicator(
                        strokeWidth: 2,
color: AppTheme.primaryOrange,
                      ),
                    )
: Icon(
                      isSaved
? Icons.bookmark_rounded
: Icons.bookmark_border_rounded,
color: isSaved ? AppTheme.primaryOrange : Colors.grey.shade600,
size: 22,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateContainer() {
    return Container(
      height: 68,
width: 58,

decoration: BoxDecoration(
        color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(14),
      ),

child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

children: [
          const Icon(
            Icons.calendar_month_rounded,
color: AppTheme.primaryOrange,
size: 20,
          ),

const SizedBox(height: 4),

Text(
            '${event.date.day}',
style: const TextStyle(
              fontSize: 16,
fontWeight: FontWeight.w800,
color: AppTheme.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}
