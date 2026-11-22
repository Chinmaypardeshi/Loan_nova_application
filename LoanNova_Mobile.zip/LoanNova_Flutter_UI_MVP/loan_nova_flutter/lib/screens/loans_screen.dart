import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/loan.dart';
import '../widgets/loan_card.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  bool isLoading = true;
  String? errorMessage;

  List<Loan> loans = [];

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

      // Temporary userId.
      // Step 37 me dynamic userId save karne ke baad
      // isko saved userId se replace karenge.
      final userId = await ApiService.getUserId();

if (userId == null) {
  throw Exception('User session not found. Please login again');
}
      final data = await ApiService.getAllLoans();

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
        title: const Text(
          'Loans',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
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
              Icons.account_balance_outlined,
              size: 60,
              color: Color(0xFF8A90A0),
            ),

            SizedBox(height: 16),

            Center(
              child: Text(
                'No loans found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
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
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 20,
        ),
        children: loans
            .map(
              (loan) => LoanCard(loan: loan),
            )
            .toList(),
      ),
    );
  }
}