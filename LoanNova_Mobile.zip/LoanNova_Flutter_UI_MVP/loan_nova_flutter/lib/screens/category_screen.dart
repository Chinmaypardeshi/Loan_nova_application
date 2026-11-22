import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/loan.dart';
import '../widgets/loan_card.dart';

class CategoryScreen extends StatefulWidget {
  final String title;

  const CategoryScreen({
    super.key,
    required this.title,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
        title: Text(
          widget.title,
          style: const TextStyle(
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

    return RefreshIndicator(
      onRefresh: loadLoans,
      child: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              18,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              'Explore ${widget.title} options and compare offers.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (loans.isEmpty)
            const Padding(
              padding: EdgeInsets.only(
                top: 80,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No loans found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your available loan information will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ...loans.map(
              (loan) => LoanCard(loan: loan),
            ),
        ],
      ),
    );
  }
}


//MuGnDwOu6EMOA71u