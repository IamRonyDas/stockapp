import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stocknews/screens/Home/HomeScreen.dart';
import 'package:stocknews/screens/profile_screen.dart';
import 'package:stocknews/services/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  final String email;

  const RegisterScreen({super.key, required this.email});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File image = File('');
  final ImagePicker _picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String selectedGender = 'Male'; // Default gender selection

  // Variables for password visibility
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile!.path.isNotEmpty) {
      log('Image path: ${pickedFile.path}');
      setState(() {
        image = File(pickedFile.path);
        log('Image: $image');
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType inputType = TextInputType.text,
      bool obscureText = false,
      bool isPasswordField = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPasswordField
          ? (isPasswordField ? !isPasswordVisible : !isConfirmPasswordVisible)
          : obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color.fromARGB(255, 183, 177, 202),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        suffixIcon: isPasswordField // Add the eye icon for password visibility
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isPasswordField) {
                      isPasswordVisible = !isPasswordVisible;
                    } else {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }

  bool isLoading = false; // Add this line

  Future<void> _registerAndUploadData() async {
    if (image.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedGender.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must be exactly 10 digits')),
      );
      return;
    }

    // Show loading dialog
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: passwordController.text);
      User? user = userCredential.user;
      if (user != null) {
        await FireBaseFunctions().uploadUserData(
            nameController.text,
            phoneController.text,
            ageController.text,
            selectedGender,
            widget.email,
            passwordController.text,
            image);
        log('User data uploaded successfully');
        Navigator.of(context).pop(); // Close the loading dialog
        setState(() {
          isLoading = false; // Reset loading state
        });
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create account')),
      );
      // Close loading dialog and reset loading state
      Navigator.of(context).pop(); // Close the loading dialog
      setState(() {
        isLoading = false; // Reset loading state
      });
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.04),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: w * 0.05),
                    const Text('Register Profile',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: h * 0.02),
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              image.path.isNotEmpty ? FileImage(image) : null,
                          child: image.path.isEmpty
                              ? const Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete the image?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            image = File('');
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
                _buildTextField(nameController, 'Full Name'),
                SizedBox(height: h * 0.02),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: const Color.fromARGB(
                        255, 183, 177, 202), // Background fill color
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)), // Rounded borders
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width:
                              1.0), // Border color and width when not focused
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)), // Rounded borders when focused
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0), // Border color and width when focused
                    ),
                    suffixIcon:
                        null, // No suffix icon for the phone number field
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Only allows digits
                    LengthLimitingTextInputFormatter(
                        10), // Limits input to 10 digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length != 10) {
                      return 'Phone number must be exactly 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h * 0.02),
                _buildTextField(ageController, 'Age',
                    inputType: TextInputType.number),
                SizedBox(height: h * 0.02),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 183, 177, 202),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),
                SizedBox(height: h * 0.02),
                _buildTextField(passwordController, 'Password',
                    obscureText: true, isPasswordField: true),
                SizedBox(height: h * 0.02),
                _buildTextField(confirmPasswordController, 'Confirm Password',
                    obscureText: true, isPasswordField: false),
                SizedBox(height: h * 0.06),
                GestureDetector(
                  onTap: () async {
                    await _registerAndUploadData();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewsScreen()));
                  },
                  child: Center(
                    child: Container(
                      width: w * 0.9,
                      height: h * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Text('Save Details',
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
