import 'package:flutter/material.dart';

import '../api/api_service.dart';

class RepaymentsScreen extends StatefulWidget {
  final int loanId;

  const RepaymentsScreen({
    super.key,
    required this.loanId,
  });

  @override
  State<RepaymentsScreen> createState() =>
      _RepaymentsScreenState();
}

class _RepaymentsScreenState
    extends State<RepaymentsScreen> {
  bool isLoading = true;
  bool isGenerating = false;

  String? errorMessage;

  List<dynamic> repayments = [];
  Map<String, dynamic>? summary;

  @override
  void initState() {
    super.initState();
    loadRepayments();
  }

  // =========================
  // LOAD REPAYMENTS
  // =========================
  Future<void> loadRepayments() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final repaymentData =
          await ApiService.getLoanRepayments(
        widget.loanId,
      );

      // If schedule does not exist,
      // generate it automatically.
      if (repaymentData.isEmpty) {
        await generateSchedule();

        // Fetch generated schedule again
        final newRepaymentData =
            await ApiService.getLoanRepayments(
          widget.loanId,
        );

        final summaryData =
            await ApiService.getRepaymentSummary(
          widget.loanId,
        );

        if (!mounted) return;

        setState(() {
          repayments = newRepaymentData;
          summary = summaryData;
          isLoading = false;
        });

        return;
      }

      final summaryData =
          await ApiService.getRepaymentSummary(
        widget.loanId,
      );

      if (!mounted) return;

      setState(() {
        repayments = repaymentData;
        summary = summaryData;
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

  // =========================
  // GENERATE SCHEDULE
  // =========================
  Future<void> generateSchedule() async {
    try {
      setState(() {
        isGenerating = true;
      });

      await ApiService.generateRepaymentSchedule(
        widget.loanId,
      );

      if (!mounted) return;

      setState(() {
        isGenerating = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isGenerating = false;
        errorMessage = e.toString();
      });
    }
  }

  // =========================
  // PAY EMI
  // =========================
  Future<void> payEMI(
    Map<String, dynamic> repayment,
  ) async {
    final repaymentId =
        (repayment['id'] as num).toInt();

    final status =
        (repayment['status'] ?? 'PENDING')
            .toString()
            .toUpperCase();

    if (status == 'PAID') {
      return;
    }

    final reference =
        'LN-${DateTime.now().millisecondsSinceEpoch}';

    try {
      setState(() {
        isLoading = true;
      });

      await ApiService.payRepayment(
        repaymentId,
        reference,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'EMI payment successful',
          ),
        ),
      );

      await loadRepayments();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment failed: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMI Payments',
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
                onPressed: loadRepayments,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (repayments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 60,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
              const Text(
                'No EMI schedule found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed:
                    isGenerating
                        ? null
                        : loadRepayments,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: Text(
                  isGenerating
                      ? 'Generating...'
                      : 'Generate Schedule',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadRepayments,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _summaryCard(),

          const SizedBox(height: 24),

          const Text(
            'Payment Schedule',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          ...repayments.map(
            (repayment) =>
                _repaymentCard(
              Map<String, dynamic>.from(
                repayment,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    final total =
        (summary?['totalAmount'] as num?)
                ?.toDouble() ??
            0;

    final paid =
        (summary?['paidAmount'] as num?)
                ?.toDouble() ??
            0;

    final remaining =
        (summary?['remainingAmount'] as num?)
                ?.toDouble() ??
            0;

    final paidCount =
        summary?['paidCount'] ?? 0;

    final pendingCount =
        summary?['pendingCount'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3157E8),
            Color(0xFF6D5DF5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'EMI Summary',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '₹${remaining.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Text(
            'Remaining Amount',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _summaryItem(
                'Total',
                '₹${total.toStringAsFixed(0)}',
              ),
              _summaryItem(
                'Paid',
                '₹${paid.toStringAsFixed(0)}',
              ),
              _summaryItem(
                'Pending',
                '$pendingCount',
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Paid installments: $paidCount',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _repaymentCard(
    Map<String, dynamic> repayment,
  ) {
    final installment =
        repayment['installmentNumber'] ?? '-';

    final amount =
        (repayment['amount'] as num?)
                ?.toDouble() ??
            0;

    final dueDate =
        repayment['dueDate'] ?? '-';

    final status =
        (repayment['status'] ?? 'PENDING')
            .toString()
            .toUpperCase();

    final isPaid = status == 'PAID';

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8EAF1),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: isPaid
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              isPaid
                  ? Icons.check_circle_outline
                  : Icons.schedule,
              color: isPaid
                  ? Colors.green
                  : Colors.orange,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Installment #$installment',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Due: $dueDate',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '₹${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // PAY BUTTON
          if (!isPaid)
            FilledButton(
              onPressed: () {
                payEMI(repayment);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Pay',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            )
          else
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color:
                    Colors.green.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: const Text(
                'PAID',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}