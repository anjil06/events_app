import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../events/domain/models/event_model.dart';

class FeaturedEventCard extends StatelessWidget {
  final EventModel event;

  const FeaturedEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.eventDetails, extra: event);
      },
      child: Container(
        width: 310,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryOrange, AppTheme.darkOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryOrange.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),

                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const Icon(Icons.bookmark_border_rounded, color: Colors.white),
              ],
            ),

            const Spacer(),

            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              event.organizerName,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.white,
                ),

                const SizedBox(width: 6),

                Text(
                  event.time,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),

                const SizedBox(width: 14),

                const Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: Colors.white,
                ),

                const SizedBox(width: 4),

                Expanded(
                  child: Text(
                    event.location,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
