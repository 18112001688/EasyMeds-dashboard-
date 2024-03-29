import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';
import 'package:medcs_dashboard/models/product_model.dart';
import 'package:medcs_dashboard/providers/product_provider/product_provider.dart';
import 'package:medcs_dashboard/views/add_product_view.dart';
import 'package:provider/provider.dart';

class ViewProductsView extends StatelessWidget {
  const ViewProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('An error occurred! ${snapshot.error.toString()}'));
          } else {
            final products = snapshot.data!.docs
                .map((doc) => ProductsModel.fromDocumentSnapshot(doc))
                .toList();

            return products.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(width: 1, color: Colors.black),
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Title',
                          style: StylesDark.titleRegualar22,
                        )),
                        DataColumn(
                            label: Text(
                          'price',
                          style: StylesDark.titleRegualar22,
                        )),
                        DataColumn(
                            label: Text(
                          'Volume',
                          style: StylesDark.titleRegualar22,
                        )),
                        DataColumn(
                            label: Text(
                          'category',
                          style: StylesDark.titleRegualar22,
                        )),
                        DataColumn(
                            label: Text(
                          'Inventory quantity',
                          style: StylesDark.titleRegualar22,
                        )),

                        DataColumn(
                            label: Text(
                          'Edit product',
                          style: StylesDark.titleRegualar22,
                        )),

                        //
                        DataColumn(
                            label: Text(
                          'Delete product',
                          style: StylesDark.titleRegualar22,
                        )),
                      ],
                      rows: products.map((product) {
                        return DataRow(
                          cells: [
                            DataCell(Text(product.productTitle)),
                            DataCell(Text(product.productPrice.toString())),
                            DataCell(Text(product.productVolume)),
                            DataCell(Text(product.productCategory)),
                            DataCell(
                              Text(
                                product.inventoryQuantity.toString(),
                                style: TextStyle(
                                  color: product.inventoryQuantity <
                                          productProvider.getMinmuimProduct
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            DataCell(IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddProductView(
                                          productsModel: product),
                                    ),
                                  );
                                })),

                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  productProvider.deleteProduct(
                                      productId: product.productID);
                                },
                              ),
                            ),
                            // Add more cells for each field
                          ],
                        );
                      }).toList(),
                    ),
                  )
                : const Center(
                    child: Text(
                      'There is no products',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  );
          }
        },
      ),
    );
  }
}
