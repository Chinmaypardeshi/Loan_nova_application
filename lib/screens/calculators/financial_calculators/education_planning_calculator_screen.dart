import 'dart:math';
import 'package:flutter/material.dart';

class EducationPlanningCalculatorScreen extends StatefulWidget {
  const EducationPlanningCalculatorScreen({super.key});

  @override
  State<EducationPlanningCalculatorScreen> createState() => _EducationPlanningCalculatorScreenState();
}

class _EducationPlanningCalculatorScreenState extends State<EducationPlanningCalculatorScreen> {
  double _childCurrentAge = 5;
  double _collegeAge = 18;
  double _currentCost = 1500000; // Current total cost of higher education
  double _educationInflation = 8.0; // Higher education inflation rate
  double _expectedReturn = 12.0; // Expected investment return

  Map<String, double> _calculateEducation() {
    int yearsLeft = (_collegeAge - _childCurrentAge).toInt();
    if (yearsLeft <= 0) yearsLeft = 1;

    // Future Cost Formula: FV = PV * (1 + r)^t
    double futureCost = _currentCost * pow(1 + (_educationInflation / 100), yearsLeft);

    // Monthly SIP needed to reach the future cost
    double i = (_expectedReturn / 100) / 12;
    double n = yearsLeft * 12;
    double monthlySipNeeded = 0;
    if (i > 0 && n > 0) {
      monthlySipNeeded = futureCost * i / ((pow(1 + i, n) - 1) * (1 + i));
    }

    return {
      'futureCost': futureCost > 0 ? futureCost : _currentCost,
      'monthlySip': monthlySipNeeded > 0 ? monthlySipNeeded : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateEducation();
    int yearsLeft = (_collegeAge - _childCurrentAge).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Planning Calculator'),
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
                    const Text('Estimated Future Education Cost', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${(result['futureCost']! / 100000).toStringAsFixed(2)} Lakhs',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol('Monthly SIP Needed', '₹ ${result['monthlySip']!.toStringAsFixed(0)}', Colors.greenAccent),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultCol('Time to Goal', '$yearsLeft Years', Colors.white70),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders
            _buildSlider(
              title: "Child's Current Age",
              value: _childCurrentAge,
              min: 0,
              max: 16,
              divisions: 16,
              formatter: (v) => '${v.toStringAsFixed(0)} Years',
              onChanged: (v) => setState(() => _childCurrentAge = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'College Admission Age',
              value: _collegeAge,
              min: 17,
              max: 22,
              divisions: 5,
              formatter: (v) => '${v.toStringAsFixed(0)} Years',
              onChanged: (v) => setState(() => _collegeAge = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Current Cost of Education',
              value: _currentCost,
              min: 500000,
              max: 5000000,
              divisions: 45,
              formatter: (v) => '₹ ${(v / 100000).toStringAsFixed(1)} Lakhs',
              onChanged: (v) => setState(() => _currentCost = v),
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