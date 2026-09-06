import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techscope/core/routes/app_routes.dart';

import '../../../../core/services/cloudinary_upload_service.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploadingAvatar = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
children: [
              const Text('Please sign in to view your profile.'),
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

    final fallbackName = user.displayName?.trim().isNotEmpty == true
? user.displayName!
: 'TechCulture Member';

    final email = user.email ?? 'No email available';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
builder: (context, snapshot) {
          final userData = snapshot.data?.data();
          final displayName = (userData?['name'] as String?)?.trim().isNotEmpty == true
? (userData!['name'] as String).trim()
: fallbackName;
          final profileImageUrl = (userData?['profileImageUrl'] ?? userData?['profileImage'] ?? user.photoURL ?? '') as String;
          final profileImagePublicId = userData?['profileImagePublicId'] as String?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
child: Column(
              children: [
                _buildProfileHeader(
                  user: user,
name: displayName,
email: email,
profileImageUrl: profileImageUrl,
profileImagePublicId: profileImagePublicId,
                ),

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
          );
        },
      ),
bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.explore);
              break;
            case 2:
              context.go(AppRoutes.savedEvents);
              break;
            case 3:
              break;
          }
        },
destinations: const[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
selectedIcon: Icon(Icons.home_rounded),
label: 'Home',
          ),
NavigationDestination(
            icon: Icon(Icons.explore_outlined),
selectedIcon: Icon(Icons.explore_rounded),
label: 'Explore',
          ),
NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
selectedIcon: Icon(Icons.bookmark_rounded),
label: 'Saved',
          ),
NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
selectedIcon: Icon(Icons.person_rounded),
label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader({
    required User user,
 required String name,
 required String email,
 required String profileImageUrl,
 required String? profileImagePublicId,
  }) {
    return Container(
      width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
        color: Colors.orange.shade50,
borderRadius: BorderRadius.circular(24),
      ),
child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.2),
blurRadius: 16,
offset: const Offset(0, 6),
                    ),
                  ],
                ),
child: CircleAvatar(
                  radius: 46,
backgroundColor: AppTheme.primaryOrange,
backgroundImage: profileImageUrl.isNotEmpty
? NetworkImage(profileImageUrl)
: null,
child: profileImageUrl.isEmpty
? Text(
                          _getInitials(name),
style: const TextStyle(
                            color: Colors.white,
fontSize: 26,
fontWeight: FontWeight.bold,
                          ),
                        )
: null,
                ),
              ),

if (_isUploadingAvatar)
                Container(
                  width: 92,
height: 92,
decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
shape: BoxShape.circle,
                  ),
child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
strokeWidth: 3,
                    ),
                  ),
                ),

if (!_isUploadingAvatar)
                Positioned(
                  bottom: 0,
right: 0,
child: Material(
                    color: AppTheme.primaryOrange,
shape: const CircleBorder(),
elevation: 3,
child: InkWell(
                      customBorder: const CircleBorder(),
onTap: () => _showProfileImageSourceDialog(
                        user: user,
currentPublicId: profileImagePublicId,
hasExistingImage: profileImageUrl.isNotEmpty,
                      ),
child: const Padding(
                        padding: EdgeInsets.all(8),
child: Icon(
                          Icons.camera_alt_rounded,
size: 16,
color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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

  void _showProfileImageSourceDialog({
    required User user,
 required String? currentPublicId,
 required bool hasExistingImage,
  }) {
    showModalBottomSheet(
      context: context,
shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
child: Column(
            mainAxisSize: MainAxisSize.min,
children: [
              Container(
                height: 4,
width: 40,
decoration: BoxDecoration(
                  color: Colors.grey.shade300,
borderRadius: BorderRadius.circular(2),
                ),
              ),
const SizedBox(height: 16),
const Text(
                'Profile Photo',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
const SizedBox(height: 16),
ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
                    color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(12),
                  ),
child: const Icon(Icons.photo_camera_rounded, color: AppTheme.primaryOrange),
                ),
title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
subtitle: const Text('Capture using device camera'),
onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadProfileImage(
                    source: ImageSource.camera,
user: user,
currentPublicId: currentPublicId,
                  );
                },
              ),
ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
                    color: AppTheme.lightOrange,
borderRadius: BorderRadius.circular(12),
                  ),
child: const Icon(Icons.photo_library_rounded, color: AppTheme.primaryOrange),
                ),
title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
subtitle: const Text('Select from photo album'),
onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadProfileImage(
                    source: ImageSource.gallery,
user: user,
currentPublicId: currentPublicId,
                  );
                },
              ),
if (hasExistingImage)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
                      color: Colors.red.shade50,
borderRadius: BorderRadius.circular(12),
                    ),
child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  ),
title: const Text('Remove Photo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
onTap: () {
                    Navigator.pop(ctx);
                    _removeProfileImage(user: user, currentPublicId: currentPublicId);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadProfileImage({
    required ImageSource source,
 required User user,
 required String? currentPublicId,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
maxWidth: 800,
maxHeight: 800,
imageQuality: 85,
      );

if (pickedFile == null) return;

      setState(() => _isUploadingAvatar = true);

      final result = await CloudinaryUploadService.instance.uploadProfileImage(
        pickedFile,
oldPublicId: currentPublicId,
      );

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileImageUrl': result.secureUrl,
        'profileImagePublicId': result.publicId,
        'profileImage': result.secureUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updatePhotoURL(result.secureUrl);

if (!mounted) return;
      setState(() => _isUploadingAvatar = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully via Cloudinary.')),
      );
    } catch (e) {
if (!mounted) return;
      setState(() => _isUploadingAvatar = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile photo: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  Future<void> _removeProfileImage({
    required User user,
 required String? currentPublicId,
  }) async {
    try {
if (currentPublicId != null && currentPublicId.isNotEmpty) {
        CloudinaryUploadService.instance.deleteImage(currentPublicId);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileImageUrl': null,
        'profileImagePublicId': null,
        'profileImage': null,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updatePhotoURL(null);

if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo removed.')),
      );
    } catch (e) {
if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove photo: $e')),
      );
    }
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
title: 'Saved Content',
subtitle: 'View your saved articles & events',
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
subtitle: 'View your event and account notifications',
onTap: () {
            context.push(AppRoutes.notifications);
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
title: 'About TechCulture',
subtitle: 'Learn more about TechCulture',
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

content: const Text('Are you sure you want to log out of TechCulture?'),

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
applicationName: 'TechCulture',
applicationVersion: '1.0.0',
applicationLegalese: 'Discover. Learn. Connect. Build.',
applicationIcon: Container(
        height: 48,
width: 48,
padding: const EdgeInsets.all(6),
decoration: BoxDecoration(
          color: Colors.orange.shade50,
borderRadius: BorderRadius.circular(12),
        ),
child: Image.asset(
          'assets/images/techculture_icon_mark.png',
fit: BoxFit.contain,
        ),
      ),
children: const[
        SizedBox(height: 16),
Text(
          'TechCulture is a modern technology culture and developer community platform connecting builders to tech trends, developer communities, programming resources, and premier tech events.',
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
content: const Text('TechCulture uses your account information to provide event registrations and saved content. Your activity is visible only to your account.'),
actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close'))],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
