import 'package:flutter/material.dart';

import '../api/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  bool isLoading = true;
  String? errorMessage;

  List<dynamic> notifications = [];

  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
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

      final data =
          await ApiService.getUserNotifications(userId);

      final count =
          await ApiService.getUnreadNotificationCount(userId);

      if (!mounted) return;

      setState(() {
        notifications = data;
        unreadCount = count;
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

  Future<void> markAsRead(
    Map<String, dynamic> notification,
  ) async {
    final id = (notification['id'] as num?)?.toInt();

    if (id == null) {
      return;
    }

    try {
      await ApiService.markNotificationAsRead(id);

      await loadNotifications();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update notification: $e'),
        ),
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = await ApiService.getUserId();

      if (userId == null) {
        throw Exception(
          'User session not found. Please login again',
        );
      }

      await ApiService.markAllNotificationsAsRead(userId);

      await loadNotifications();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'All notifications marked as read',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to mark notifications as read: $e',
          ),
        ),
      );
    }
  }

  bool _isRead(Map<String, dynamic> notification) {
    final value = notification['read'] ??
        notification['isRead'] ??
        notification['readStatus'];

    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toUpperCase() == 'READ' ||
          value.toLowerCase() == 'true';
    }

    return false;
  }

  IconData _notificationIcon(
    String type,
  ) {
    switch (type.toUpperCase()) {
      case 'LOAN':
        return Icons.account_balance_outlined;

      case 'APPLICATION':
        return Icons.description_outlined;

      case 'EMI':
      case 'REPAYMENT':
        return Icons.payments_outlined;

      case 'SUCCESS':
        return Icons.check_circle_outline;

      case 'WARNING':
        return Icons.warning_amber_outlined;

      case 'ERROR':
        return Icons.error_outline;

      default:
        return Icons.notifications_active_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3157E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text('Read all'),
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
                onPressed: loadNotifications,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadNotifications,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Icon(
              Icons.notifications_none_outlined,
              size: 65,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'You are all caught up.',
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
      onRefresh: loadNotifications,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (_, index) {
          final notification =
              Map<String, dynamic>.from(
            notifications[index],
          );

          final title =
              (notification['title'] ?? 'Notification')
                  .toString();

          final message =
              (notification['message'] ?? '')
                  .toString();

          final type =
              (notification['type'] ?? 'GENERAL')
                  .toString();

          final isRead =
              _isRead(notification);

          return Card(
            elevation: 0,
            color: isRead
                ? Colors.white
                : const Color(0xFFF4F7FF),
            child: ListTile(
              onTap: isRead
                  ? null
                  : () => markAsRead(notification),
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor:
                    const Color(0xFFEAF0FF),
                child: Icon(
                  _notificationIcon(type),
                  color: const Color(0xFF3157E8),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (!isRead)
                    Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3157E8),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding:
                    const EdgeInsets.only(top: 5),
                child: Text(message),
              ),
            ),
          );
        },
      ),
    );
  }
}