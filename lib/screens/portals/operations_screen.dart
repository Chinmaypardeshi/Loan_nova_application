import 'package:flutter/material.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  // Sample queue of operational loan applications and KYC files requiring review
  final List<Map<String, dynamic>> _operationsQueue = [
    {
      'id': 'LN-99210',
      'applicant': 'Vikram Malhotra',
      'type': 'Home Loan - ₹50 Lakhs',
      'kycStatus': 'Pending Verification',
      'cibil': '765',
      'stage': 'Document Audit',
    },
    {
      'id': 'LN-99211',
      'applicant': 'Sneha Joshi',
      'type': 'Personal Loan - ₹3 Lakhs',
      'kycStatus': 'Verified',
      'cibil': '810',
      'stage': 'Underwriting',
    },
    {
      'id': 'LN-99212',
      'applicant': 'Amitabh Roy',
      'type': 'Business Loan - ₹15 Lakhs',
      'kycStatus': 'Verified',
      'cibil': '720',
      'stage': 'Ready for Disbursement',
    },
  ];

  void _updateStage(int index, String newStage) {
    setState(() {
      _operationsQueue[index]['stage'] = newStage;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application ${_operationsQueue[index]['id']} updated to: $newStage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internal Operations & Underwriting'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Metrics summary
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
                _buildMetricItem('Pending Audits', '1'),
                _buildMetricItem('In Underwriting', '1'),
                _buildMetricItem('Disbursement Queue', '1'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Operational Loan & KYC Queue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Queue List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _operationsQueue.length,
            itemBuilder: (context, index) {
              final item = _operationsQueue[index];
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
                            'Ref: ${item['id']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Text(
                              'CIBIL: ${item['cibil']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item['applicant'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(item['type'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stage: ${item['stage']}',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo, fontSize: 13),
                          ),
                          DropdownButton<String>(
                            value: item['stage'],
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 'Document Audit', child: Text('Audit', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'Underwriting', child: Text('Underwrite', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'Ready for Disbursement', child: Text('Disburse', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _updateStage(index, val);
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