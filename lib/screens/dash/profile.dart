import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/page_manager_app_bar.dart';
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

  Uint8List? userImage;
  String link = "https://moonbnb.pro/#/register?ref=";
  String defaultImage = "https://moonbnb.pro/a.webp";
  Uint8List? byteImage;
  bool isByteImageAvailable = false;
  bool isPreviewMode = false;

  Map<String, dynamic> teamData = {};
  Map<String, dynamic> userData = {};
  String userAddress = "";
  int index = 4;
  bool isUserLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AppColors colors = AppColors(
      primaryColor: Color(0XFF0D0D0D),
      themeColor: Colors.greenAccent,
      greenColor: Colors.greenAccent,
      secondaryColor: Color(0XFF121212),
      grayColor: Color(0XFF353535),
      textColor: Colors.white,
      redColor: Colors.pinkAccent);

  bool saved = false;
  Themes themes = Themes();
  String savedThemeName = "";

  Future<void> getCurrentImage(addr) async {
    try {
      final url = Uri.parse("https://chat.sauraya.com/moon/getImage/$addr");
      final usrDataUrl =
          Uri.parse("https://chat.sauraya.com/moon/getUserData/$addr");
      final response = await http.get(url);
      final usrResponse = await http.get(usrDataUrl);

      if (response.statusCode == 200) {
        final bytes = base64Decode(response.body.split(',').last);
        setState(() {
          byteImage = bytes;
          userImage = bytes;
          isByteImageAvailable = true;
        });
      }
      if (usrResponse.statusCode == 200) {
        final usrData = json.decode(usrResponse.body);
        setState(() {
          _nameController.text = usrData["name"];
          _emailController.text = usrData["email"];
          _phoneController.text = usrData["phone"];
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getSavedTheme();

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
          getCurrentImage(address);
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
  void _submitProfile() async {
    if (_formKey.currentState!.validate() || userImage == null) {
      String b64 = base64Encode(userImage!);
      log("Image converted to base64: $b64");
      final request = {
        "image": 'data:image/png;base64,$b64',
        "address": userAddress,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "name": _nameController.text,
      };
      final response = await http.post(
        Uri.parse("https://chat.sauraya.com/moon/update"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request),
      );

      if (response.statusCode == 200) {
        log("Image updated successfully");
        if (!mounted) return;
        showCustomSnackBar(
            context: context,
            message: "Image updated successfully",
            iconColor: Colors.greenAccent,
            icon: Icons.check_circle);
      }
    } else {
      showCustomSnackBar(
          context: context,
          message: "Please fill all the required fields",
          iconColor: Colors.red,
          icon: Icons.error);
    }
  }

  Future<void> getImage() async {
    try {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

      if (bytesFromPicker != null) {
        log("File retrieved");
        setState(() {
          userImage = bytesFromPicker;
        });
      }
    } catch (e) {
      logError("Error getting image: $e");
      return;
    }
  }

  Future<void> getSavedTheme() async {
    try {
      final manager = ColorsManager();
      final savedName = await manager.getThemeName();
      setState(() {
        savedThemeName = savedName ?? "";
      });
      final savedTheme = await manager.getDefaultTheme();
      setState(() {
        colors = savedTheme;
      });
    } catch (e) {
      logError(e.toString());
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
      backgroundColor: colors.primaryColor,
      appBar: TopBar(
        colors: colors,
        path: "/main",
        changeColor: (data) {},
        address: userAddress,
        primaryColor: colors.primaryColor,
        secondaryColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
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
                                    InkWell(
                                      onTap: () async {
                                        await getImage();
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: userImage != null
                                                ? MemoryImage(userImage!)
                                                : AssetImage(
                                                    "assets/image/a.webp"),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                              color: colors.primaryColor,
                                              width: 3),
                                        ),
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
                                          color: colors.primaryColor
                                              .withOpacity(0.6),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: colors.textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Name field.
                                TextFormField(
                                  controller: _nameController,
                                  style:
                                      GoogleFonts.exo2(color: colors.textColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        colors.grayColor.withOpacity(0.3),
                                    labelText:
                                        AppLocale.nameText.getString(context),
                                    labelStyle: GoogleFonts.exo2(
                                        color:
                                            colors.textColor.withOpacity(0.4)),
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
                                  style:
                                      GoogleFonts.exo2(color: colors.textColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        colors.grayColor.withOpacity(0.3),
                                    labelText:
                                        AppLocale.emailText.getString(context),
                                    labelStyle: GoogleFonts.exo2(
                                        color: colors.textColor),
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
                                  style:
                                      GoogleFonts.exo2(color: colors.textColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        colors.grayColor.withOpacity(0.3),
                                    labelText:
                                        "${AppLocale.PhoneText.getString(context)} (${AppLocale.optionalText.getString(context)})",
                                    labelStyle: GoogleFonts.exo2(
                                        color: colors.textColor),
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
                                      backgroundColor: colors.textColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocale.submitText.getString(context),
                                      style: GoogleFonts.exo2(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primaryColor
                                            .withOpacity(0.8),
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
              ))),
    );
  }
}
