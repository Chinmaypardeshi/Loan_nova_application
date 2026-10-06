import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loannova_mobile_app/screens/product_catalog_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zexqcbyyosuzmhodyaxk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpleHFjYnl5b3N1em1ob2R5YXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTExNjc0MjAsImV4cCI6MjEwNjc0MzQyMH0.SpA4odV6Wd8-BzzNLX-f7xVe9ZAfTK2t2nl-4tGcc1I',
  );

  runApp(const LoanNovaApp());
}

class LoanNovaApp extends StatelessWidget {
  const LoanNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoanNova MVP',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const ProductCatalogScreen(),
    );
  }
}