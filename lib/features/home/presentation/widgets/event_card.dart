import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String date;
  final String time;
  final String location;
  final bool isOnline;

  const EventCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.date,
    required this.time,
    required this.location,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          _buildDateContainer(),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  organizer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      isOnline
                          ? Icons.language_rounded
                          : Icons.location_on_outlined,
                      size: 14,
                      color: AppTheme.primaryOrange,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: AppTheme.primaryOrange,
            ),
          ),
        ],
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
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: AppTheme.primaryOrange,
            size: 20,
          ),

          const SizedBox(height: 4),

          Text(
            date.split(' ').first,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}