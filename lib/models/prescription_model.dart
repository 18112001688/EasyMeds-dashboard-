import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionImageModel {
  final String userName;
  final String userEmail;
  final String userImage;
  final Timestamp timestamp;
  final String imageURL;

  PrescriptionImageModel(
      {required this.userName,
      required this.userEmail,
      required this.userImage,
      required this.timestamp,
      required this.imageURL});

  factory PrescriptionImageModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return PrescriptionImageModel(
      userName: data['userName'],
      userEmail: data['userEmail'],
      userImage: data['userImage'],
      imageURL: data['imageURL'],
      timestamp: data['timestamp'] ?? Timestamp.now(), // Convert to Timestamp
    );
  }
}
