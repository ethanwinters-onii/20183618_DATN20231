import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConstants {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static DatabaseReference ref = FirebaseDatabase.instance.ref();
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static String apiKey =
      "AAAAviUT5HQ:APA91bES3SqZ29tYxeniCTX2hWjzrkYsEsMYLSQuFbp78MAvg-myhT1H0JIoJDpsIgIpU9uj8GSiLq1YmVpGMEBAN0BNV8fV46kI4bbQjB94orXUwbvP4HLkeTIZrVWIkBf88sR1kD5G";
}
