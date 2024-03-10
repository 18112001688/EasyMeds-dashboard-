import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medcs_dashboard/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductsModel> _products = [];

  List<ProductsModel> get getProducts {
    return _products;
  }

  int get numberOfCategories {
    Set<String> categories =
        _products.map((product) => product.productCategory).toSet();

    // Return the length of the set
    return categories.length;
  }

  ProductsModel? findByProductID(String productID) {
    // Check if there are any products with the specified ID
    if (_products.where((element) => element.productID == productID).isEmpty) {
      return null;
    }
    // Return the first product found with the specified ID
    return _products.firstWhere((element) => element.productID == productID);
  }

  List<ProductsModel> findByCategory({required String categoryName}) {
    List<ProductsModel> ctgList = _products
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();

    return ctgList;
  }

// Function to filter products based on a search text.
  List<ProductsModel> searchQuery(
      {required String searchText, required List<ProductsModel> passedList}) {
    // Using the `where` method to filter the list of products (_products).
    // The condition checks if the lowercase title of each product contains the lowercase searchText.
    List<ProductsModel> searchList = passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    // Returning the filtered list of products.
    return searchList;
  }

  final productDB = FirebaseFirestore.instance.collection('products');
  Future<List<ProductsModel>> fetchProducts() async {
    try {
      await productDB.get().then((productSnapShot) {
        for (var element in productSnapShot.docs) {
          _products.insert(0, ProductsModel.fromDocumentSnapshot(element));
        }
      });
      notifyListeners();
      return _products;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct({required String productId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  final prescriptionsDB =
      FirebaseFirestore.instance.collection('prescriptionsImages');
  Stream<List<ProductsModel>> fetchProductsAsStream() {
    // Create a StreamController
    final StreamController<List<ProductsModel>> controller = StreamController();

    // Fetch products asynchronously
    productDB.get().then((productSnapShot) {
      List<ProductsModel> products = [];
      for (var element in productSnapShot.docs) {
        products.insert(0, ProductsModel.fromDocumentSnapshot(element));
      }
      // Add the products to the stream
      controller.add(products);
    }).catchError((error) {
      // If an error occurs, add it to the stream's error
      controller.addError(error);
    });

    // Return the stream from the controller
    return controller.stream;
  }

  double minmuimNumberOfProduct = 25;
  double get getMinmuimProduct {
    return minmuimNumberOfProduct;
  }

  List<ProductsModel> getLowInventoryProducts() {
    List<ProductsModel> lowInventoryProducts = [];
    for (var product in _products) {
      int currentQuantity =
          product.inventoryQuantity; // Assuming quantity is nullable
      if (currentQuantity < minmuimNumberOfProduct) {
        lowInventoryProducts.add(product);
      }
    }
    return lowInventoryProducts;
  }
}
