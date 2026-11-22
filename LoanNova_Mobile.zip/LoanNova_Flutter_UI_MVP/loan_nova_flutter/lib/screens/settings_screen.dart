import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool repaymentReminders = true;
  bool applicationUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 0,
            child: Column(
              children: [
                SwitchListTile(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Receive LoanNova notifications',
                  ),
                  secondary: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF3157E8),
                  ),
                ),

                const Divider(height: 1),

                SwitchListTile(
                  value: repaymentReminders,
                  onChanged: notificationsEnabled
                      ? (value) {
                          setState(() {
                            repaymentReminders = value;
                          });
                        }
                      : null,
                  title: const Text(
                    'Repayment Reminders',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Get reminders about upcoming EMIs',
                  ),
                  secondary: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF3157E8),
                  ),
                ),

                const Divider(height: 1),

                SwitchListTile(
                  value: applicationUpdates,
                  onChanged: notificationsEnabled
                      ? (value) {
                          setState(() {
                            applicationUpdates = value;
                          });
                        }
                      : null,
                  title: const Text(
                    'Application Updates',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Get updates about your loan applications',
                  ),
                  secondary: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFF3157E8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.language_outlined,
                    color: Color(0xFF3157E8),
                  ),
                  title: const Text(
                    'Language',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text('English'),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Language settings will be available soon',
                        ),
                      ),
                    );
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(
                    Icons.palette_outlined,
                    color: Color(0xFF3157E8),
                  ),
                  title: const Text(
                    'Appearance',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Default',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Appearance settings will be available soon',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Privacy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Color(0xFF3157E8),
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Privacy Policy will be available soon',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}