import 'package:flutter/material.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  bool isChecked = false; // Initialize the checkbox value

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Container(
            width: width,
            margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
            child: const Text(
              'Create a Username',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked, // Use the checkbox state
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!; // Update the checkbox state
                    });
                  },
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Sign up for ', // Normal text
                    style: TextStyle(color: Colors.black), // Default text style
                    children: [
                      TextSpan(
                        text:
                            'Daily Morning Updates', // Text to be colored blue
                        style: TextStyle(color: Colors.blue), // Blue text style
                      ),
                      TextSpan(
                        text: '\nand ', // Add a line break and normal text
                        style: TextStyle(
                            color: Colors.black), // Default text style
                      ),
                      TextSpan(
                        text: 'Weekly News Update', // Normal text
                        style:
                            TextStyle(color: Colors.blue), // Default text style
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          RichText(
            text: const TextSpan(
              text: 'By signing up, you agree to our ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Terms of Conditions',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
              alignment: Alignment.center,
              width: width * 0.8,
              height: height * 0.07,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 199, 198, 198),
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
          SizedBox(height: height * 0.06),
        ],
      ),
    );
  }
}
