import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loannova_mobile_app/screens//providers/app_state.dart';

class ApplicationTrackingScreen extends StatefulWidget {
  const ApplicationTrackingScreen({super.key});

  @override
  State<ApplicationTrackingScreen> createState() => _ApplicationTrackingScreenState();
}

class _ApplicationTrackingScreenState extends State<ApplicationTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cloud data as soon as the tracking screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Application Tracking'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Cloud Data',
            onPressed: () {
              Provider.of<AppState>(context, listen: false).fetchApplications();
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final apps = appState.applications;

          if (apps.isEmpty) {
            return const Center(
              child: Text(
                'No cloud applications found.\nApply for a product from the marketplace!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Display Product Name prominently at the top
                          Expanded(
                            child: Text(
                              app.productName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                          ),
                          Text(app.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Category: ${app.category}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text('Ref ID: #${app.id}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cloud Status:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              app.status,
                              style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}