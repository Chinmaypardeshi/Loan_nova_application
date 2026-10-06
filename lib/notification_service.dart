import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Welcome to LoanNova!',
      'message': 'Explore our live marketplace, compare loans, and check your credit health.',
      'time': 'Just now',
      'icon': Icons.celebration,
      'color': Colors.indigo,
    }
  ];

  void addNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    notifications.insert(0, {
      'title': title,
      'message': message,
      'time': 'Just now',
      'icon': icon,
      'color': color,
    });
  }

  // ---> ADD THIS METHOD HERE <---
  void clearNotifications() {
    notifications.clear();
  }
}