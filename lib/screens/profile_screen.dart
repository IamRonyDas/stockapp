import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stocknews/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File image = File('');
  final ImagePicker picker = ImagePicker();
  String? fullName, email, phoneNumber, profileImageUrl, gender, age;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('No user is logged in');
        return;
      }

      // Fetch user data from Firestore using UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          fullName = userDoc['full_name'];
          email = userDoc['email'];
          phoneNumber = userDoc['phone_number'];
          profileImageUrl = userDoc['profile_image'];
          gender = userDoc['gender'];
          age = userDoc['age'];
        });
        log('User data fetched successfully');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }

  Widget _buildProfileTextField(
      String? label, String? value, double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      child: TextFormField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Color.fromARGB(255, 183, 177, 202),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: h * 0.05),
                _buildProfileTextField('Full Name', fullName, h, w),
                _buildProfileTextField('Email', email, h, w),
                _buildProfileTextField('Phone Number', phoneNumber, h, w),
                _buildProfileTextField('Gender', gender, h, w),
                _buildProfileTextField('Age', age, h, w),
                SizedBox(height: h * 0.04),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: w * 0.85,
                      height: h * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Text('Edit Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
