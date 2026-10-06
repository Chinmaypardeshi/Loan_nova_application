import 'package:flutter/material.dart';

class DebtToIncomeCalculatorScreen extends StatefulWidget {
  const DebtToIncomeCalculatorScreen({super.key});

  @override
  State<DebtToIncomeCalculatorScreen> createState() => _DebtToIncomeCalculatorScreenState();
}

class _DebtToIncomeCalculatorScreenState extends State<DebtToIncomeCalculatorScreen> {
  double _monthlyIncome = 80000;
  double _monthlyDebtPayments = 24000; // Total existing EMIs, credit cards, loans

  Map<String, dynamic> _calculateDti() {
    double dtiRatio = (_monthlyDebtPayments / _monthlyIncome) * 100;
    if (_monthlyIncome == 0) dtiRatio = 0;

    String healthStatus;
    Color statusColor;
    if (dtiRatio <= 30) {
      healthStatus = 'Excellent (Low Risk for Lenders)';
      statusColor = Colors.green;
    } else if (dtiRatio <= 43) {
      healthStatus = 'Acceptable (Most lenders approve)';
      statusColor = Colors.blue;
    } else {
      healthStatus = 'High Risk (Borrowing capacity constrained)';
      statusColor = Colors.red;
    }

    return {
      'dti': dtiRatio,
      'status': healthStatus,
      'color': statusColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateDti();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt-to-Income (DTI) Ratio'),
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
                    const Text('Your DTI Ratio', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '${result['dti'].toStringAsFixed(1)} %',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      result['status'],
                      style: TextStyle(color: result['color'], fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSlider(
              title: 'Gross Monthly Income',
              value: _monthlyIncome,
              min: 20000,
              max: 300000,
              divisions: 56,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _monthlyIncome = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Total Monthly Debt Payments',
              value: _monthlyDebtPayments,
              min: 0,
              max: 150000,
              divisions: 50,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _monthlyDebtPayments = v),
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