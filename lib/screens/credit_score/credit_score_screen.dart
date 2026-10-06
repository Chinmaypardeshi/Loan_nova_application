import 'package:flutter/material.dart';

class CreditScoreScreen extends StatelessWidget {
  const CreditScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock credit score for MVP (e.g., 765 out of 900)
    const int creditScore = 765;
    const String scoreCategory = 'Excellent';
    const Color scoreColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Health Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Score Gauge Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Your CIBIL Credit Score',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        height: 140,
                        width: 140,
                        child: CircularProgressIndicator(
                          value: 0.85, // 765/900 roughly
                          strokeWidth: 12,
                          backgroundColor: Colors.black12,
                          valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '$creditScore',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            scoreCategory,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: scoreColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Last updated: Today | Refreshed monthly',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Credit Health Factors
          const Text(
            'Key Credit Factors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildFactorTile(
            icon: Icons.check_circle,
            color: Colors.green,
            title: 'On-Time Payments',
            subtitle: '100% payment history recorded across your accounts.',
          ),
          _buildFactorTile(
            icon: Icons.pie_chart,
            color: Colors.orange,
            title: 'Credit Utilization',
            subtitle: '22% utilization rate (Recommended: Under 30%).',
          ),
          _buildFactorTile(
            icon: Icons.access_time,
            color: Colors.blue,
            title: 'Credit Age',
            subtitle: 'Average account age is 4 years and 2 months.',
          ),

          const SizedBox(height: 24),

          // Tip Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade100),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.indigo, size: 32),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Tip: Keeping your credit utilization below 30% can boost your score by up to 25 points over the next cycle.',
                    style: TextStyle(fontSize: 13, color: Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorTile({required IconData icon, required Color color, required String title, required String subtitle}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}