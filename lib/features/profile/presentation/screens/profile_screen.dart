import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techscope/core/routes/app_routes.dart';
import 'package:techscope/features/home/presentation/widgets/bottom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      bottomNavigationBar: TechScopeBottomNavBar(currentIndex: 3),
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
              // Edit profile - Step 15.2
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
          icon: Icons.event_available_rounded,
          title: 'Registered Events',
          subtitle: 'View events you registered for',
          onTap: () {
            // Registered events screen
          },
        ),

        _buildMenuTile(
          icon: Icons.bookmark_rounded,
          title: 'Saved Events',
          subtitle: 'View your bookmarked events',
          onTap: () {
            // Saved events screen
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
            // Personal information screen
          },
        ),

        _buildMenuTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage event notifications',
          onTap: () {
            // Notification settings
          },
        ),

        _buildMenuTile(
          icon: Icons.lock_outline_rounded,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: () {
            // Change password screen
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
            // Privacy policy
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
      children: const [
        SizedBox(height: 16),
        Text(
          'TechScope helps students discover and register for technical events such as hackathons, coding contests, workshops, webinars, conferences and meetups.',
        ),
      ],
    );
  }
}
