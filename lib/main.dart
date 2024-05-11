import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medcs_dashboard/firebase_options.dart';
import 'package:medcs_dashboard/providers/order_provider/orders_provider.dart';
import 'package:medcs_dashboard/providers/product_provider/product_provider.dart';
import 'package:medcs_dashboard/views/dashboard_view.dart';
import 'package:medcs_dashboard/views/login_view.dart';
import 'package:provider/provider.dart'; // Add this import if you're using Provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => OrderProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}
