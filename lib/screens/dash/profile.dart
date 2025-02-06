import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int level = 0;
  final int amount = 0;
  String name = "";
  bool isLoading = true;

  Color primaryColor = Colors.orange;
  Map<String, dynamic> teamData = {};
  Map<String, dynamic> userData = {};
  String userAddress = "";
  int index = 4;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void changeColor(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('color', value);
    setState(() {
      if (value == "orange") {
        primaryColor = Colors.orange;
      } else if (value == "blue") {
        primaryColor = Colors.blue;
      } else if (value == "green") {
        primaryColor = Colors.greenAccent;
      }
    });
  }

  void getColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('color');
    setState(() {
      if (value == "orange") {
        primaryColor = Colors.orange;
      } else if (value == "blue") {
        primaryColor = Colors.blue;
      } else if (value == "green") {
        primaryColor = Colors.greenAccent;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getColor();
    getUserAddress();
  }

  void getUserAddress() async {
    try {
      final web3 = Web3Manager();
      String address = await web3.getAddress();
      if (address.isEmpty) {
        log("No address found");
      } else {
        log("address : $address");
        setState(() {
          userAddress = address;
          // Optionally, you can load user data here.
          isLoading = false;
        });
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  // Called when the user taps the submit button.
  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      // Process profile update.
      log("Name: ${_nameController.text}");
      log("Email: ${_emailController.text}");
      log("Phone: ${_phoneController.text}");
      // Here you could call an API to update the user profile.
      // After successful submission, you may want to show a confirmation or navigate.
      showCustomSnackBar(
          context: context,
          message: "Profile updated successfully",
          iconColor: Colors.greenAccent,
          icon: Icons.check_circle);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.85;

    return Scaffold(
      backgroundColor: const Color(0XFF0D0D0D),
      appBar: TopBar(
        path: "/dashboard",
        changeColor: changeColor,
        address: userAddress,
        primaryColor: const Color(0XFF0D0D0D),
        secondaryColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          alignment: Alignment.center,
          child: Align(
            alignment: Alignment.center,
            child: Container(
                alignment: Alignment.center,
                width: boxSize,
                height: 500,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("assets/bg/blur_white_copy.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Profile image with camera icon overlay.
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                  image: AssetImage("assets/image/a.webp"),
                                  fit: BoxFit.cover,
                                ),
                                border:
                                    Border.all(color: primaryColor, width: 3),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Name field.
                        TextFormField(
                          controller: _nameController,
                          style: GoogleFonts.exo2(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0XFF353535),
                            labelText: "Name",
                            labelStyle: GoogleFonts.exo2(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Email field.
                        TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.exo2(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0XFF353535),
                            labelText: "Email",
                            labelStyle: GoogleFonts.exo2(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
                            }
                            // Basic email validation.
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value.trim())) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Optional phone field.
                        TextFormField(
                          controller: _phoneController,
                          style: GoogleFonts.exo2(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0XFF353535),
                            labelText: "Phone (Optional)",
                            labelStyle: GoogleFonts.exo2(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 25),
                        // Submit button.
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: _submitProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Submit",
                              style: GoogleFonts.exo2(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        primaryColor: primaryColor,
        currentIndex: index,
        onTap: (index) {
          if (index == 2) {
            context.go("/dashboard");
          } else if (index == 3) {
            context.go("/team");
          }
        },
      ),
    );
  }
}
