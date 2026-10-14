import 'package:flutter/material.dart';

class RmDashboardScreen extends StatefulWidget {
  const RmDashboardScreen({super.key});

  @override
  State<RmDashboardScreen> createState() => _RmDashboardScreenState();
}

class _RmDashboardScreenState extends State<RmDashboardScreen> {
  // Sample portfolio data representing assigned high-value clients
  final List<Map<String, dynamic>> _clientPortfolio = [
    {
      'name': 'Rahul Sharma',
      'product': 'Home Loan - ₹45 Lakhs',
      'status': 'Document Verification',
      'phone': '+91 98765 43210',
      'priority': 'High',
    },
    {
      'name': 'Priya Deshmukh',
      'product': 'Business Expansion Loan - ₹20 Lakhs',
      'status': 'CIBIL Approved (790)',
      'phone': '+91 91234 56789',
      'priority': 'Medium',
    },
    {
      'name': 'Amit Kulkarni',
      'product': 'Personal Flexi Loan - ₹5 Lakhs',
      'status': 'Disbursed',
      'phone': '+91 99887 76655',
      'priority': 'Low',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relationship Manager Portal'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
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
                _buildStatColumn('Total Clients', '${_clientPortfolio.length}'),
                _buildStatColumn('Active Portfolio', '₹70 Lakhs'),
                _buildStatColumn('Pending Tasks', '2'),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clientPortfolio.length,
            itemBuilder: (context, index) {
              final client = _clientPortfolio[index];
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
                            client['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: client['priority'] == 'High' ? Colors.red.shade50 : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${client['priority']} Priority',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: client['priority'] == 'High' ? Colors.red : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(client['product'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status: ${client['status']}',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.phone, color: Colors.green, size: 20),
                                tooltip: 'Call Client',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling ${client['name']} at ${client['phone']}...')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.message, color: Colors.blue, size: 20),
                                tooltip: 'WhatsApp Client',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Opening WhatsApp chat with ${client['name']}...')),
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
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}