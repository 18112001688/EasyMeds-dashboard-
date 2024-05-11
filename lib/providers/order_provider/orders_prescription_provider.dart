import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medcs_dashboard/models/accepted_orders.dart';
import 'package:medcs_dashboard/models/declined_orders.dart';
import 'package:medcs_dashboard/models/prescription_model.dart';

class OrderProvider with ChangeNotifier {
  int acceptedOrdersCount = 0;
  int declinedOrdersCount = 0;

  Future<void> acceptOrderForPrescription(
      String email, BuildContext context) async {
    try {
      // Query Firestore to find the document(s) with the matching email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('prescriptionsImages')
          .where('userEmail', isEqualTo: email)
          .get();

      // Iterate over the documents found and delete each one
      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }

      // Increment accepted orders count

      acceptedOrdersCount++;

      FirebaseFirestore.instance
          .collection('acceptedOrders')
          .add({'userEmail': email, 'timestamp': Timestamp.now()});
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> acceptedOrdersForCheckOut(
      String email, BuildContext context) async {
    try {
      // Query Firestore to find the document(s) with the matching email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userCheckoutOrders')
          .where('userEmail', isEqualTo: email)
          .get();

      // Iterate over the documents found and delete each one
      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }

      // Increment accepted orders count

      acceptedOrdersCount++;

      FirebaseFirestore.instance
          .collection('acceptedOrders')
          .add({'userEmail': email, 'timestamp': Timestamp.now()});
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> declineOrderForPrescription(
      String email, BuildContext context) async {
    try {
      // Query Firestore to find the document(s) with the matching email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('prescriptionsImages')
          .where('userEmail', isEqualTo: email)
          .get();

      // Iterate over the documents found and delete each one
      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }

      // Increment declined orders count
      declinedOrdersCount++;
      FirebaseFirestore.instance
          .collection('declinedOrders')
          .add({'userEmail': email, 'timestamp': Timestamp.now()});
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> declineOrderCheckOut(String email, BuildContext context) async {
    try {
      // Query Firestore to find the document(s) with the matching email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userCheckoutOrders')
          .where('userEmail', isEqualTo: email)
          .get();

      // Iterate over the documents found and delete each one
      for (final document in querySnapshot.docs) {
        await document.reference.delete();
      }

      // Increment declined orders count
      declinedOrdersCount++;
      FirebaseFirestore.instance
          .collection('declinedOrders')
          .add({'userEmail': email, 'timestamp': Timestamp.now()});
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Method to update counts based on orders within 24 hours
  Future<void> updateCountsWithin24Hours() async {
    final currentTime = DateTime.now();
    final twentyFourHoursAgo = currentTime.subtract(const Duration(hours: 24));

    // Query Firestore to find accepted orders within 24 hours
    final acceptedQuerySnapshot = await FirebaseFirestore.instance
        .collection('acceptedOrders')
        .where('timestamp',
            isGreaterThan: Timestamp.fromDate(twentyFourHoursAgo))
        .get();

    // Query Firestore to find declined orders within 24 hours
    final declinedQuerySnapshot = await FirebaseFirestore.instance
        .collection('declinedOrders')
        .where('timestamp',
            isGreaterThan: Timestamp.fromDate(twentyFourHoursAgo))
        .get();

    // Update accepted and declined counts
    acceptedOrdersCount = acceptedQuerySnapshot.docs.length;
    declinedOrdersCount = declinedQuerySnapshot.docs.length;
    notifyListeners();
  }

  // Future<void> deletePrescriptionImage(String email, context) async {
  //   try {
  //     // Query Firestore to find the document(s) with the matching email
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('prescriptionsImages')
  //         .where('userEmail', isEqualTo: email)
  //         .get();

  //     // Iterate over the documents found and delete each one
  //     for (final document in querySnapshot.docs) {
  //       await document.reference.delete();
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<List<AcceptedOrders>> fetchAcceptedOrdersForToday() async {
    try {
      // Get the current date
      final now = DateTime.now();

      // Construct a DateTime object for the start of today
      final startOfDay = DateTime(now.year, now.month, now.day);

      // Construct a DateTime object for the end of today
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Query Firestore to fetch accepted orders for today
      final querySnapshot = await FirebaseFirestore.instance
          .collection('acceptedOrders')
          .where('timestamp',
              isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay)
          .get();

      // Convert QuerySnapshot to List<Order>
      final acceptedOrders = querySnapshot.docs
          .map((doc) => AcceptedOrders.fromDocumentSnapShot(doc))
          .toList();
      return acceptedOrders;
    } catch (error) {
      // Handle error
      rethrow;
    }
  }

  Future<List<DeclinedOrders>> fetchDeclinedOrdersForToday() async {
    try {
      // Get the current date
      final now = DateTime.now();

      // Construct a DateTime object for the start of today
      final startOfDay = DateTime(now.year, now.month, now.day);

      // Construct a DateTime object for the end of today
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Query Firestore to fetch declined orders for today
      final querySnapshot = await FirebaseFirestore.instance
          .collection('declinedOrders')
          .where('timestamp',
              isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay)
          .get();

      // Convert QuerySnapshot to List<Order>
      final declinedOrders = querySnapshot.docs
          .map((doc) => DeclinedOrders.fromDocumentSnapShot(doc))
          .toList();

      return declinedOrders;
    } catch (error) {
      // Handle error
      rethrow;
    }
  }

  Stream<List<PrescriptionImageModel>> fetchPrescriptionImages() {
    try {
      return FirebaseFirestore.instance
          .collection('prescriptionsImages')
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => PrescriptionImageModel.fromDocumentSnapshot(doc))
              .toList());
    } catch (e) {
      // Handle errors appropriately
      rethrow;
    }
  }

  Future<int> get prescriptionImagesLength async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('prescriptionsImages')
          .get();
      return querySnapshot.size;
    } catch (e) {
      // Handle errors appropriately
      rethrow;
    }
  }
}
