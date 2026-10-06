//Fixed deposit and recurring deposit
import 'dart:math';
import 'package:flutter/material.dart';

class FdRdCalculatorScreen extends StatefulWidget {
  const FdRdCalculatorScreen({super.key});

  @override
  State<FdRdCalculatorScreen> createState() => _FdRdCalculatorScreenState();
}

class _FdRdCalculatorScreenState extends State<FdRdCalculatorScreen> {
  bool _isFd = true; // True for FD, False for RD
  double _principalOrMonthly = 100000;
  double _rate = 6.5; // Annual interest rate
  double _years = 5; // Tenure in years

  Map<String, double> _calculateReturns() {
    double totalInvestment = 0;
    double maturityValue = 0;

    if (_isFd) {
      // Compound Interest for FD: A = P * (1 + r/n)^(nt) assuming quarterly compounding (n=4)
      totalInvestment = _principalOrMonthly;
      double p = _principalOrMonthly;
      double r = _rate / 100;
      double t = _years;
      maturityValue = p * pow((1 + r / 4), 4 * t);
    } else {
      // RD Formula: A = P * [ (1+i)^n - 1 ] / [ 1 - (1+i)^(-1/3) ] approx or standard monthly compounding
      double p = _principalOrMonthly;
      double i = (_rate / 100) / 12;
      double n = _years * 12;
      totalInvestment = p * n;
      // Standard monthly RD formula
      maturityValue = p * ((pow(1 + i, n) - 1) / i) * (1 + i);
    }

    double interestEarned = maturityValue - totalInvestment;
    return {
      'invested': totalInvestment,
      'interest': interestEarned > 0 ? interestEarned : 0,
      'maturity': maturityValue > 0 ? maturityValue : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateReturns();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FD & RD Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between FD and RD
            ToggleButtons(
              isSelected: [_isFd, !_isFd],
              onPressed: (index) {
                setState(() {
                  _isFd = index == 0;
                  _principalOrMonthly = _isFd ? 100000 : 5000;
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.indigo,
              color: Colors.indigo,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 150),
              children: const [
                Text('Fixed Deposit (FD)', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Recurring Deposit (RD)', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Summary Card
            Card(
              elevation: 4,
              color: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(_isFd ? 'Maturity Amount' : 'Total Maturity Value', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${result['maturity']!.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultCol(_isFd ? 'Total Deposit' : 'Total Invested', '₹ ${result['invested']!.toStringAsFixed(0)}', Colors.white70),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildResultCol('Interest Earned', '₹ ${result['interest']!.toStringAsFixed(0)}', Colors.greenAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sliders
            _buildSlider(
              title: _isFd ? 'Total Deposit Amount' : 'Monthly Deposit Amount',
              value: _principalOrMonthly,
              min: _isFd ? 10000 : 500,
              max: _isFd ? 5000000 : 100000,
              divisions: 100,
              formatter: (v) => '₹ ${v.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _principalOrMonthly = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Interest Rate (% p.a.)',
              value: _rate,
              min: 3.0,
              max: 12.0,
              divisions: 90,
              formatter: (v) => '${v.toStringAsValuedOrDecimal(1)} %',
              onChanged: (v) => setState(() => _rate = v),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: 'Tenure (Years)',
              value: _years,
              min: 1,
              max: 10,
              divisions: 9,
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

extension on double {
  String toStringAsValuedOrDecimal(int fractionDigits) => toStringAsFixed(fractionDigits);
}