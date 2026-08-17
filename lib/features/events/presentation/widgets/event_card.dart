import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../events/domain/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        context.push(
          AppRoutes.eventDetails,
          extra: event,
        );
      },

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(18),

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
                    event.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    event.organizerName,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color:
                            Colors.grey.shade600,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        event.time,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Icon(
                        event.isOnline
                            ? Icons
                                .language_rounded
                            : Icons
                                .location_on_outlined,
                        size: 14,
                        color:
                            AppTheme.primaryOrange,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 12,
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

            IconButton(
              onPressed: () {},

              icon: const Icon(
                Icons.bookmark_border_rounded,
                color:
                    AppTheme.primaryOrange,
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
        borderRadius:
            BorderRadius.circular(14),
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
            '${event.date.day}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color:
                  AppTheme.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}