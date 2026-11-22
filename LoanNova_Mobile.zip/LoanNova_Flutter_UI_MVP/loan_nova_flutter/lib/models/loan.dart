import 'package:flutter/material.dart';

class Loan {
  final int id;
  final double amount;
  final double emi;
  final double interestRate;
  final String loanType;
  final String status;
  final int tenure;

  final IconData icon;
  final Color color;

  const Loan({
    required this.id,
    required this.amount,
    required this.emi,
    required this.interestRate,
    required this.loanType,
    required this.status,
    required this.tenure,
    required this.icon,
    required this.color,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    final String loanType =
        (json['loanType'] ?? 'PERSONAL').toString().toUpperCase();

    IconData icon = Icons.person_outline;
    Color color = const Color(0xFF3157E8);

    switch (loanType) {
      case 'HOME':
        icon = Icons.home_outlined;
        color = const Color(0xFF4F8CFC);
        break;

      case 'BUSINESS':
        icon = Icons.business_center_outlined;
        color = const Color(0xFF0F9D78);
        break;

      case 'VEHICLE':
      case 'CAR':
        icon = Icons.directions_car_outlined;
        color = const Color(0xFFFF9B5B);
        break;

      case 'PERSONAL':
      default:
        icon = Icons.person_outline;
        color = const Color(0xFF3157E8);
        break;
    }

    return Loan(
      id: (json['id'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      emi: (json['emi'] as num?)?.toDouble() ?? 0,
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0,
      loanType: loanType,
      status: (json['status'] ?? 'PENDING')
          .toString()
          .toUpperCase(),
      tenure: (json['tenure'] as num?)?.toInt() ?? 0,
      icon: icon,
      color: color,
    );
  }

  String get title {
    switch (loanType) {
      case 'HOME':
        return 'Home Loan';
      case 'BUSINESS':
        return 'Business Loan';
      case 'VEHICLE':
      case 'CAR':
        return 'Vehicle Loan';
      case 'PERSONAL':
      default:
        return 'Personal Loan';
    }
  }

  String get subtitle {
    switch (loanType) {
      case 'HOME':
        return 'Finance your dream home';
      case 'BUSINESS':
        return 'Grow your business';
      case 'VEHICLE':
      case 'CAR':
        return 'Finance your new vehicle';
      case 'PERSONAL':
      default:
        return 'Quick personal financing';
    }
  }

  String get rate {
    return '${interestRate.toStringAsFixed(2)}%';
  }

  String get tenureText {
    return '$tenure months';
  }

  String get fee {
    return '-';
  }

  String get emiText {
    return '₹${emi.toStringAsFixed(2)}/mo';
  }
}


// Temporary compatibility list for existing UI screens.
// Later we will replace this with real API data everywhere.
final List<Loan> loans = [
  Loan(
    id: 1,
    amount: 100000,
    emi: 4614.49,
    interestRate: 10.0,
    loanType: 'PERSONAL',
    status: 'REJECTED',
    tenure: 24,
    icon: Icons.person_outline,
    color: const Color(0xFF3157E8),
  ),

  Loan(
    id: 2,
    amount: 500000,
    emi: 10746.95,
    interestRate: 10.5,
    loanType: 'PERSONAL',
    status: 'PENDING',
    tenure: 60,
    icon: Icons.account_balance_wallet_outlined,
    color: const Color(0xFF6D5DF5),
  ),

  Loan(
    id: 3,
    amount: 100000,
    emi: 4637.60,
    interestRate: 10.5,
    loanType: 'PERSONAL',
    status: 'PENDING',
    tenure: 24,
    icon: Icons.payments_outlined,
    color: const Color(0xFF00A86B),
  ),
];