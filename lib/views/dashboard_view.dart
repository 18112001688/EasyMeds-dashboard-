import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';
import 'package:medcs_dashboard/models/product_model.dart';
import 'package:medcs_dashboard/providers/product_provider/product_provider.dart';
import 'package:medcs_dashboard/views/accepte_declined_orders_view.dart';
import 'package:medcs_dashboard/views/add_product_view.dart';
import 'package:medcs_dashboard/views/home_view.dart';
import 'package:medcs_dashboard/views/prescriptions_view.dart';
import 'package:medcs_dashboard/views/report_view.dart';
import 'package:medcs_dashboard/views/view_products_view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isRailExpanded = false;
  late Timer _timer;
  final _players = AudioPlayer();

  final List<Widget> _widgetOptions = const [
    HomeView(),
    ReportView(),
    PrescriptionsView(),
    AddProductView(),
    ViewProductsView(),
    AcceptedOrDeclinedOrdersView()
  ];
  void fetchFCT() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      await productProvider.fetchProducts(); // Wait for products to be fetched
      _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
        checkLowInventory();
      });
    } catch (e) {
      rethrow;
    }
  }

  void checkLowInventory() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    List<ProductsModel> lowInventoryProducts =
        productProvider.getLowInventoryProducts();
    if (lowInventoryProducts.isNotEmpty) {
      _players.play(UrlSource(
          'assets/sounds/system_error.mp3')); // Adjust the path to your sound file

      // Show a dialog with a warning message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Low Inventory Warning',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'there are Products that has quantity less than 25',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Call methods when the widget is initialized
    fetchFCT();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            leading: _isRailExpanded
                ? const Padding(
                    padding: EdgeInsets.only(right: 0, top: 100),
                    child: Column(
                      children: [],
                    ),
                  )
                : const SizedBox.shrink(),

            extended: _isRailExpanded,
            backgroundColor: const Color(0xff283342),
            unselectedIconTheme:
                const IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white),
            selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text(
                  "Dashboard",
                  style: StylesLight.bodyLarge17SemiBold,
                ),
              ),
              const NavigationRailDestination(
                  icon: Icon(Icons.inventory),
                  label: Text(
                    "Inventory",
                    style: StylesLight.bodyLarge17SemiBold,
                  )),
              const NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text(
                  "Prescriptions",
                  style: StylesLight.bodyLarge17SemiBold,
                ),
              ),
              const NavigationRailDestination(
                  padding: EdgeInsets.only(top: 50),
                  icon: Icon(Icons.add),
                  label: Text(
                    "Add Products",
                  )),
              NavigationRailDestination(
                  icon: badges.Badge(
                      badgeStyle:
                          const badges.BadgeStyle(badgeColor: Colors.pink),
                      badgeContent: Text(
                        productProvider.getProducts.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: const Icon(Icons.view_compact)),
                  label: const Text("View Products")),
              const NavigationRailDestination(
                  padding: EdgeInsets.only(top: 50),
                  icon: Icon(Icons.check),
                  label: Text("Accepted Orders")),
            ],

            selectedIndex:
                _selectedIndex, // Set selectedIndex to _selectedIndex
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 600),
            child: IconButton(
              icon: _isRailExpanded
                  ? const Icon(Icons.menu_open)
                  : const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isRailExpanded = !_isRailExpanded;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: IndexedStack(
                index: _selectedIndex,
                children: _widgetOptions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
