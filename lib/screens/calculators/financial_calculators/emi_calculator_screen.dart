import 'dart:math';
import 'package:flutter/material.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  double _principal = 500000; // Default ₹5 Lakhs
  double _interestRate = 10.5; // Default 10.5%
  double _tenureYears = 5; // Default 5 years

  // Calculate EMI formula: P * r * (1 + r)^n / [(1 + r)^n - 1]
  Map<String, double> _calculateEmi() {
    int months = (_tenureYears * 12).toInt();
    double monthlyRate = _interestRate / 12 / 100;

    if (monthlyRate == 0) {
      double emi = _principal / months;
      return {'emi': emi, 'totalPayment': _principal, 'totalInterest': 0};
    }

    double emi = (_principal *
        monthlyRate *
        pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    double totalPayment = emi * months;
    double totalInterest = totalPayment - _principal;

    return {
      'emi': emi,
      'totalPayment': totalPayment,
      'totalInterest': totalInterest,
    };
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculateEmi();
    final emi = results['emi']!;
    final totalPayment = results['totalPayment']!;
    final totalInterest = results['totalInterest']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan EMI Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Results Card
            Card(
              elevation: 4,
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Monthly EMI', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      '₹${emi.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Principal Amount', style: TextStyle(color: Colors.grey)),
                            Text('₹${_principal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total Interest', style: TextStyle(color: Colors.grey)),
                            Text('₹${totalInterest.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Total Payable: ₹${totalPayment.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loan Amount Slider
            Text('Loan Amount: ₹${_principal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _principal,
              min: 50000,
              max: 10000000,
              divisions: 199,
              activeColor: Colors.indigo,
              onChanged: (value) => setState(() => _principal = value),
            ),
            const SizedBox(height: 10),

            // Interest Rate Slider
            Text('Interest Rate: $_interestRate%', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _interestRate,
              min: 5.0,
              max: 25.0,
              divisions: 40,
              activeColor: Colors.indigo,
              onChanged: (value) => setState(() => _interestRate = double.parse(value.toStringAsFixed(1))),
            ),
            const SizedBox(height: 10),

            // Tenure Slider
            Text('Loan Tenure: $_tenureYears Years (${(_tenureYears * 12).toInt()} Months)', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _tenureYears,
              min: 1,
              max: 30,
              divisions: 29,
              activeColor: Colors.indigo,
              onChanged: (value) => setState(() => _tenureYears = value),
            ),
          ],
        ),
      ),
    );
  }
}