import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationList = NotificationService().notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Mark all as read / Clear button
          if (notificationList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: () {
                setState(() {
                  NotificationService().clearNotifications();
                });
              },
            ),
        ],
      ),
      body: notificationList.isEmpty
          ? const Center(
        child: Text(
          'No new notifications.\nYou are all caught up!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      )
          : ListView.builder(
        itemCount: notificationList.length,
        itemBuilder: (context, index) {
          final item = notificationList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: item['color'].withOpacity(0.15),
                child: Icon(item['icon'], color: item['color']),
              ),
              title: Text(
                item['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['message'], style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 6),
                    Text(item['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}