
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/login_screen.dart';

class SalesCrmScreen extends StatefulWidget {
  const SalesCrmScreen({super.key});

  @override
  State<SalesCrmScreen> createState() => _SalesCrmScreenState();
}

class _SalesCrmScreenState extends State<SalesCrmScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _leads = [];

  static const _statusOptions = [
    'New Lead',
    'Under Review',
    'Documentation',
    'Follow-up Required',
    'Approved',
    'Rejected',
  ];

  static const _activeStatuses = [
    'submitted',
    'new lead',
    'under review',
    'documentation',
    'follow-up required',
  ];

  static const _convertedStatuses = ['approved', 'disbursed / approved'];

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  void _snack(String message, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  String _statusOf(Map<String, dynamic> lead) =>
      (lead['status'] ?? 'New Lead').toString();

  // Fetch live leads and applications from Supabase
  Future<void> _fetchLeads() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('applications')
          .select('*, profiles(full_name, phone_number)')
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _leads = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error fetching sales leads from Supabase: $e');
      _snack('Failed to load leads: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Update lead status in Supabase
  Future<void> _updateLeadStatus(dynamic leadId, String newStatus) async {
    try {
      await supabase
          .from('applications')
          .update({'status': newStatus}).eq('id', leadId);

      await _fetchLeads(); // Refresh list live
      _snack('Lead status updated to $newStatus', color: Colors.green);
    } catch (e) {
      _snack('Failed to update status: $e', color: Colors.red);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'new lead':
        return Colors.blue;
      case 'under review':
      case 'documentation':
        return Colors.orange;
      case 'follow-up required':
        return Colors.purple;
      case 'approved':
      case 'disbursed / approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Customer name: prefer the name typed in by sales, fall back to the joined profile
  String _applicantName(Map<String, dynamic> lead) {
    final direct = lead['customer_name']?.toString();
    if (direct != null && direct.isNotEmpty) return direct;
    final profile = lead['profiles'];
    if (profile is Map && profile['full_name'] != null) {
      return profile['full_name'].toString();
    }
    return 'Customer';
  }

  String? _applicantPhone(Map<String, dynamic> lead) {
    final direct = lead['customer_phone']?.toString();
    if (direct != null && direct.isNotEmpty) return direct;
    final profile = lead['profiles'];
    if (profile is Map && profile['phone_number'] != null) {
      return profile['phone_number'].toString();
    }
    return null;
  }

  Future<void> _openWhatsApp(String? phone, String name) async {
    final digits = (phone ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _snack('No phone number available for $name');
      return;
    }
    // Assume India (+91) when a 10-digit number is stored
    final number = digits.length == 10 ? '91$digits' : digits;
    try {
      final opened = await launchUrl(
        Uri.parse('https://wa.me/$number'),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) _snack('Could not open WhatsApp');
    } catch (e) {
      _snack('Could not open WhatsApp: $e', color: Colors.red);
    }
  }

  void _showStatusSheet(Map<String, dynamic> lead) {
    final current = _statusOf(lead);
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Update Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            for (final s in _statusOptions)
              ListTile(
                leading: Icon(Icons.circle, size: 12, color: _getStatusColor(s)),
                title: Text(s),
                trailing: s.toLowerCase() == current.toLowerCase()
                    ? const Icon(Icons.check, color: Colors.indigo)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext);
                  if (s.toLowerCase() != current.toLowerCase()) {
                    _updateLeadStatus(lead['id'], s);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAddLeadDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    String selectedProduct = 'Personal Loan';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        // StatefulBuilder lets the dropdown redraw with the new selection
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Assign New Lead'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                  const InputDecoration(labelText: 'Customer Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Estimated Amount (₹)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedProduct,
                  items: [
                    'Personal Loan',
                    'Home Loan',
                    'Business MSME Loan',
                    'Credit Card',
                    'Insurance'
                  ]
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedProduct = val);
                    }
                  },
                  decoration:
                  const InputDecoration(labelText: 'Financial Product'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white),
              onPressed: () async {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
                final amount = double.tryParse(amountController.text.trim());

                if (name.isEmpty) {
                  _snack('Please enter the customer name');
                  return;
                }
                if (phone.replaceAll(RegExp(r'\D'), '').length < 10) {
                  _snack('Please enter a valid phone number');
                  return;
                }
                if (amount == null || amount <= 0) {
                  _snack('Please enter a valid amount');
                  return;
                }

                try {
                  final userId = supabase.auth.currentUser?.id;
                  await supabase.from('applications').insert({
                    'user_id': userId,
                    'customer_name': name,
                    'customer_phone': phone,
                    'product_name': selectedProduct,
                    'category': 'Loans',
                    'status': 'New Lead',
                    'requested_amount': amount,
                  });

                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                  _snack('Lead successfully added to CRM pipeline!',
                      color: Colors.green);
                  _fetchLeads();
                } catch (e) {
                  _snack('Error adding lead: $e', color: Colors.red);
                }
              },
              child: const Text('Save Lead'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic KPI calculations from live data
    final totalLeads = _leads.length;
    final activePipeline = _leads
        .where((l) => _activeStatuses.contains(_statusOf(l).toLowerCase()))
        .length;
    final converted = _leads
        .where((l) => _convertedStatuses.contains(_statusOf(l).toLowerCase()))
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales CRM Workspace'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Pipeline',
            onPressed: _fetchLeads,
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
          : Column(
        children: [
          // Quick KPI Summary Bar connected to live data
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildKpiCard('Total Leads', '$totalLeads', Colors.indigo),
                _buildKpiCard('In Pipeline', '$activePipeline', Colors.orange),
                _buildKpiCard('Converted', '$converted', Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Lead Pipeline List Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Assigned Lead Pipeline',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Live Supabase Sync',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          // Lead Cards List
          Expanded(
            child: _leads.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No leads found in pipeline queue.',
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            )
                : RefreshIndicator(
              onRefresh: _fetchLeads,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _leads.length,
                itemBuilder: (context, index) =>
                    _buildLeadCard(_leads[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard(Map<String, dynamic> lead) {
    final status = _statusOf(lead);
    final statusColor = _getStatusColor(status);
    final applicantName = _applicantName(lead);
    final phone = _applicantPhone(lead);

    final productName = lead['product_name'] ?? 'Financial Product';
    final amount =
    lead['requested_amount'] != null ? '₹${lead['requested_amount']}' : 'N/A';

    // Safe even if the id is an int or shorter than 8 characters
    final idText = lead['id']?.toString() ?? 'N/A';
    final refId = idText.length > 8 ? idText.substring(0, 8) : idText;

    final createdAt = lead['created_at']?.toString();
    final createdDate = (createdAt != null && createdAt.length >= 10)
        ? createdAt.substring(0, 10)
        : 'Recent';

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
                Text('Ref: $refId',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(applicantName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text('$productName • $amount',
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  createdDate,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600),
                ),
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
                  onPressed: () => _openWhatsApp(phone, applicantName),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white
                  ),
                  icon: const Icon(Icons.send, size: 14),
                  label: const Text('Send to Ops', style: TextStyle(fontSize: 12)),
                  onPressed: () async {
                    // Updates status so it immediately appears in Internal Operations queue
                    await _updateLeadStatus(lead['id'], 'Under Review');
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

