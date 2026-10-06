import 'dart:math';
import 'package:flutter/material.dart';

class InflationCalculatorScreen extends StatefulWidget {
  const InflationCalculatorScreen({super.key});

  @override
  State<InflationCalculatorScreen> createState() => _InflationCalculatorScreenState();
}

class _InflationCalculatorScreenState extends State<InflationCalculatorScreen> {
  double _presentValue = 100000; // Current cost or amount
  double _inflationRate = 6.0;   // Annual inflation %
  double _years = 10;            // Time horizon

  Map<String, double> _calculateInflation() {
    int t = _years.toInt();
    double r = _inflationRate / 100;

    // Future Cost Formula: FV = PV * (1 + r)^t
    double futureCost = _presentValue * pow(1 + r, t);
    double purchasingPowerLoss = futureCost - _presentValue;

    return {
      'futureCost': futureCost > 0 ? futureCost : _presentValue,
      'loss': purchasingPowerLoss > 0 ? purchasingPowerLoss : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateInflation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inflation Impact Calculator'),
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
                    const Text('Future Cost (Adjusted for Inflation)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${result['futureCost']!.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol('Present Value', '₹ ${_presentValue.toStringAsFixed(0)}', Colors.white70),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultCol('Value Drop / Cost Surge', '+₹ ${result['loss']!.toStringAsFixed(0)}', Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders
            _buildSlider(
              title: 'Present Amount / Expense',
              value: _presentValue,
              min: 10000,
              max: 2000000,
              divisions: 50,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _presentValue = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Expected Annual Inflation Rate',
              value: _inflationRate,
              min: 2.0,
              max: 15.0,
              divisions: 26,
              formatter: (v) => '${v.toStringAsFixed(1)} %',
              onChanged: (v) => setState(() => _inflationRate = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Time Horizon (Years)',
              value: _years,
              min: 1,
              max: 30,
              divisions: 29,
              formatter: (v) => '${v.toStringAsFixed(0)} Years',
              onChanged: (v) => setState(() => _years = v),
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
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
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