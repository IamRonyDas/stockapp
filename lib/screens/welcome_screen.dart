import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocknews/screens/Home/HomeScreen.dart';
import 'package:stocknews/screens/SignupPage.dart';
import 'package:stocknews/screens/SigninPage.dart';
import 'package:stocknews/widgets/custom_scaffold.dart';
import 'package:stocknews/widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserAsync();
    });
  }

  void _checkUserAsync() async {
    await checkUser();
  }

  Future<void> checkUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return CustomScaffold(
        child: Column(
      children: [
        Flexible(
            flex: 8,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'Welcome Back!\n',
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                          text:
                              '\n Enter personal details to your employee account',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ])),
                ))),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                const Expanded(
                    child: WelcomeButton(
                  ButtonText: 'Sign In',
                  onTap: SigninPage(),
                  color: Colors.transparent,
                  textColor: Colors.white,
                )),
                Expanded(
                    child: WelcomeButton(
                  ButtonText: 'Sign Up',
                  onTap: const SignupScreen(),
                  color: Colors.white,
                  textColor: Colors.blue[900],
                )),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
