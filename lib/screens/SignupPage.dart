import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import for Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocknews/screens/Register_Screen.dart';
import 'package:stocknews/screens/SigninPage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      log('exception->$e');
    }
  }

  UserCredential? userCredential;

  Future<void> _checkIfEmailExists() async {
    try {
      // Check if email is already registered in Firestore
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users') // Change this to your Firestore collection name
          .where('email', isEqualTo: emailController.text)
          .get();

      if (result.docs.isNotEmpty) {
        // Email already exists, show dialog
        _showEmailAlreadyRegisteredDialog();
      } else {
        // Email does not exist, proceed to registration
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(email: emailController.text),
          ),
        );
      }
    } catch (e) {
      log('Error checking email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking email')),
      );
    }
  }

  void _showEmailAlreadyRegisteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Already Registered'),
          content: const Text(
              'The email is already registered. Please sign in instead.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninPage()),
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(color: Colors.grey, thickness: 1),
              Container(
                width: width,
                margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: width * 0.05,
                    top: height * 0.02), // Optional margin for spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.4,
                      child: const Text(
                        'Email Address',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0), // Bottom border color and width
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0), // Bottom border when focused
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter email')),
                    );
                    return;
                  }
                   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(email: emailController.text),
          ), 
        );
                },
                child: Container(
                    alignment: Alignment.center,
                    width: width * 0.9,
                    height: height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    child: const Text(
                      "Create an Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
              ),
              SizedBox(height: height * 0.03),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.25,
                      child: const Divider(color: Colors.grey, thickness: 0.2),
                    ),
                    const SizedBox(width: 50),
                    const Text("or"),
                    const SizedBox(width: 50),
                    Container(
                      width: width * 0.25,
                      child: const Divider(color: Colors.grey, thickness: 0.2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              GestureDetector(
                onTap: () async {
                  userCredential = await signInWithGoogle();
                  if (userCredential != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                          email: userCredential!.user!.email!,
                        ),
                      ),
                    );
                  }
                },
                child: loginbutton(
                    "Sign in with Google", width, height, 'googleicon.png'),
              ),
              SizedBox(height: height * 0.015),
              loginbutton("Sign up with Apple", width, height, 'appleicon.png'),
              SizedBox(height: height * 0.04),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return const SigninPage();
                            },
                          ));
                        },
                      text: 'Sign in',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.25),
              RichText(
                text: TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginbutton(String s, double width, double height, String image) {
    return Container(
      alignment: Alignment.center,
      width: width * 0.9,
      height: height * 0.06,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.1),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/$image'), height: 18),
          const SizedBox(width: 10),
          Text(
            s,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
