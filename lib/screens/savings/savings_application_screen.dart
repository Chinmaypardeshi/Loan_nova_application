import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/notification_service.dart';

class SavingsApplicationScreen extends StatefulWidget {
  final String productTitle;
  final String providerName;
  final String interestRate;

  const SavingsApplicationScreen({
    super.key,
    required this.productTitle,
    required this.providerName,
    required this.interestRate,
  });

  @override
  State<SavingsApplicationScreen> createState() => _SavingsApplicationScreenState();
}

class _SavingsApplicationScreenState extends State<SavingsApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _panController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate network request / database submission delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isSubmitting = false;
        });

        // Push a live notification to the Notification Service
        NotificationService().addNotification(
          title: 'Account Application Submitted!',
          message: 'Your application for ${widget.productTitle} with ${widget.providerName} is under review.',
          icon: Icons.account_balance,
          color: Colors.teal,
        );

        // Show success dialog with tracking details
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Application Success'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your application for ${widget.productTitle} has been successfully submitted to ${widget.providerName}.'),
                const SizedBox(height: 12),
                Text(
                  'Reference ID: #SAV-${100000 + (DateTime.now().millisecond % 900000)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                const SizedBox(height: 8),
                const Text('You will receive a notification once verification is complete (typically 24 hours).',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to marketplace
                },
                child: const Text('Back to Marketplace'),
              ),
            ],
          ),
        );
      });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                    ),
                    const SizedBox(height: 4),
                    Text('Provided by ${widget.providerName} • Rate: ${widget.interestRate}',
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Enter Application Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Initial Deposit / Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Initial Deposit / Investment Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PAN Card Field
              TextFormField(
                controller: _panController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'PAN Card Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.length != 10) {
                    return 'Please enter a valid 10-character PAN number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Annual Income Field
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Annual Income (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your annual income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSubmitting ? null : _submitApplication,
                  child: _isSubmitting
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