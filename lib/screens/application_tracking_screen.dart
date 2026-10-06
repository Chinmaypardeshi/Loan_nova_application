import 'package:flutter/material.dart';

class ApplicationTrackingScreen extends StatelessWidget {
  const ApplicationTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock list of active user applications matching LoanNova marketplace items
    final List<Map<String, dynamic>> applications = [
      {
        'refId': 'INV-948201',
        'title': 'High-Growth Equity Mutual Fund (SIP)',
        'type': 'Investment / SIP',
        'amount': '₹ 5,000 / month',
        'status': 'Active & Auto-Debit Set',
        'statusColor': Colors.green,
        'date': 'Oct 4, 2026',
        'step': 3, // 3 out of 3 complete
      },
      {
        'refId': 'LN-774102',
        'title': 'Home Loan - 20 Years Tenure',
        'type': 'Loan Application',
        'amount': '₹ 45,00,000',
        'status': 'Document Verification Pending',
        'statusColor': Colors.orange,
        'date': 'Oct 2, 2026',
        'step': 2, // 2 out of 3 complete
      },
      {
        'refId': 'CC-332910',
        'title': 'Platinum Rewards Credit Card',
        'type': 'Credit Card',
        'amount': '₹ 2,00,000 Limit',
        'status': 'Approved & Dispatched',
        'statusColor': Colors.blue,
        'date': 'Sep 28, 2026',
        'step': 3,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracking Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          final Color statusColor = app['statusColor'];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Type and Reference ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app['type'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          app['refId'],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title and Amount
                  Text(
                    app['title'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Amount/Value: ${app['amount']}',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),

                  // Status Indicator Row
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: statusColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          app['status'],
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
                        ),
                      ),
                      Text(
                        app['date'],
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo,
                        side: const BorderSide(color: Colors.indigo),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Details: ${app['refId']}'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Service: ${app['title']}'),
                                const SizedBox(height: 8),
                                Text('Current Status: ${app['status']}'),
                                const SizedBox(height: 8),
                                const Text('Your application is being processed securely via LoanNova Gateway.'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('View Application Status Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}