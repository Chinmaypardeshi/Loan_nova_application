import 'package:flutter/material.dart';
// If you have your NotificationService imported globally, import it here:
// import 'package:loannova_mobile_app/notification_service.dart';

class InvestmentApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> investmentPlan;

  const InvestmentApplicationScreen({super.key, required this.investmentPlan});

  @override
  State<InvestmentApplicationScreen> createState() => _InvestmentApplicationScreenState();
}

class _InvestmentApplicationScreenState extends State<InvestmentApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _panController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _panController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network request & reference ID generation
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        final String refId = 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Investment Order Placed!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your SIP/Investment order for ${widget.investmentPlan['title']} has been successfully initiated.'),
                const SizedBox(height: 12),
                Text('Reference ID: $refId', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 8),
                const Text('First installment will be auto-debited from your linked bank account within 2 working days.'),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to marketplace
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.investmentPlan;

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply: ${plan['title']}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing your investment application...'),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.indigo),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Category: ${plan['category']} • Expected Returns: ${plan['returns']}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Monthly / Initial Investment Amount (₹)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g. 5000',
                  prefixText: '₹ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an investment amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('PAN Card Number', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _panController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ABCDE1234F',
                ),
                validator: (value) {
                  if (value == null || value.length != 10) {
                    return 'Please enter a valid 10-character PAN number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submitApplication,
                  child: const Text('Confirm & Start SIP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}