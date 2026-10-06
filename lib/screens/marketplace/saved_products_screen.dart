import 'package:flutter/material.dart';

class SavedProductsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedProducts;
  final Function(Map<String, dynamic>) onRemove;

  const SavedProductsScreen({
    super.key,
    required this.savedProducts,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Loan Products'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: savedProducts.isEmpty
          ? const Center(
        child: Text(
          'No saved products yet.\nTap the heart icon on any card to save it here!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: savedProducts.length,
        itemBuilder: (context, index) {
          final product = savedProducts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                product['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Provider: ${product['provider_name']}\nInterest Rate: ${product['interest_rate']}%',
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  onRemove(product);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}