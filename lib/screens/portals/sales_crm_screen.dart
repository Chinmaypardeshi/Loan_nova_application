import 'package:flutter/material.dart';

class SalesCrmScreen extends StatefulWidget {
  const SalesCrmScreen({super.key});

  @override
  State<SalesCrmScreen> createState() => _SalesCrmScreenState();
}

class _SalesCrmScreenState extends State<SalesCrmScreen> {
  // Mock data for assigned sales leads and pipeline
  final List<Map<String, dynamic>> _leads = [
    {
      'id': 'LD-101',
      'name': 'Aarav Sharma',
      'product': 'Personal Loan (₹ 6,00,000)',
      'phone': '+91 98765 43210',
      'status': 'New Lead',
      'priority': 'High',
      'nextFollowUp': 'Today, 4:00 PM',
    },
    {
      'id': 'LD-102',
      'name': 'Priya Patel',
      'product': 'Home Loan (₹ 55,00,000)',
      'phone': '+91 91234 56789',
      'status': 'Documentation',
      'priority': 'Urgent',
      'nextFollowUp': 'Tomorrow, 11:30 AM',
    },
    {
      'id': 'LD-103',
      'name': 'Vikram Malhotra',
      'product': 'Business MSME Loan (₹ 25,00,000)',
      'phone': '+91 99887 76655',
      'status': 'Follow-up Required',
      'priority': 'Medium',
      'nextFollowUp': 'Oct 12, 2026',
    },
    {
      'id': 'LD-104',
      'name': 'Neha Gupta',
      'product': 'Credit Card (Super Cashback)',
      'phone': '+91 97654 32109',
      'status': 'Disbursed / Approved',
      'priority': 'Low',
      'nextFollowUp': 'Completed',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New Lead':
        return Colors.blue;
      case 'Documentation':
        return Colors.orange;
      case 'Follow-up Required':
        return Colors.purple;
      case 'Disbursed / Approved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showAddLeadDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedProduct = 'Personal Loan';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign New Lead'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Customer Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedProduct,
              items: ['Personal Loan', 'Home Loan', 'Business Loan', 'Credit Card', 'Insurance']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => selectedProduct = val!,
              decoration: const InputDecoration(labelText: 'Financial Product'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                setState(() {
                  _leads.insert(0, {
                    'id': 'LD-10${_leads.length + 1}',
                    'name': nameController.text,
                    'product': '$selectedProduct (Custom)',
                    'phone': phoneController.text,
                    'status': 'New Lead',
                    'priority': 'High',
                    'nextFollowUp': 'Immediately',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lead successfully added to CRM pipeline!')),
                );
              }
            },
            child: const Text('Save Lead'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales CRM Workspace'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddLeadDialog,
            tooltip: 'Add Lead',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick KPI Summary Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildKpiCard('Active Leads', '${_leads.length}', Colors.indigo),
                _buildKpiCard('Pending Follow-ups', '2', Colors.orange),
                _buildKpiCard('Converted', '1', Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Lead Pipeline List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Assigned Lead Pipeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Sort by Priority', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          // Lead Cards List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _leads.length,
              itemBuilder: (context, index) {
                final lead = _leads[index];
                final Color statusColor = _getStatusColor(lead['status']);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lead['id'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                lead['status'],
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(lead['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(lead['product'], style: const TextStyle(fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(lead['phone'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const Spacer(),
                            const Icon(Icons.schedule, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(lead['nextFollowUp'], style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                              icon: const Icon(Icons.chat, size: 16),
                              label: const Text('WhatsApp', style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Opening WhatsApp chat with ${lead['name']} (${lead['phone']})...')),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                              icon: const Icon(Icons.call, size: 16),
                              label: const Text('Call Lead', style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Initiating telecall to ${lead['name']}...')),
                                );
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
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}