import 'package:flutter/material.dart';

import '../api/api_service.dart';

class ApplicationScreen extends StatefulWidget {
  final int loanId;
  final String loanName;
  final double maxAmount;
  final double interestRate;

  const ApplicationScreen({
    super.key,
    required this.loanId,
    this.loanName = 'Personal Loan',
    this.maxAmount = 0,
    this.interestRate = 0,
  });

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final tenureController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    amountController.dispose();
    tenureController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isSubmitting = true;
      });

      final userId = await ApiService.getUserId();

      if (userId == null) {
        throw Exception(
          'User session not found. Please login again.',
        );
      }

      final requestedAmount =
          double.parse(amountController.text.trim());

      final tenure =
          int.parse(tenureController.text.trim());

      final application =
          await ApiService.createLoanApplication(
        userId,
        widget.loanId,
        requestedAmount,
        tenure,
      );

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Loan application submitted successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Return application data to previous screen
      Navigator.pop(context, application);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply for Loan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // LOAN NAME
              // =========================
              Text(
                widget.loanName,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Fill in the loan details to submit your application',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // LOAN SUMMARY
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.indigo.withOpacity(0.12),
                  ),
                ),
                child: Column(
                  children: [
                    _summaryRow(
                      'Interest Rate',
                      '${widget.interestRate.toStringAsFixed(2)}%',
                    ),
                    const SizedBox(height: 12),
                    _summaryRow(
                      'Maximum Amount',
                      '₹${widget.maxAmount.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // REQUESTED AMOUNT
              // =========================
              _field(
                controller: amountController,
                label: 'Requested Amount',
                hint: 'Enter loan amount',
                icon: Icons.currency_rupee,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter requested amount';
                  }

                  final amount = double.tryParse(
                    value.trim(),
                  );

                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }

                  if (widget.maxAmount > 0 &&
                      amount > widget.maxAmount) {
                    return 'Amount cannot exceed ₹${widget.maxAmount.toStringAsFixed(0)}';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =========================
              // TENURE
              // =========================
              _field(
                controller: tenureController,
                label: 'Tenure',
                hint: 'Enter tenure in months',
                icon: Icons.calendar_month_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter tenure';
                  }

                  final tenure = int.tryParse(
                    value.trim(),
                  );

                  if (tenure == null || tenure <= 0) {
                    return 'Enter valid tenure in months';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'Example: 12, 24, 36 or 60 months',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // SUBMIT BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      isSubmitting ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.indigo.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Application',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // INFO
              // =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your application will be submitted with PENDING status. '
                      'The final status will be updated after review.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // SUMMARY ROW
  // =========================
  Widget _summaryRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =========================
  // FORM FIELD
  // =========================
  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.indigo,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}