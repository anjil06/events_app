import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../notifications/data/services/notification_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,

titleSpacing: 20,

title: Row(
        mainAxisSize: MainAxisSize.min,
children: [
          Container(
            height: 36,
width: 36,
padding: const EdgeInsets.all(4),
decoration: BoxDecoration(
              color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(10),
            ),
child: Image.asset(
              'assets/images/techculture_icon_mark.png',
fit: BoxFit.contain,
            ),
          ),
const SizedBox(width: 10),
RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Tech',
style: TextStyle(
                    color: AppTheme.primaryOrange,
fontSize: 24,
fontWeight: FontWeight.w800,
                  ),
                ),
TextSpan(
                  text: 'Culture',
style: TextStyle(
                    color: Colors.black,
fontSize: 24,
fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

actions: [
        StreamBuilder<int>(
          stream: FirebaseAuth.instance.currentUser != null
? NotificationService.instance.getUnreadCountStream(FirebaseAuth.instance.currentUser!.uid)
: const Stream.empty(),
builder: (context, snapshot) {
            final unreadCount = snapshot.data ?? 0;

            return Stack(
              alignment: Alignment.center,
children: [
                IconButton(
                  onPressed: () {
                    context.push(AppRoutes.notifications);
                  },
icon: const Icon(
                    Icons.notifications_outlined,
color: AppTheme.primaryOrange,
size: 26,
                  ),
                ),
if (unreadCount > 0)
                  Positioned(
                    top: 10,
right: 10,
child: Container(
                      padding: const EdgeInsets.all(4),
decoration: const BoxDecoration(
                        color: Colors.red,
shape: BoxShape.circle,
                      ),
constraints: const BoxConstraints(
                        minWidth: 16,
minHeight: 16,
                      ),
child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
textAlign: TextAlign.center,
style: const TextStyle(
                          color: Colors.white,
fontSize: 10,
fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
IconButton(
          onPressed: () {
            context.push(AppRoutes.profile);
          },
icon: Container(
            height: 40,
width: 40,

decoration: const BoxDecoration(
              color: AppTheme.lightOrange,
shape: BoxShape.circle,
            ),

child: const Icon(
              Icons.person_outline_rounded,
color: AppTheme.primaryOrange,
            ),
          ),
        ),

const SizedBox(width: 12),
      ],
    );
  }
}
