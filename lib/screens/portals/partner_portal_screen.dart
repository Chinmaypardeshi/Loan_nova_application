import 'package:flutter/material.dart';

class PartnerPortalScreen extends StatefulWidget {
  const PartnerPortalScreen({super.key});

  @override
  State<PartnerPortalScreen> createState() => _PartnerPortalScreenState();
}

class _PartnerPortalScreenState extends State<PartnerPortalScreen> {
  // Mock data for partner's active financial products
  final List<Map<String, dynamic>> _partnerProducts = [
    {
      'id': 'P-01',
      'name': 'Aura Home Loan - 20Y',
      'category': 'Home Loan',
      'interestRate': 8.45,
      'status': 'Active',
      'applicationsCount': 142,
    },
    {
      'id': 'P-02',
      'name': 'Elite Travel Rewards CC',
      'category': 'Credit Card',
      'interestRate': 3.50, // monthly
      'status': 'Active',
      'applicationsCount': 310,
    },
    {
      'id': 'P-03',
      'name': 'Apex Personal Flexi Loan',
      'category': 'Personal Loan',
      'interestRate': 10.99,
      'status': 'Under Review',
      'applicationsCount': 58,
    },
  ];

  // Mock data for incoming customer leads / applications
  final List<Map<String, dynamic>> _incomingLeads = [
    {
      'leadId': 'LN-774102',
      'applicant': 'Chinmay P.',
      'product': 'Aura Home Loan - 20Y',
      'amount': '₹ 45,00,000',
      'stage': 'Document Verification Pending',
      'date': 'Oct 8, 2026',
    },
    {
      'leadId': 'LN-882190',
      'applicant': 'Rahul S.',
      'product': 'Apex Personal Flexi Loan',
      'amount': '₹ 5,00,000',
      'stage': 'CIBIL Score Approved (790)',
      'date': 'Oct 9, 2026',
    },
  ];

  void _addNewProductDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    String selectedCategory = 'Personal Loan';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Financial Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ['Personal Loan', 'Home Loan', 'Credit Card', 'Insurance', 'Savings']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => selectedCategory = val!,
              decoration: const InputDecoration(labelText: 'Category'),
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
              if (nameController.text.isNotEmpty && rateController.text.isNotEmpty) {
                setState(() {
                  _partnerProducts.add({
                    'id': 'P-0${_partnerProducts.length + 1}',
                    'name': nameController.text,
                    'category': selectedCategory,
                    'interestRate': double.tryParse(rateController.text) ?? 9.0,
                    'status': 'Active',
                    'applicationsCount': 0,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product published successfully to LoanNova Marketplace!')),
                );
              }
            },
            child: const Text('Publish Product'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Financial Partner Portal'),
          backgroundColor: Colors.indigo.shade900,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Product Catalog'),
              Tab(icon: Icon(Icons.people), text: 'Incoming Leads'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Product Management
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Institution Catalog', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Product'),
                        onPressed: _addNewProductDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _partnerProducts.length,
                      itemBuilder: (context, index) {
                        final product = _partnerProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Category: ${product['category']} • Rate: ${product['interestRate']}%'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${product['applicationsCount']} Apps', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                                Text(product['status'], style: const TextStyle(fontSize: 11, color: Colors.green)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Tab 2: Incoming Customer Leads
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Loan & Credit Pipeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _incomingLeads.length,
                      itemBuilder: (context, index) {
                        final lead = _incomingLeads[index];
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
                                    Text('Ref: ${lead['leadId']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                                    Text(lead['date'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text('Applicant: ${lead['applicant']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text('Requested Product: ${lead['product']} (${lead['amount']})', style: const TextStyle(fontSize: 13)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Status: ${lead['stage']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange)),
                                    OutlinedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Reviewing documents for lead ${lead['leadId']}...')),
                                        );
                                      },
                                      child: const Text('Review Docs', style: TextStyle(fontSize: 12)),
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
            ),
          ],
        ),
      ),
    );
  }
}