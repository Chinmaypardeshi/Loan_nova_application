import 'dart:math';
import 'package:flutter/material.dart';

class RetirementCalculatorScreen extends StatefulWidget {
  const RetirementCalculatorScreen({super.key});

  @override
  State<RetirementCalculatorScreen> createState() => _RetirementCalculatorScreenState();
}

class _RetirementCalculatorScreenState extends State<RetirementCalculatorScreen> {
  double _currentAge = 30;
  double _retirementAge = 60;
  double _monthlyExpenses = 40000;
  double _inflationRate = 6.0;
  double _expectedReturn = 12.0;

  Map<String, double> _calculateRetirement() {
    int yearsToRetirement = (_retirementAge - _currentAge).toInt();
    if (yearsToRetirement <= 0) yearsToRetirement = 1;

    // Future monthly expenses adjusted for inflation
    double futureMonthlyExpenses = _monthlyExpenses * pow(1 + (_inflationRate / 100), yearsToRetirement);
    double futureAnnualExpenses = futureMonthlyExpenses * 12;

    // Required corpus at retirement (assuming 20 years post-retirement life)
    double totalCorpusNeeded = futureAnnualExpenses * 18;

    // Monthly savings needed today via SIP to reach this corpus
    double i = (_expectedReturn / 100) / 12;
    double n = yearsToRetirement * 12;
    double monthlySavingsNeeded = 0;
    if (i > 0 && n > 0) {
      monthlySavingsNeeded = totalCorpusNeeded * i / ((pow(1 + i, n) - 1) * (1 + i));
    }

    return {
      'corpusNeeded': totalCorpusNeeded > 0 ? totalCorpusNeeded : 0,
      'monthlySavings': monthlySavingsNeeded > 0 ? monthlySavingsNeeded : 0,
      'futureExpenses': futureMonthlyExpenses > 0 ? futureMonthlyExpenses : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateRetirement();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Retirement Planning Calculator'),
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
                    const Text('Target Retirement Corpus', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${(result['corpusNeeded']! / 100000).toStringAsFixed(2)} Lakhs',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol('Monthly SIP Needed', '₹ ${result['monthlySavings']!.toStringAsFixed(0)}', Colors.greenAccent),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultCol('Future Mo. Expense', '₹ ${result['futureExpenses']!.toStringAsFixed(0)}', Colors.white70),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders
            _buildSlider(
              title: 'Current Age',
              value: _currentAge,
              min: 18,
              max: 58,
              divisions: 40,
              formatter: (v) => '${v.toStringAsFixed(0)} Years',
              onChanged: (v) => setState(() => _currentAge = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Retirement Age',
              value: _retirementAge,
              min: 40,
              max: 70,
              divisions: 30,
              formatter: (v) => '${v.toStringAsFixed(0)} Years',
              onChanged: (v) => setState(() => _retirementAge = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Current Monthly Expenses',
              value: _monthlyExpenses,
              min: 10000,
              max: 200000,
              divisions: 38,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _monthlyExpenses = v),
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