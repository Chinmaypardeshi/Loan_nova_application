import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loannova_mobile_app/screens/providers/app_state.dart';

class ApplyProductScreen extends StatefulWidget {
  const ApplyProductScreen({super.key});

  @override
  State<ApplyProductScreen> createState() => _ApplyProductScreenState();
}

class _ApplyProductScreenState extends State<ApplyProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();

  // The 5 requested product categories
  String _selectedCategory = 'Loans';
  final List<String> _categories = [
    'Loans',
    'Credit Cards',
    'Insurance',
    'Savings & Deposits',
    'Investments',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _amountController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    // 1. SYNCHRONOUS GUARD: Blocks rapid double-taps instantly before any async delay
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final appState = Provider.of<AppState>(context, listen: false);

      final amount = double.tryParse(_amountController.text.trim());
      final tenure = int.tryParse(_tenureController.text.trim());

      await appState.addApplication(
        productName: _productNameController.text.trim(),
        category: _selectedCategory,
        requestedAmount: amount,
        tenureMonths: tenure,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully applied for $_selectedCategory: ${_productNameController.text}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to dashboard
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false); // Reset button so user can try again on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Financial Application'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Product Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    items: _categories.map((String cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (String? newCategory) {
                      if (newCategory != null) {
                        setState(() => _selectedCategory = newCategory);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Name / Specific Plan Field
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product / Plan Name (e.g., Platinum Rewards Credit Card, Term Life 1Cr)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a product name'
                    : null,
              ),
              const SizedBox(height: 20),

              // Requested Amount / Investment Value
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Requested Amount / Value (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Tenure in Months (if applicable)
              TextFormField(
                controller: _tenureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tenure (in Months) - Optional',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Please enter a valid integer for months';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isSubmitting ? null : _submitApplication,
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
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