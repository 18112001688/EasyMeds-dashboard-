import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsModel with ChangeNotifier {
  final String productTitle;
  final double productPrice;
  final String productDescription;
  final String productVolume;
  final String productImage;
  final String productID;
  final String productCategory;
  final int inventoryQuantity; // Add this line

  // final Timestamp craetedAt;

  ProductsModel(
      {required this.productTitle,
      required this.productPrice,
      required this.productDescription,
      required this.productVolume,
      required this.productImage,
      required this.productID,
      required this.productCategory,
      required this.inventoryQuantity

      // required this.craetedAt,
      });

  factory ProductsModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return ProductsModel(
      productTitle: data['productTitle'],
      productPrice: double.parse(data['productPrice']),
      productDescription: data['productDescription'],
      productVolume: data['productQuantity'],
      productImage: data['productImage'],
      productID: data['productID'],
      productCategory: data['productCategory'],
      inventoryQuantity:
          (data['inventoryQuantity'] as num).toInt(), // And this line
    );
  }
}
