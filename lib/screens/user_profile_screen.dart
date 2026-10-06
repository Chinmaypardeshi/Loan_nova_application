import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data matching LoanNova fintech profile
    final Map<String, dynamic> userData = {
      'name': 'Chinmay Pardeshi',
      'email': 'chinmay.pardeshi@loannova.com',
      'phone': '+91 98765 43210',
      'cibilScore': 785,
      'kycStatus': 'Verified (KYC Level 3)',
    };

    final List<Map<String, dynamic>> documents = [
      {'title': 'PAN Card', 'status': 'Verified', 'icon': Icons.badge, 'color': Colors.green},
      {'title': 'Aadhaar Card', 'status': 'Verified', 'icon': Icons.fingerprint, 'color': Colors.green},
      {'title': 'Latest 3 Months Salary Slips', 'status': 'Uploaded & Processed', 'icon': Icons.receipt, 'color': Colors.green},
      {'title': 'Income Tax Return (ITR)', 'status': 'Pending Upload', 'icon': Icons.cloud_upload, 'color': Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile & Document Hub'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.indigo.shade100,
                      child: const Text('CP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(userData['email'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(userData['phone'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              userData['kycStatus'],
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Credit Score Summary Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CIBIL Credit Score', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 4),
                      Text('Excellent Financial Health', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
                    ],
                  ),
                  Text(
                    '${userData['cibilScore']}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Secure Document Vault',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Required verification documents for instant loan approvals.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Document List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                final Color statusColor = doc['color'];

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(doc['icon'], color: Colors.indigo),
                    title: Text(doc['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(doc['status'], style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    trailing: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Managing document slot for ${doc['title']}...')),
                        );
                      },
                      child: const Text('Manage', style: TextStyle(fontSize: 12)),
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
}