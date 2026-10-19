import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loannova_mobile_app/notification_service.dart';

class ApplyScreen extends StatefulWidget {
  final String productId;
  final String productTitle;
  final String providerName;

  const ApplyScreen({
    super.key,
    required this.productId,
    required this.productTitle,
    required this.providerName,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _submitApplication() async {
    // 1. SYNCHRONOUS GUARD: Instantly blocks rapid multi-taps
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;

      // 2. Insert application without product_id to avoid foreign key crashes
      await supabase.from('applications').insert({
        'user_id': userId,
        'product_name': widget.productTitle,
        'category': 'Loans',
        'requested_amount': double.parse(_amountController.text),
        'tenure_months': int.parse(_tenureController.text),
        'status': 'submitted',
      });

      // Trigger notification
      NotificationService().addNotification(
        title: 'Loan Application Submitted!',
        message: 'Your application for ${widget.productTitle} has been sent to ${widget.providerName}.',
        icon: Icons.check_circle,
        color: Colors.green,
      );

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Application Submitted!'),
          content: Text('Your application for ${widget.productTitle} has been successfully sent.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to catalog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting application: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply: ${widget.productTitle}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Provider: ${widget.providerName}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Requested Amount (₹)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tenureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tenure (in months)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the loan tenure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _submitApplication,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Application', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}