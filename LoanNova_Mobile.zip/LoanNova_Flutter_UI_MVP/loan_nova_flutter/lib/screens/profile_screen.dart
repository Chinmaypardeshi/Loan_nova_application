import 'package:flutter/material.dart';

import '../api/api_service.dart';
import 'notifications_screen.dart';
import 'personal_information_screen.dart';
import 'change_password_screen.dart';
import 'help_support_screen.dart';
import 'settings_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'User';
  String userEmail = '';
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Logged-in user ki ID SharedPreferences se milegi
      final userId = await ApiService.getUserId();

      if (userId == null) {
        throw Exception(
          'User session not found. Please login again',
        );
      }

      // Backend se user details
      final data = await ApiService.getUserById(userId);

      if (!mounted) return;

      setState(() {
        userName = (data['name'] ?? 'User').toString();
        userEmail = (data['email'] ?? '').toString();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Log out?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of LoanNova?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    try {
      await ApiService.logout();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
        ),
      );

      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),

            // Profile avatar
            const CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFFEAF0FF),
              child: Icon(
                Icons.person,
                size: 44,
                color: Color(0xFF3157E8),
              ),
            ),

            const SizedBox(height: 12),

            // User Name
            Center(
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),

            const SizedBox(height: 6),

            // User Email
            if (!isLoading && userEmail.isNotEmpty)
              Center(
                child: Text(
                  userEmail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

            // Error
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Unable to load profile',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: _loadProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            // Personal Information
            _item(
  context,
  Icons.person_outline,
  'Personal Information',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PersonalInformationScreen(),
      ),
    );
  },
),

            // Notifications
            _item(
              context,
              Icons.notifications_none,
              'Notifications',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const NotificationsScreen(),
                  ),
                );
              },
            ),

            // Security
           _item(
  context,
  Icons.security_outlined,
  'Security & Privacy',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ChangePasswordScreen(),
      ),
    );
  },
),

            // Help
           _item(
  context,
  Icons.help_outline,
  'Help & Support',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const HelpSupportScreen(),
      ),
    );
  },
),

            // Settings
            _item(
  context,
  Icons.settings_outlined,
  'Settings',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SettingsScreen(),
      ),
    );
  },
),

            // Logout
            _item(
              context,
              Icons.logout,
              'Log out',
              onTap: () => _logout(context),
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return Card(
      elevation: 0,
      child: ListTile(
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$title selected',
                  ),
                ),
              );
            },
        leading: Icon(
          icon,
          color: isLogout
              ? Colors.red
              : const Color(0xFF3157E8),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : null,
            fontWeight:
                isLogout ? FontWeight.w600 : null,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}