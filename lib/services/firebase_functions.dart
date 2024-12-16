import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FireBaseFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadUserData(
    String name,
    String phone,
    String age,
    String gender,
    String email,
    String password,
    File image,
  ) async {
    try {
      // Upload the image to Firebase Storage
      log("i am chandna");
      String imageUrl = await _uploadImageToStorage(email, image);

      // Save user details in Firestore
      String uuid = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(uuid).set({
        'name': name,
        'phone': phone,
        'age': age,
        'gender': gender,
        'email': email,
        'password': password,
        'imageUrl': imageUrl,
      });

      log("User data uploaded successfully");
    } catch (e) {
      log("Error uploading user data: $e");
      rethrow;
    }
  }

  Future<String> _uploadImageToStorage(String email, File image) async {
    try {
      // Define a unique path for the image in Firebase Storage
      String storagePath = 'user_images/$email/profile_image.jpg';

      // Upload the file
      UploadTask uploadTask = _storage.ref(storagePath).putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL for the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error uploading image: $e");
      throw Exception('Failed to upload image');
    }
  }
}
