import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocknews/screens/Home/components.dart';
import 'package:stocknews/screens/edit_profile.dart';
import 'package:stocknews/screens/welcome_screen.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  String? selectedGender;
  String? profileImageUrl;
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
    _fetchUserData(); // Fetch user data when the page loads
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in');
        setState(() {
          isLoading = false;
        });
        return;
      }
      log('Current user UID: ${currentUser.uid}');
      // Fetch user data from Firestore using UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      log("userDoc: $userDoc");
      if (userDoc.exists) {
        setState(() {
          nameController.text = userDoc['name'] ?? '';
          emailController.text = userDoc['email'] ?? '';
          phoneController.text = userDoc['phone'] ?? '';
          selectedGender = userDoc['gender'] ?? '';
          ageController.text = userDoc['age'] ?? '';
          profileImageUrl = userDoc['imageUrl'] ?? '';
          isLoading = false; // Set loading to false after fetching data
        });
        print('User data fetched successfully');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false; // Set loading to false if an error occurs
      });
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Big User Card Example with dynamic data
              BigUserCard(
                backgroundColor: Colors.blueAccent,
                userName: nameController.text.isEmpty
                    ? 'Loading...'
                    : nameController.text,
                userProfilePic: profileImageUrl != null
                    ? NetworkImage(
                        profileImageUrl!) // Use NetworkImage if available
                    : AssetImage("assets/user_profile.jpg") as ImageProvider,
                userMoreInfo: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    emailController.text.isEmpty
                        ? 'Loading...'
                        : emailController.text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text('General Settings',
              //       textAlign: TextAlign.start,
              //       style:
              //           TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // ),
              // // Settings Group Example
              // SettingsItem(
              //   title: "Appearance",
              //   subtitle: "Customize your theme",
              //   icon: Icons.palette,
              //   onTap: () {
              //     // Handle appearance tap
              //   },
              // ),
              // const Divider(),
              // SettingsItem(
              //   title: "Dark Mode",
              //   subtitle: "Switch to dark mode",
              //   icon: Icons.dark_mode,
              //   onTap: () {
              //     // Handle dark mode toggle
              //   },
              //   trailing: Switch(
              //     value: true,
              //     onChanged: (value) {
              //       // Handle switch change
              //     },
              //   ),
              // ),
              // // Additional Settings Group Example
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SettingsItem(
                title: "Edit Profile",
                icon: Icons.lock,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                },
              ),
              const Divider(),
              SettingsItem(
                title: "Privacy",
                icon: Icons.lock,
                onTap: () {
                  // Handle privacy settings tap
                },
              ),
              const Divider(),
              SettingsItem(
                title: "Sign Out",
                iconColor: Colors.red,
                icon: Icons.exit_to_app,
                onTap: () async {
                  await logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              ),
              const Divider(),
              SettingsItem(
                title: "Delete Account",
                iconColor: Colors.red,
                icon: Icons.exit_to_app,
                onTap: () async {
                  // await logout();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => WelcomeScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete Account'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
