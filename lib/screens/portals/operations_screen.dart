import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loannova_mobile_app/screens/providers/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login_screen.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch live applications from Supabase when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchApplications();
    });
  }

  // 🔍 Fully functional KYC Documents Audit Dialog (fetches directly via app.id)
  void _showKycDocumentsDialog(BuildContext context, dynamic app) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Fetch the application record directly from Supabase using app.id to get user_id
      final appRecord = await Supabase.instance.client
          .from('applications')
          .select('user_id')
          .eq('id', app.id)
          .maybeSingle();

      final userId = appRecord?['user_id']?.toString() ?? '';
      Map<String, dynamic>? profileData;

      // 2. Fetch the corresponding profile & KYC data if user_id exists
      if (userId.isNotEmpty) {
        final res = await Supabase.instance.client
            .from('profiles')
            .select('*')
            .eq('id', userId)
            .maybeSingle();
        profileData = res;
      }

      if (!context.mounted) return;
      Navigator.pop(context); // Remove loading indicator

      final panUrl = profileData?['pan_card_url'] ?? '';
      final aadhaarUrl = profileData?['aadhaar_url'] ?? '';
      final kycStatus = profileData?['kyc_status'] ?? 'Pending Verification';
      final applicantName = app.applicantName;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('KYC Audit: $applicantName'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Chip(
                      label: Text(kycStatus, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      backgroundColor: kycStatus == 'Verified' ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
                const Divider(height: 24),
                const Text('Uploaded Identity Files:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.indigo),
                  title: const Text('PAN Card'),
                  subtitle: Text(panUrl.isNotEmpty ? 'Document uploaded' : 'No PAN document found'),
                  trailing: panUrl.isNotEmpty ? const Text('Available', style: TextStyle(color: Colors.green)) : const Text('Missing', style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
                ListTile(
                  leading: const Icon(Icons.fingerprint, color: Colors.indigo),
                  title: const Text('Aadhaar / ID Proof'),
                  subtitle: Text(aadhaarUrl.isNotEmpty ? 'Document uploaded' : 'No ID document found'),
                  trailing: aadhaarUrl.isNotEmpty ? const Text('Available', style: TextStyle(color: Colors.green)) : const Text('Missing', style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () async {
                if (userId.isNotEmpty) {
                  await Supabase.instance.client
                      .from('profiles')
                      .update({'kyc_status': 'Verified'})
                      .eq('id', userId);
                }

                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('KYC successfully verified and approved!'), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text('Approve KYC'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading KYC documents: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final queue = appState.applications;

    // Calculate live operational metrics dynamically
    final pendingAudits = queue.where((app) => app.status == 'Submitted' || app.status == 'Pending').length;
    final inUnderwriting = queue.where((app) => app.status == 'Under Review').length;
    final approvedCount = queue.where((app) => app.status == 'Approved').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Internal Operations & Underwriting'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Queue',
            onPressed: () => appState.fetchApplications(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
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
      body: appState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Metrics summary connected to live data
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
                _buildMetricItem('Pending Audits', '$pendingAudits'),
                _buildMetricItem('In Underwriting', '$inUnderwriting'),
                _buildMetricItem('Approved', '$approvedCount'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Operational Loan & KYC Queue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Queue List from Supabase
          queue.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No applications in the pipeline queue.',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final app = queue[index];

              // Ensure current status matches dropdown items safely
              String currentStatus = app.status;
              if (!['Submitted', 'Under Review', 'Approved', 'Rejected'].contains(currentStatus)) {
                currentStatus = 'Submitted';
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Applicant: ${app.applicantName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Text(
                              'Category: ${app.category}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        app.productName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ref ID: ${app.id}',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      if (app.requestedAmount != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Amount: ₹${app.requestedAmount!.toStringAsFixed(0)} ${app.tenureMonths != null ? '• ${app.tenureMonths} mos' : ''}',
                            style: const TextStyle(color: Colors.black87, fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 🔍 Added View KYC Button here!
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.indigo),
                            icon: const Icon(Icons.folder_shared, size: 14),
                            label: const Text('View KYC', style: TextStyle(fontSize: 11)),
                            onPressed: () => _showKycDocumentsDialog(context, app),
                          ),
                          DropdownButton<String>(
                            value: currentStatus,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 'Submitted', child: Text('Submitted', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'Under Review', child: Text('Under Review', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'Approved', child: Text('Approved', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'Rejected', child: Text('Rejected', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                appState.updateApplicationStatus(app.id, val);
                              }
                            },
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
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}