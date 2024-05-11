import 'package:cloud_firestore/cloud_firestore.dart';

class CheckOutOrder {
  final String deliveryAddress;
  final String getTotal;
  final String totalItems;
  final String userEmail;
  final String userID;
  final String userImage;
  final String userName;
  final String userPhone;
  final List<Product> items; // List of products

  CheckOutOrder({
    required this.deliveryAddress,
    required this.getTotal,
    required this.totalItems,
    required this.userEmail,
    required this.userID,
    required this.userImage,
    required this.userName,
    required this.userPhone,
    required this.items, // Include items in the constructor
  });

  factory CheckOutOrder.fromJson(DocumentSnapshot json) {
    // Parse items array
    final List<dynamic> jsonItems = json['items'];
    final List<Product> products = jsonItems
        .map((item) => Product.fromJson(item))
        .toList(); // Convert each item to Product object

    return CheckOutOrder(
      deliveryAddress: json['deliveryAddress'] ?? '',
      getTotal: json['getTotal'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      userEmail: json['userEmail'] ?? '',
      userID: json['userID'] ?? '',
      userImage: json['userImage'] ?? '',
      userName: json['userName'] ?? '',
      userPhone: json['userPhone'] ?? '',
      items: products, // Assign parsed products to items field
    );
  }
}

class Product {
  final String productImage;
  final String productName;
  final double quantity;
  // Add other fields as needed

  Product({
    required this.productImage,
    required this.productName,
    required this.quantity,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productImage: json['productImage'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0.0,
    );
  }
}
