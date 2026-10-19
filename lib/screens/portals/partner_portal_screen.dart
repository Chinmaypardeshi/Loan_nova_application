import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login_screen.dart';

class PartnerPortalScreen extends StatefulWidget {
  const PartnerPortalScreen({super.key});

  @override
  State<PartnerPortalScreen> createState() => _PartnerPortalScreenState();
}

class _PartnerPortalScreenState extends State<PartnerPortalScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _incomingLeads = [];

  // Partner's active financial products
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
      'interestRate': 3.50,
      'status': 'Active',
      'applicationsCount': 310,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchPartnerData();
  }

  void _snack(String message, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // Fetch live incoming leads/applications from Supabase backend
  Future<void> _fetchPartnerData() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('applications')
          .select('*, profiles(full_name, phone_number)')
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _incomingLeads = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error fetching partner leads: $e');
      _snack('Failed to load incoming leads: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Update lead / application status live in Supabase
  Future<void> _updateLeadStage(dynamic leadId, String newStage) async {
    try {
      await supabase.from('applications').update({
        'status': newStage,
      }).eq('id', leadId);

      await _fetchPartnerData();
      _snack('Lead stage updated to $newStage', color: Colors.green);
    } catch (e) {
      _snack('Failed to update status: $e', color: Colors.red);
    }
  }

  // Dialog to publish new financial products live to Supabase marketplace
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
            onPressed: () async {
              final name = nameController.text.trim();
              final rate = double.tryParse(rateController.text.trim());

              if (name.isEmpty || rate == null) {
                _snack('Please enter a valid product name and interest rate', color: Colors.orange);
                return;
              }

              try {
                // Insert into Supabase 'products' table using 'product_name' to satisfy table constraints
                await supabase.from('products').insert({
                  'product_name': name,
                  'title': name, // Included for compatibility
                  'category': selectedCategory,
                  'interest_rate': rate,
                  'provider_name': 'Financial Partner Institution',
                  'status': 'Active',
                });

                if (context.mounted) Navigator.pop(context);

                setState(() {
                  _partnerProducts.add({
                    'id': 'P-0${_partnerProducts.length + 1}',
                    'name': name,
                    'category': selectedCategory,
                    'interestRate': rate,
                    'status': 'Active',
                    'applicationsCount': 0,
                  });
                });

                _snack('Product published live to LoanNova Marketplace!', color: Colors.green);
              } catch (e) {
                _snack('Error publishing product: $e', color: Colors.red);
              }
            },
            child: const Text('Publish Product'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'new lead':
        return Colors.blue;
      case 'under review':
        return Colors.orange;
      case 'approved':
      case 'disbursed / approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Data',
              onPressed: _fetchPartnerData,
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
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Product Catalog'),
              Tab(icon: Icon(Icons.people), text: 'Live Incoming Leads'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
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

            // Tab 2: Live Incoming Leads from Supabase
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Live Customer Loan Pipeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _incomingLeads.isEmpty
                        ? const Center(
                      child: Text('No incoming customer applications found.', style: TextStyle(color: Colors.grey)),
                    )
                        : RefreshIndicator(
                      onRefresh: _fetchPartnerData,
                      child: ListView.builder(
                        itemCount: _incomingLeads.length,
                        itemBuilder: (context, index) {
                          final lead = _incomingLeads[index];
                          final status = lead['status'] ?? 'Submitted';
                          final statusColor = _getStatusColor(status);

                          String applicantName = 'Customer';
                          if (lead['customer_name'] != null) {
                            applicantName = lead['customer_name'];
                          } else if (lead['profiles'] != null && lead['profiles']['full_name'] != null) {
                            applicantName = lead['profiles']['full_name'];
                          }

                          final productName = lead['product_name'] ?? 'Financial Product';
                          final amount = lead['requested_amount'] != null ? '₹${lead['requested_amount']}' : 'N/A';
                          final idText = lead['id']?.toString() ?? 'N/A';
                          final refId = idText.length > 8 ? idText.substring(0, 8) : idText;
                          final createdAt = lead['created_at'] != null ? lead['created_at'].toString().substring(0, 10) : 'Recent';

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
                                      Text('Ref: $refId', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Applicant: $applicantName', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  Text('Requested Product: $productName ($amount)', style: const TextStyle(fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Date: $createdAt', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      OutlinedButton(
                                        onPressed: () => _updateLeadStage(lead['id'], 'Under Review'),
                                        child: const Text('Move to Review', style: TextStyle(fontSize: 12)),
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