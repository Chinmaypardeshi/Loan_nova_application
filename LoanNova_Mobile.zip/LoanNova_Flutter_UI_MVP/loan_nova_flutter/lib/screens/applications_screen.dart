import 'package:flutter/material.dart';

import '../api/api_service.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() =>
      _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  bool isLoading = true;
  String? errorMessage;

  List<dynamic> applications = [];

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

      Future<void> loadApplications() async {
  try {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final token = await ApiService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Please login again');
    }

    // Login ke time save hua actual userId
    final userId = await ApiService.getUserId();

    if (userId == null) {
      throw Exception(
        'User session not found. Please login again',
      );
    }

    final data =
        await ApiService.getUserApplications(userId);

    if (!mounted) return;

    setState(() {
      applications = data;
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
          'My Applications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
                onPressed: loadApplications,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (applications.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadApplications,
        child: ListView(
          children: const [
            SizedBox(height: 180),
            Icon(
              Icons.description_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No applications found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadApplications,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final application = applications[index]
              as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _applicationCard(
              context,
              application,
            ),
          );
        },
      ),
    );
  }

  Widget _applicationCard(
    BuildContext context,
    Map<String, dynamic> application,
  ) {
    final loan = application['loan']
        as Map<String, dynamic>?;

    final loanType =
        (loan?['loanType'] ?? 'PERSONAL')
            .toString()
            .toUpperCase();

    final title = _loanTitle(loanType);

    final amount =
        (application['requestedAmount'] as num?)
                ?.toDouble() ??
            0;

    final status =
        (application['status'] ?? 'PENDING')
            .toString()
            .toUpperCase();

    final icon = _loanIcon(loanType);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.indigo,
              size: 27,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          _statusBadge(status),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'APPROVED':
        color = Colors.green;
        break;

      case 'REJECTED':
        color = Colors.red;
        break;

      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _loanTitle(String type) {
    switch (type) {
      case 'HOME':
        return 'Home Loan';
      case 'BUSINESS':
        return 'Business Loan';
      case 'VEHICLE':
      case 'CAR':
        return 'Vehicle Loan';
      default:
        return 'Personal Loan';
    }
  }

  IconData _loanIcon(String type) {
    switch (type) {
      case 'HOME':
        return Icons.home_rounded;
      case 'BUSINESS':
        return Icons.business_center_rounded;
      case 'VEHICLE':
      case 'CAR':
        return Icons.directions_car_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }
}