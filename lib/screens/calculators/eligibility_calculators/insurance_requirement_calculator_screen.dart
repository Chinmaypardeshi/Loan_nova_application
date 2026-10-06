import 'package:flutter/material.dart';

class InsuranceRequirementCalculatorScreen extends StatefulWidget {
  const InsuranceRequirementCalculatorScreen({super.key});

  @override
  State<InsuranceRequirementCalculatorScreen> createState() => _InsuranceRequirementCalculatorScreenState();
}

class _InsuranceRequirementCalculatorScreenState extends State<InsuranceRequirementCalculatorScreen> {
  double _annualIncome = 900000;
  double _outstandingLoans = 2500000;
  double _existingCover = 1000000;

  Map<String, double> _calculateInsurance() {
    // Human Life Value (HLV) Rule of Thumb: 10x to 15x annual income + outstanding loans - existing cover
    double recommendedCover = (_annualIncome * 12) + _outstandingLoans - _existingCover;
    if (recommendedCover < 0) recommendedCover = 0;

    return {
      'recommended': recommendedCover,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateInsurance();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Coverage Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Recommended Life Cover', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${(result['recommended']! / 100000).toStringAsFixed(1)} Lakhs',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSlider(
              title: 'Annual Income',
              value: _annualIncome,
              min: 300000,
              max: 5000000,
              divisions: 47,
              formatter: (v) => '₹ ${(v / 100000).toStringAsFixed(1)} Lakhs',
              onChanged: (v) => setState(() => _annualIncome = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Total Outstanding Loans',
              value: _outstandingLoans,
              min: 0,
              max: 10000000,
              divisions: 40,
              formatter: (v) => '₹ ${(v / 100000).toStringAsFixed(1)} Lakhs',
              onChanged: (v) => setState(() => _outstandingLoans = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) formatter,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(formatter(value), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.indigo)),
              ],
            ),
            Slider(value: value, min: min, max: max, divisions: divisions, activeColor: Colors.indigo, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}