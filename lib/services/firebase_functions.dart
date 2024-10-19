import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseFunctions {
  Future<String> uploadImage(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String imageFileName = 'profile_images/${DateTime.now()}.jpg';
    UploadTask uploadTask = storage.ref(imageFileName).putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> uploadUserData(
    String name,
    String phoneNumber,
    String age,
    String gender,
    String email,
    String password,
    File image,
  ) async {
    String imageUrl = await uploadImage(image);

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'full_name': name,
          'email': email,
          'profile_image': imageUrl,
          'phone_number': phoneNumber,
          'age': age,
          'gender': gender,
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }
}
