import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login_screen.dart';

class RmDashboardScreen extends StatefulWidget {
  const RmDashboardScreen({super.key});

  @override
  State<RmDashboardScreen> createState() => _RmDashboardScreenState();
}

class _RmDashboardScreenState extends State<RmDashboardScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _clientPortfolio = [];

  @override
  void initState() {
    super.initState();
    _fetchClientData();
  }

  // Fetch live client applications and profiles from Supabase
  Future<void> _fetchClientData() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('applications')
          .select('*, profiles(full_name, phone_number)')
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _clientPortfolio = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error fetching RM client portfolio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load portfolio: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalClients = _clientPortfolio.length;
    final totalAum = _clientPortfolio.fold<double>(
      0.0,
          (sum, item) => sum + ((item['requested_amount'] as num?)?.toDouble() ?? 0.0),
    );
    final pendingCount = _clientPortfolio
        .where((item) => (item['status'] ?? '').toString().toLowerCase().contains('review') ||
        (item['status'] ?? '').toString().toLowerCase().contains('submitted'))
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relationship Manager Portal'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _fetchClientData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await supabase.auth.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchClientData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Overview Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Total Clients', '$totalClients'),
                  _buildStatColumn('Portfolio AUM', '₹${totalAum.toStringAsFixed(0)}'),
                  _buildStatColumn('Pending Tasks', '$pendingCount'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Assigned Client Portfolio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Client List Builder
            _clientPortfolio.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No assigned client portfolios found in Supabase.', style: TextStyle(color: Colors.grey)),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clientPortfolio.length,
              itemBuilder: (context, index) {
                final client = _clientPortfolio[index];

                String clientName = 'Customer';
                if (client['customer_name'] != null) {
                  clientName = client['customer_name'];
                } else if (client['profiles'] != null && client['profiles']['full_name'] != null) {
                  clientName = client['profiles']['full_name'];
                }

                String phone = '+91 98765 43210';
                if (client['profiles'] != null && client['profiles']['phone_number'] != null) {
                  phone = client['profiles']['phone_number'];
                }

                final productName = client['product_name'] ?? 'Financial Loan';
                final amount = client['requested_amount'] != null ? '₹${client['requested_amount']}' : '';
                final productDisplay = '$productName ${amount.isNotEmpty ? "- $amount" : ""}';
                final status = client['status'] ?? 'Submitted';

                // Dynamic priority calculation based on loan amount
                final amountNum = (client['requested_amount'] as num?)?.toDouble() ?? 0.0;
                final priority = amountNum >= 1000000 ? 'High' : (amountNum >= 500000 ? 'Medium' : 'Low');

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              clientName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: priority == 'High' ? Colors.red.shade50 : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$priority Priority',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: priority == 'High' ? Colors.red : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(productDisplay, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: $status',
                              style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.phone, color: Colors.green, size: 20),
                                  tooltip: 'Call Client',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Calling $clientName at $phone...')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.message, color: Colors.blue, size: 20),
                                  tooltip: 'WhatsApp Client',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Opening WhatsApp chat with $clientName ($phone)...')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}