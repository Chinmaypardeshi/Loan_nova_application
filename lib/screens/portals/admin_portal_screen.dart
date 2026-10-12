import 'package:flutter/material.dart';

class AdminPortalScreen extends StatefulWidget {
  const AdminPortalScreen({super.key});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen> {
  // Toggle states for platform settings / AI configurations
  bool _aiRecommendationEngine = true;
  bool _maintenanceMode = false;
  bool _strictFraudDetection = true;

  // Mock global metrics
  final Map<String, String> _systemMetrics = {
    'Active Users': '15.4M',
    'Concurrent Sessions': '842,100',
    'API Latency': '142 ms',
    'System Uptime': '99.99%',
  };

  // Mock user list for role/access governance
  final List<Map<String, dynamic>> _platformUsers = [
    {'name': 'Chinmay Pardeshi', 'email': 'chinmay@loannova.com', 'role': 'Super Administrator', 'status': 'Active'},
    {'name': 'Aura Bank Admin', 'email': 'partners@aurabank.com', 'role': 'Financial Partner', 'status': 'Active'},
    {'name': 'Rahul Sharma', 'email': 'rahul.sales@loannova.com', 'role': 'Sales Agent', 'status': 'Active'},
    {'name': 'Priya Patel', 'email': 'priya.rm@loannova.com', 'role': 'Relationship Manager', 'status': 'Active'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Super Administrator Console'),
          backgroundColor: Colors.indigo.shade900,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'System Health'),
              Tab(icon: Icon(Icons.people_alt), text: 'User Governance'),
              Tab(icon: Icon(Icons.settings_suggest), text: 'Platform Config'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: System Health & Analytics Overview
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hyperscale Infrastructure Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: _systemMetrics.entries.map((entry) {
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 6),
                              Text(entry.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Active Security & Compliance Audits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          ListTile(
                            leading: Icon(Icons.security, color: Colors.green),
                            title: Text('RBI & DPDP Act Data Governance'),
                            subtitle: Text('AES-256 Encryption active across all vault documents.'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.verified_user, color: Colors.blue),
                            title: Text('Automated Fraud Detection AI'),
                            subtitle: Text('Zero anomaly spikes detected in last 24 hours.'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab 2: User Governance & Role Management
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mobile-Friendly Row with Expanded Title and Flexible Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Platform Users & RBAC Control',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        icon: const Icon(Icons.person_add, size: 16),
                        label: const Text('Add User', style: TextStyle(fontSize: 13)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening user creation modal...')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _platformUsers.length,
                      itemBuilder: (context, index) {
                        final user = _platformUsers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(user['name'][0], style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                            ),
                            title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${user['email']} • ${user['role']}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Text(user['status'], style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Tab 3: Platform & AI Configuration
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('AI & Feature Flag Toggles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('AI Recommendation Engine'),
                  subtitle: const Text('Enable personalized machine-learning product matches for customers'),
                  value: _aiRecommendationEngine,
                  onChanged: (val) {
                    setState(() => _aiRecommendationEngine = val);
                  },
                ),
                SwitchListTile(
                  title: const Text('Strict Fraud Detection Anomaly Check'),
                  subtitle: const Text('Block high-risk device fingerprints automatically'),
                  value: _strictFraudDetection,
                  onChanged: (val) {
                    setState(() => _strictFraudDetection = val);
                  },
                ),
                SwitchListTile(
                  title: const Text('Platform Maintenance Mode'),
                  subtitle: const Text('Restrict non-admin mobile traffic during database updates'),
                  value: _maintenanceMode,
                  onChanged: (val) {
                    setState(() => _maintenanceMode = val);
                  },
                ),
                const Divider(height: 32),
                const Text('Global Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Purge Distributed Redis Cache'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully cleared Redis search and session cache!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}