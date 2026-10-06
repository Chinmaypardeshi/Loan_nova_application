import 'package:flutter/material.dart';

class TaxCalculatorScreen extends StatefulWidget {
  const TaxCalculatorScreen({super.key});

  @override
  State<TaxCalculatorScreen> createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  double _annualSalary = 1200000;
  double _deductions80C = 150000; // Max limit under 80C
  double _otherDeductions = 50000; // e.g., Health insurance 80D / NPS

  Map<String, double> _calculateTax() {
    const double standardDeduction = 50000;

    // --- NEW TAX REGIME ---
    double taxableIncomeNew = _annualSalary - standardDeduction;
    if (taxableIncomeNew < 0) taxableIncomeNew = 0;
    double taxNew = _computeNewRegimeTax(taxableIncomeNew);

    // --- OLD TAX REGIME ---
    double totalDeductions = _deductions80C + _otherDeductions + standardDeduction;
    double taxableIncomeOld = _annualSalary - totalDeductions;
    if (taxableIncomeOld < 0) taxableIncomeOld = 0;
    double taxOld = _computeOldRegimeTax(taxableIncomeOld);

    return {
      'taxNew': taxNew,
      'taxOld': taxOld,
    };
  }

  double _computeNewRegimeTax(double income) {
    double tax = 0;
    if (income > 1500000) {
      tax += (income - 1500000) * 0.30;
      income = 1500000;
    }
    if (income > 1200000) {
      tax += (income - 1200000) * 0.20;
      income = 1200000;
    }
    if (income > 1000000) {
      tax += (income - 1000000) * 0.15;
      income = 1000000;
    }
    if (income > 700000) {
      tax += (income - 700000) * 0.10;
      income = 700000;
    }
    if (income > 300000) {
      tax += (income - 300000) * 0.05;
    }
    return tax > 0 ? tax : 0;
  }

  double _computeOldRegimeTax(double income) {
    double tax = 0;
    if (income > 1000000) {
      tax += (income - 1000000) * 0.30;
      income = 1000000;
    }
    if (income > 500000) {
      tax += (income - 500000) * 0.20;
      income = 500000;
    }
    if (income > 250000) {
      tax += (income - 250000) * 0.05;
    }
    return tax > 0 ? tax : 0;
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateTax();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Savings & Regime Calculator'),
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
                    const Text('Tax Regime Comparison', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol('New Regime Tax', '₹ ${result['taxNew']!.toStringAsFixed(0)}', Colors.cyanAccent),
                        Container(height: 35, width: 1, color: Colors.white24),
                        _buildResultCol('Old Regime Tax', '₹ ${result['taxOld']!.toStringAsFixed(0)}', Colors.amberAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders
            _buildSlider(
              title: 'Annual Gross Salary',
              value: _annualSalary,
              min: 300000,
              max: 3000000,
              divisions: 54,
              formatter: (v) => '₹ ${(v / 100000).toStringAsFixed(1)} Lakhs',
              onChanged: (v) => setState(() => _annualSalary = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: '80C Deductions (PPF, ELSS, etc.)',
              value: _deductions80C,
              min: 0,
              max: 150000,
              divisions: 15,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _deductions80C = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Other Deductions (80D / Insurance)',
              value: _otherDeductions,
              min: 0,
              max: 200000,
              divisions: 20,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _otherDeductions = v),
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