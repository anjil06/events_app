import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techscope/core/routes/app_routes.dart';
import 'package:techscope/features/home/presentation/widgets/bottom_navigation_bar.dart';

class ProfileScreen extends StatefulWidget {
const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.trim().isNotEmpty == true
? user!.displayName!
: 'TechScope User';

    final email = user?.email ?? 'No email available';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
child: Column(
          children: [
            _buildProfileHeader(displayName, email),

const SizedBox(height: 24),

_buildActivitySection(context),

const SizedBox(height: 24),

_buildAccountSection(context),

const SizedBox(height: 24),

_buildAppSection(context),

const SizedBox(height: 24),

_buildLogoutButton(context),

const SizedBox(height: 20),
          ],
        ),
      ),
bottomNavigationBar: MainNavigationScreen(),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Container(
      width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
        color: Colors.orange.shade50,
borderRadius: BorderRadius.circular(24),
      ),
child: Column(
        children: [
          CircleAvatar(
            radius: 42,
backgroundColor: Colors.orange,
child: Text(
              _getInitials(name),
style: const TextStyle(
                color: Colors.white,
fontSize: 26,
fontWeight: FontWeight.bold,
              ),
            ),
          ),

const SizedBox(height: 14),

Text(
            name,
textAlign: TextAlign.center,
style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

const SizedBox(height: 6),

Text(
            email,
textAlign: TextAlign.center,
style: TextStyle(color: Colors.grey.shade700),
          ),

const SizedBox(height: 16),

OutlinedButton.icon(
            onPressed: () {
              _showEditProfileDialog(context, name);
            },
icon: const Icon(Icons.edit_outlined),
label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');

if (parts.isEmpty) {
      return 'U';
    }

if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Widget _buildActivitySection(BuildContext context) {
    return _buildSection(
      title: 'My Activity',
      children: [
        _buildMenuTile(
          icon: Icons.campaign_outlined,
          title: 'Manage My Events',
          subtitle: 'Create events and view registrations',
          onTap: () => context.push(AppRoutes.manageEvents),
        ),

        _buildMenuTile(
          icon: Icons.event_available_rounded,
title: 'Registered Events',
subtitle: 'View events you registered for',
onTap: () {
            context.push(AppRoutes.registeredEvents);
          },
        ),

_buildMenuTile(
          icon: Icons.bookmark_rounded,
title: 'Saved Events',
subtitle: 'View your bookmarked events',
onTap: () {
            context.push(AppRoutes.savedEvents);
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSection(
      title: 'Account',
children: [
        _buildMenuTile(
          icon: Icons.person_outline_rounded,
title: 'Personal Information',
subtitle: 'Manage your account details',
onTap: () {
            _showEditProfileDialog(context, FirebaseAuth.instance.currentUser?.displayName ?? '');
          },
        ),

_buildMenuTile(
          icon: Icons.notifications_outlined,
title: 'Notifications',
subtitle: 'Manage event notifications',
onTap: () {
            _showMessage(context, 'Event notifications will be available in a future update.');
          },
        ),

_buildMenuTile(
          icon: Icons.lock_outline_rounded,
title: 'Change Password',
subtitle: 'Update your account password',
onTap: () {
            _sendPasswordReset(context);
          },
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return _buildSection(
      title: 'App',
children: [
        _buildMenuTile(
          icon: Icons.info_outline_rounded,
title: 'About TechScope',
subtitle: 'Learn more about TechScope',
onTap: () {
            _showAboutDialog(context);
          },
        ),

_buildMenuTile(
          icon: Icons.privacy_tip_outlined,
title: 'Privacy Policy',
subtitle: 'Read our privacy policy',
onTap: () {
            _showPrivacyDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
 required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
children: [
        Text(
          title,
style: TextStyle(
            fontSize: 17,
fontWeight: FontWeight.w700,
color: Colors.orange.shade800,
          ),
        ),

const SizedBox(height: 10),

Card(
          elevation: 0,
margin: EdgeInsets.zero,
shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
side: BorderSide(color: Colors.grey.shade200),
          ),
child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
 required String title,
 required String subtitle,
 required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

leading: Container(
        height: 42,
width: 42,
decoration: BoxDecoration(
          color: Colors.orange.shade50,
borderRadius: BorderRadius.circular(12),
        ),
child: Icon(icon, color: Colors.orange.shade700),
      ),

title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),

trailing: const Icon(Icons.chevron_right_rounded),

onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
child: OutlinedButton.icon(
        onPressed: () {
          _showLogoutConfirmation(context);
        },

icon: const Icon(Icons.logout_rounded),

label: const Text('Log Out'),

style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
side: const BorderSide(color: Colors.red),
padding: const EdgeInsets.symmetric(vertical: 14),
shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log Out?'),

content: const Text('Are you sure you want to log out of TechScope?'),

actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
child: const Text('Cancel'),
            ),

FilledButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await FirebaseAuth.instance.signOut();

if (!context.mounted) {
                  return;
                }
                context.go(AppRoutes.login);
              },

style: FilledButton.styleFrom(backgroundColor: Colors.red),

child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
applicationName: 'TechScope',
applicationVersion: '1.0.0',
applicationLegalese: 'Discover. Learn. Connect.',
children: const[
        SizedBox(height: 16),
Text(
          'TechScope helps students discover and register for technical events such as hackathons, coding contests, workshops, webinars, conferences and meetups.',
        ),
      ],
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final updatedName = await showDialog<String>(
      context: context,
builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
content: TextField(
          controller: controller,
autofocus: true,
textCapitalization: TextCapitalization.words,
decoration: const InputDecoration(labelText: 'Display name'),
        ),
actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
if (updatedName == null || updatedName.isEmpty) return;

    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(updatedName);
if (context.mounted) {
        setState(()  {});
        _showMessage(context, 'Profile updated.');
      }
    } on FirebaseAuthException catch (_) {
if (context.mounted) _showMessage(context, 'Unable to update profile. Please try again.');
    }
  }

  Future<void> _sendPasswordReset(BuildContext context) async {
    final email = FirebaseAuth.instance.currentUser?.email;
if (email == null || email.isEmpty) {
      _showMessage(context, 'No email is available for this account.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
if (context.mounted) _showMessage(context, 'A password-reset email was sent to $email.');
    } on FirebaseAuthException catch (_) {
if (context.mounted) _showMessage(context, 'Unable to send password-reset email.');
    }
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
builder: (dialogContext) => AlertDialog(
        title: const Text('Privacy policy'),
content: const Text('TechScope uses your account information to provide event registrations and saved events. Your activity is visible only to your account.'),
actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close'))],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
