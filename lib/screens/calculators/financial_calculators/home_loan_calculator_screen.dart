import 'dart:math';
import 'package:flutter/material.dart';

class HomeLoanCalculatorScreen extends StatefulWidget {
  const HomeLoanCalculatorScreen({super.key});

  @override
  State<HomeLoanCalculatorScreen> createState() => _HomeLoanCalculatorScreenState();
}

class _HomeLoanCalculatorScreenState extends State<HomeLoanCalculatorScreen> {
  double _monthlyIncome = 75000;
  double _existingEmis = 5000;
  double _interestRate = 8.5; // Annual %
  double _tenureYears = 20; // Years

  Map<String, double> _calculateEligibility() {
    // Banks typically allow up to 50% of net monthly income for all EMIs combined (FOIR)
    final double maxAllowedEmi = (_monthlyIncome * 0.50) - _existingEmis;
    final double effectiveEmi = maxAllowedEmi > 0 ? maxAllowedEmi : 0;

    final double i = (_interestRate / 100) / 12; // Monthly interest rate
    final double n = _tenureYears * 12; // Total months

    // Loan Amount Formula: P = EMI * [ (1+i)^n - 1 ] / [ i * (1+i)^n ]
    double eligibleLoanAmount = 0;
    if (effectiveEmi > 0 && i > 0) {
      eligibleLoanAmount = effectiveEmi * ((pow(1 + i, n) - 1) / (i * pow(1 + i, n)));
    }

    final double totalPayable = effectiveEmi * n;
    final double totalInterest = totalPayable - eligibleLoanAmount;

    return {
      'maxEmi': effectiveEmi,
      'loanAmount': eligibleLoanAmount > 0 ? eligibleLoanAmount : 0,
      'totalInterest': totalInterest > 0 ? totalInterest : 0,
      'totalPayable': totalPayable > 0 ? totalPayable : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateEligibility();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Loan Eligibility'),
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
                    const Text('Eligible Loan Amount', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${result['loanAmount']!.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol('Max Safe EMI', '₹ ${result['maxEmi']!.toStringAsFixed(0)}', Colors.white70),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultCol('Total Interest', '₹ ${result['totalInterest']!.toStringAsFixed(0)}', Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders for Inputs
            _buildSlider(
              title: 'Net Monthly Income',
              value: _monthlyIncome,
              min: 20000,
              max: 500000,
              divisions: 96,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _monthlyIncome = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Existing Monthly EMIs (if any)',
              value: _existingEmis,
              min: 0,
              max: 100000,
              divisions: 50,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _existingEmis = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Interest Rate (% p.a.)',
              value: _interestRate,
              min: 6.5,
              max: 15.0,
              divisions: 34,
              formatter: (v) => '${v.toStringAsFixed(1)} %',
              onChanged: (v) => setState(() => _interestRate = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Loan Tenure (Years)',
              value: _tenureYears,
              min: 5,
              max: 30,
              divisions: 25,
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
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
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