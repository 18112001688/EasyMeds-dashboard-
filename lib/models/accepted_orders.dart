import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedOrders {
  final String userEmail;
  final Timestamp timestamp;

  AcceptedOrders({required this.userEmail, required this.timestamp});

  factory AcceptedOrders.fromDocumentSnapShot(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AcceptedOrders(
        userEmail: data['userEmail'], timestamp: data['timestamp']);
  }
}
