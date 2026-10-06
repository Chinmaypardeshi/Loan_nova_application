import 'dart:math';
import 'package:flutter/material.dart';

class SipCalculatorScreen extends StatefulWidget {
  const SipCalculatorScreen({super.key});

  @override
  State<SipCalculatorScreen> createState() => _SipCalculatorScreenState();
}

class _SipCalculatorScreenState extends State<SipCalculatorScreen> {
  double _monthlyInvestment = 5000;
  double _expectedReturnRate = 12.0; // Annual %
  double _timePeriodYears = 10; // Years

  Map<String, double> _calculateSip() {
    final double p = _monthlyInvestment;
    final double i = (_expectedReturnRate / 100) / 12; // Monthly rate
    final double n = _timePeriodYears * 12; // Total months

    // FV = P * ({[1 + i]^n - 1} / i) * (1 + i)
    final double totalValue = p * ((pow(1 + i, n) - 1) / i) * (1 + i);
    final double investedAmount = p * n;
    final double estimatedReturns = totalValue - investedAmount;

    return {
      'invested': investedAmount,
      'returns': estimatedReturns > 0 ? estimatedReturns : 0,
      'total': totalValue > 0 ? totalValue : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculateSip();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP & Wealth Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results Summary Card
            Card(
              elevation: 4,
              color: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Projected Total Value', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${results['total']!.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultColumn('Invested Amount', '₹ ${results['invested']!.toStringAsFixed(0)}', Colors.white70),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultColumn('Est. Returns', '₹ ${results['returns']!.toStringAsFixed(0)}', Colors.greenAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders for Inputs
            _buildSliderSection(
              title: 'Monthly Investment',
              value: _monthlyInvestment,
              min: 500,
              max: 100000,
              divisions: 199,
              formatValue: (val) => '₹ ${val.toStringAsFixed(0)}',
              onChanged: (val) => setState(() => _monthlyInvestment = val),
            ),
            const SizedBox(height: 16),
            _buildSliderSection(
              title: 'Expected Annual Return Rate',
              value: _expectedReturnRate,
              min: 1.0,
              max: 30.0,
              divisions: 58,
              formatValue: (val) => '${val.toStringAsFixed(1)} %',
              onChanged: (val) => setState(() => _expectedReturnRate = val),
            ),
            const SizedBox(height: 16),
            _buildSliderSection(
              title: 'Time Period',
              value: _timePeriodYears,
              min: 1,
              max: 30,
              divisions: 29,
              formatValue: (val) => '${val.toStringAsFixed(0)} Years',
              onChanged: (val) => setState(() => _timePeriodYears = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) formatValue,
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
                Text(formatValue(value), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.indigo)),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: Colors.indigo,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}