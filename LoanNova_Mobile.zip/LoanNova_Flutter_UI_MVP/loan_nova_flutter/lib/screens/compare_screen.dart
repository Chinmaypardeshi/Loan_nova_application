import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/loan.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  bool isLoading = true;
  String? errorMessage;

  List<Loan> loans = [];
  final Set<int> selected = {};

  @override
  void initState() {
    super.initState();
    loadLoans();
  }

  Future<void> loadLoans() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final token = await ApiService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Please login again');
      }

      final userId = await ApiService.getUserId();

      if (userId == null) {
        throw Exception(
          'User session not found. Please login again',
        );
      }

      final data = await ApiService.getUserLoans(userId);

      final loadedLoans = data
          .map(
            (item) => Loan.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        loans = loadedLoans;
        selected.clear();

        // Automatically select first 2 loans if available
        if (loans.length >= 2) {
          selected.add(0);
          selected.add(1);
        } else if (loans.length == 1) {
          selected.add(0);
        }

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Loans'),
        actions: [
          TextButton(
            onPressed: selected.isEmpty
                ? null
                : () {
                    setState(() {
                      selected.clear();
                    });
                  },
            child: const Text('Clear'),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: loadLoans,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (loans.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadLoans,
        child: ListView(
          children: const [
            SizedBox(height: 180),
            Icon(
              Icons.compare_arrows_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No loans available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Your loans will appear here for comparison.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadLoans,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Select up to 3 loans',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${selected.length}/3 loans selected',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          ...List.generate(
            loans.length,
            (index) {
              final loan = loans[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  value: selected.contains(index),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        if (selected.length < 3) {
                          selected.add(index);
                        }
                      } else {
                        selected.remove(index);
                      }
                    });
                  },
                  title: Text(
                    loan.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    '${loan.rate} • '
                    '${loan.tenureText} • '
                    '${loan.emiText}',
                  ),
                  secondary: Icon(
                    loan.icon,
                    color: loan.color,
                  ),
                  controlAffinity:
                      ListTileControlAffinity.trailing,
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          if (selected.isNotEmpty)
            const Text(
              'Comparison',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

          const SizedBox(height: 8),

          ...selected.map(
            (index) {
              final loan = loans[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        loan.color.withOpacity(0.1),
                    child: Icon(
                      loan.icon,
                      color: loan.color,
                    ),
                  ),
                  title: Text(
                    loan.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    '${loan.tenureText} • ${loan.emiText}',
                  ),
                  trailing: Text(
                    loan.rate,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3157E8),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}