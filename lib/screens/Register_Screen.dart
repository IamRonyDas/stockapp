import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stocknews/screens/Home/HomeScreen.dart';
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
  String selectedGender = 'Male';

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      log('Image picking error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
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

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    bool isPasswordField = false,
    bool isConfirmPasswordField = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPasswordField
          ? !isPasswordVisible
          : isConfirmPasswordField
              ? !isConfirmPasswordVisible
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
        suffixIcon: isPasswordField || isConfirmPasswordField
            ? IconButton(
                icon: Icon(
                  isPasswordField
                      ? (isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : (isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
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

  Future<void> _registerAndUploadData() async {
    log('Registering user and uploading data');
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

    setState(() {
      isLoading = true;
    });

    try {
      log("Creating user with email: ${widget.email}");

      if (FirebaseAuth.instance.currentUser != null) {
        await FireBaseFunctions().uploadUserData(
          nameController.text,
          phoneController.text,
          ageController.text,
          selectedGender,
          widget.email,
          passwordController.text,
          image,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NewsScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() {
        isLoading = false;
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
                    const Text(
                      'Register Profile',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
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
                        if (image.path.isNotEmpty)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = File('');
                                });
                              },
                              child: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.delete, color: Colors.red),
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
                _buildTextField(phoneController, 'Phone Number',
                    inputType: TextInputType.phone),
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
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                SizedBox(height: h * 0.02),
                _buildTextField(passwordController, 'Password',
                    isPasswordField: true),
                SizedBox(height: h * 0.02),
                _buildTextField(confirmPasswordController, 'Confirm Password',
                    isConfirmPasswordField: true),
                SizedBox(height: h * 0.04),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _registerAndUploadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
