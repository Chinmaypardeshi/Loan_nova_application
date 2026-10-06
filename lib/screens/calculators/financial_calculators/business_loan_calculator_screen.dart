import 'dart:math';
import 'package:flutter/material.dart';

class BusinessLoanCalculatorScreen extends StatefulWidget {
  const BusinessLoanCalculatorScreen({super.key});

  @override
  State<BusinessLoanCalculatorScreen> createState() => _BusinessLoanCalculatorScreenState();
}

class _BusinessLoanCalculatorScreenState extends State<BusinessLoanCalculatorScreen> {
  double _loanAmount = 2500000; // 25 Lakhs
  double _interestRate = 14.0; // Business loan interest % p.a.
  double _tenureYears = 5; // 5 Years tenure

  Map<String, double> _calculateBusinessLoan() {
    double p = _loanAmount;
    double i = (_interestRate / 100) / 12; // Monthly interest rate
    double n = _tenureYears * 12; // Total months

    // EMI Formula: EMI = [P * i * (1+i)^n] / [(1+i)^n - 1]
    double emi = 0;
    if (i > 0 && n > 0) {
      emi = (p * i * pow(1 + i, n)) / (pow(1 + i, n) - 1);
    }

    double totalPayable = emi * n;
    double totalInterest = totalPayable - p;

    return {
      'emi': emi > 0 ? emi : 0,
      'totalInterest': totalInterest > 0 ? totalInterest : 0,
      'totalPayable': totalPayable > 0 ? totalPayable : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateBusinessLoan();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Loan Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              elevation: 4,
              color: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Monthly Business EMI', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${result['emi']!.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol('Principal Amount', '₹ ${(_loanAmount / 100000).toStringAsFixed(1)} L', Colors.white70),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultCol('Total Interest', '₹ ${(result['totalInterest']! / 100000).toStringAsFixed(1)} L', Colors.amberAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders
            _buildSlider(
              title: 'Business Loan Amount',
              value: _loanAmount,
              min: 500000,
              max: 20000000,
              divisions: 39,
              formatter: (v) => '₹ ${(v / 100000).toStringAsFixed(1)} Lakhs',
              onChanged: (v) => setState(() => _loanAmount = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Interest Rate (% p.a.)',
              value: _interestRate,
              min: 10.0,
              max: 24.0,
              divisions: 28,
              formatter: (v) => '${v.toStringAsFixed(1)} %',
              onChanged: (v) => setState(() => _interestRate = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Tenure (Years)',
              value: _tenureYears,
              min: 1,
              max: 7,
              divisions: 6,
              formatter: (v) => '${v.toStringAsFixed(0)} Years',
              onChanged: (v) => setState(() => _tenureYears = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
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