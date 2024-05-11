import 'package:flutter/material.dart';
import 'package:medcs_dashboard/models/accepted_orders.dart';
import 'package:medcs_dashboard/models/declined_orders.dart';
import 'package:medcs_dashboard/models/orders.dart';
import 'package:medcs_dashboard/models/product_model.dart';
import 'package:medcs_dashboard/providers/order_provider/orders_provider.dart';
import 'package:medcs_dashboard/providers/product_provider/product_provider.dart';
import 'package:medcs_dashboard/widgets/bar_chart.dart';
import 'package:medcs_dashboard/widgets/pie_chart.dart';
import 'package:medcs_dashboard/widgets/custom_info_widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    Stream<Orders> fetchOrdersForToday() async* {
      var acceptedOrders = await orderProvider.fetchAcceptedOrdersForToday();
      var declinedOrders = await orderProvider.fetchDeclinedOrdersForToday();

      yield Orders(
          acceptedOrders: acceptedOrders, declinedOrders: declinedOrders);
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder<List<ProductsModel>>(
        stream: Provider.of<ProductProvider>(context).fetchProductsAsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<ProductsModel>? products = snapshot.data;
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Sales for the week',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
                            ),
                          ),
                          const BarChartWidget(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Column(
                          children: [
                            Text(
                              'Most sold categories',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.02,
                              ),
                            ),
                            const PieChartWidget(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.1,
                    left: size.width * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomInfoWidget(
                              space: 145,
                              paddingtoRight: 8,
                              firstTitle: 'Medicine quantity',
                              numberTitleOne: products != null
                                  ? products
                                      .map((product) => product)
                                      .toSet()
                                      .length
                                      .toString()
                                  : '0',
                              title: 'Inventory',
                              numberTitleTwo: products != null
                                  ? products
                                      .map((product) => product.productCategory)
                                      .toSet()
                                      .length
                                      .toString()
                                  : '0',
                              secondryTitleTwo: 'Medicine Categories',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.16,
                      ),
                      StreamBuilder<Orders>(
                        stream: fetchOrdersForToday(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'An error has occurred: ${snapshot.error}'),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            Orders orders = snapshot.data!;
                            List<AcceptedOrders> acceptedOrders =
                                orders.acceptedOrders;
                            List<DeclinedOrders> declinedOrders =
                                orders.declinedOrders;

                            String acceptedOrdersCount = acceptedOrders.isEmpty
                                ? '0'
                                : acceptedOrders.length.toString();
                            String declinedOrdersCount = declinedOrders.isEmpty
                                ? '0'
                                : declinedOrders.length.toString();

                            return Expanded(
                              child: Column(
                                children: [
                                  CustomInfoWidget(
                                    space: 120,
                                    paddingtoRight: 50,
                                    firstTitle: 'Order accepted',
                                    numberTitleOne: acceptedOrdersCount,
                                    title: 'Orders',
                                    numberTitleTwo: declinedOrdersCount,
                                    secondryTitleTwo: 'Orders declined',
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
