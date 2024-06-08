import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';
import 'package:medcs_dashboard/models/product_model.dart';
import 'package:medcs_dashboard/providers/product_provider/product_provider.dart';
import 'package:medcs_dashboard/views/add_product_view.dart';
import 'package:provider/provider.dart';

class ViewProductsView extends StatefulWidget {
  const ViewProductsView({Key? key}) : super(key: key);

  @override
  State<ViewProductsView> createState() => _ViewProductsViewState();
}

class _ViewProductsViewState extends State<ViewProductsView> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Products,",
                style: StylesLight.titleHeading34,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 800, // Adjust the width as needed
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for products...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'An error occurred! ${snapshot.error.toString()}'));
                  } else {
                    final products = snapshot.data!.docs
                        .map((doc) => ProductsModel.fromDocumentSnapshot(doc))
                        .where((product) => product.productTitle
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                    return products.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: TableBorder.all(
                                  width: 1, color: Colors.black),
                              columns: const [
                                DataColumn(
                                  label: Text('Title',
                                      style: StylesDark.bodyMeduim15),
                                ),
                                DataColumn(
                                  label: Text('Price',
                                      style: StylesDark.bodyMeduim15),
                                ),
                                DataColumn(
                                  label: Text('Volume',
                                      style: StylesDark.bodyMeduim15),
                                ),
                                DataColumn(
                                  label: Text('Category',
                                      style: StylesDark.bodyMeduim15),
                                ),
                                DataColumn(
                                  label: Text('Inventory Quantity',
                                      style: StylesDark.bodyMeduim15),
                                ),
                                DataColumn(
                                  label: Text('Edit Product',
                                      style: StylesDark.bodyMeduim15),
                                ),
                                DataColumn(
                                  label: Text('Delete Product',
                                      style: StylesDark.bodyMeduim15),
                                ),
                              ],
                              rows: products.map((product) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                      product.productTitle,
                                      style: StylesLight.bodyLarge17,
                                    )),
                                    DataCell(
                                        Text(product.productPrice.toString())),
                                    DataCell(Text(product.productVolume)),
                                    DataCell(Text(product.productCategory)),
                                    DataCell(
                                      Text(
                                        product.inventoryQuantity.toString(),
                                        style: TextStyle(
                                          color: product.inventoryQuantity <
                                                  productProvider
                                                      .getMinmuimProduct
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
                                            builder: (context) =>
                                                AddProductView(
                                                    productsModel: product),
                                          ),
                                        );
                                      },
                                    )),
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
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'There are no products',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
