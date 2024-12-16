import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocknews/screens/Home/HomeScreen.dart';
import 'package:stocknews/screens/Register_Screen.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isButtonActive = false; // Track if the button should be enabled or not
  bool _obscurePassword = true; // Track if the password is visible
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateInputs);
    passwordController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  UserCredential? userCredential;

  // Function to validate inputs and enable/disable button
  void _validateInputs() {
    setState(() {
      isButtonActive =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Log In",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Username or email',
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      _obscurePassword, // Hide password text based on state
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0), // Bottom border color and width
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0), // Bottom border when focused
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons
                                .visibility // Show icon if password is hidden
                            : Icons
                                .visibility_off, // Hide icon if password is visible
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword; // Toggle visibility
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                        text: 'Forget your ',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        children: [
                          TextSpan(
                            text: 'password',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          )
                        ])),
                SizedBox(height: size.height * 0.015),
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      fillColor: MaterialStateProperty.all(
                        Colors.grey.shade100,
                      ),
                    ),
                    const Text('Remember me', style: TextStyle(fontSize: 15))
                  ],
                ),
                SizedBox(height: size.height * 0.015),
                _isLoading // Show loading indicator or button
                    ? Center(child: CircularProgressIndicator())
                    : GestureDetector(
                        onTap: isButtonActive
                            ? () async {
                                setState(() {
                                  _isLoading = true; // Start loading
                                });
                                log('Email: ${emailController.text}');
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsScreen(),
                                    ),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                } finally {
                                  setState(() {
                                    _isLoading = false; // Stop loading
                                  });
                                }
                              }
                            : null, // Disable button tap if inactive
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.9,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: isButtonActive
                                ? Colors.blue // Active color
                                : const Color.fromARGB(
                                    255, 199, 198, 198), // Inactive color
                            borderRadius:
                                BorderRadius.circular(size.width * 0.1),
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: size.height * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.25,
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      ),
                    ),
                    const SizedBox(width: 50),
                    const Text("or"),
                    const SizedBox(width: 50),
                    Container(
                      width: size.width * 0.25,
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.015),
                loginbutton("Sign in with Google", size.width, size.height,
                    'googleicon.png'),
                SizedBox(height: size.height * 0.015),
                loginbutton("Sign up with Apple", size.width, size.height,
                    'appleicon.png'),
                SizedBox(height: size.height * 0.15),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: 'By signing up, you agree to our ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();
        log("${userDoc.data()}");

        if (userDoc.exists) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NewsScreen()),
              (route) => false);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterScreen(
                email: user.email ?? '',
              ),
            ),
          );
        }
      }
    } on Exception catch (e) {
      log('Exception during Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed')),
      );
    }
  }

  Widget loginbutton(String s, double width, double height, String image) {
    return GestureDetector(
      onTap: () async {
        log('Login with $s');
        if (s == "Sign in with Google") {
          await signInWithGoogle();
        } else {
          // Implement Apple Sign in
        }
      },
      child: Container(
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
      ),
    );
  }
}
