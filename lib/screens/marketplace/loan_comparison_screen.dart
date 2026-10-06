import 'package:flutter/material.dart';

class LoanComparisonScreen extends StatelessWidget {
  final List<Map<String, dynamic>> comparedProducts;
  final Function(Map<String, dynamic>) onRemove;

  const LoanComparisonScreen({
    super.key,
    required this.comparedProducts,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Loan Products'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: comparedProducts.isEmpty
          ? const Center(
        child: Text(
          'No products selected for comparison.\nSelect products from the marketplace to compare them here!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: comparedProducts.map((product) {
            return Container(
              width: 280,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => onRemove(product),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildFeatureRow('Provider', product['provider_name'] ?? 'N/A'),
                  _buildFeatureRow('Interest Rate', '${product['interest_rate']}% p.a.'),
                  _buildFeatureRow('Max Amount', '₹${product['max_amount'] ?? '50,00,000'}'),
                  _buildFeatureRow('Processing Fee', '1.0% - 2.0%'),
                  _buildFeatureRow('Tenure Range', '1 - 5 Years'),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected ${product['title']} for application!')),
                        );
                      },
                      child: const Text('Choose Product'),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}