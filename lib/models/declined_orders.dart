import 'package:cloud_firestore/cloud_firestore.dart';

class DeclinedOrders {
  final String userEmail;
  final Timestamp timestamp;

  DeclinedOrders({required this.userEmail, required this.timestamp});

  factory DeclinedOrders.fromDocumentSnapShot(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return DeclinedOrders(
        userEmail: data['userEmail'], timestamp: data['timestamp']);
  }
}
