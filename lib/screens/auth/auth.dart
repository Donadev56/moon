import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/logger/logger.dart';

import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/widget/model_bottom.dart';
import 'package:moon/widget/snackbar.dart';

class AuthScreen extends StatefulWidget {
  final String? ref;

  const AuthScreen({super.key, this.ref});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

final List<Map<String, dynamic>> options = [
  {"title": "Home ", "icon": Icons.home},
  {"title": "Registration ", "icon": LucideIcons.logIn},
  {"title": "Login ", "icon": Icons.login},
];

class _AuthScreenState extends State<AuthScreen> {
  String sponsorID = "";
  String userName = "";
  String userAddress = "";

  Map<String, dynamic> sponsorData = {};
  bool isRegistering = false;
  late TextEditingController _textEditingController;

  Future<void> getUserAddress() async {
    try {
      final web3 = Web3Manager();
      String address = await web3.getAddress();
      if (address.isNotEmpty) {
        setState(() {
          userAddress = address;
        });
        if (!mounted) return;
        showCustomSnackBar(
            context: context,
            icon: Icons.check_circle,
            message: "Address Connected ${address.substring(0, 4)} ...",
            iconColor: Colors.greenAccent);
      } else {
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            message: "Address not found",
            iconColor: Colors.pinkAccent);
      }
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(
          context: context,
          message: e.toString(),
          iconColor: Colors.pinkAccent);
    }
  }

  Future<void> registration() async {
    try {
      Navigator.pop(context);
      setState(() {
        isRegistering = true;
      });

      log('registering user');
      if (sponsorID.isEmpty || userAddress.isEmpty || userName.isEmpty) {
        // close the  modal
        showCustomSnackBar(
            context: context,
            message: "All fields are required",
            iconColor: Colors.pinkAccent);
        setState(() {
          isRegistering = false;
        });

        return;
      }

      final regManager = RegistrationManager();

      final isReg = await regManager.isRegistered(userAddress);
      if (isReg) {
        setState(() {
          isRegistering = false;
        });
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            icon: Icons.error,
            message: "User already registered",
            iconColor: Colors.red);
        context.go('/dashboard');

        return;
      }
      final success = await regManager.register(sponsorID, userName);
      if (success) {
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            icon: Icons.check_circle,
            message: "Registration Successful",
            iconColor: Colors.greenAccent);

        setState(() {
          sponsorID = "";
          userName = "";
        });
        if (!mounted) return;
        context.go('/dashboard');
      } else {
        setState(() {
          isRegistering = false;
        });
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            icon: Icons.error,
            message: "Registration Failed",
            iconColor: Colors.red);
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isRegistering = false;
      });

      if (!mounted) return;
      Navigator.pop(context);
      showCustomSnackBar(
          context: context,
          message: e.toString(),
          iconColor: Colors.pinkAccent);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserAddress();
    _textEditingController = TextEditingController();

    if (widget.ref != null) {
      setState(() {
        final String ref = widget.ref!;
        sponsorID = ref;
        _textEditingController.text = sponsorID;
        getUserdataWithAddress(ref);
      });
    }
  }

  Future<void> getUserdataWithAddress(String id) async {
    try {
      final regManager = RegistrationManager();
      final addr = await regManager.getSponsorAddress(int.parse(id));
      if (addr.isNotEmpty && addr.length > 30) {
        final data = await regManager.getUserInfo(addr);
        log(json.encode(data).toString());
        if (data.isNotEmpty) {
          setState(() {
            sponsorData = data;
          });
        }
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color(0XFF0D0D0D),
        appBar: AppBar(
          surfaceTintColor: Color(0XFF0D0D0D),
          actions: [
            Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(98, 53, 53, 53)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            userAddress.isEmpty
                                ? "Connect Wallet"
                                : "${userAddress.substring(0, 4)}...${userAddress.substring(userAddress.length - 4, userAddress.length)}",
                            style: GoogleFonts.audiowide(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Moon BNB",
              style: GoogleFonts.audiowide(color: Colors.white, fontSize: 18),
            ),
          ),
          backgroundColor: Color(0XFF0D0D0D),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/bg/blur_orange2.png',
                  ),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Register in ",
                              style: GoogleFonts.audiowide(
                                  color: Colors.white, fontSize: 25),
                            ),
                            Text(
                              "MoonBNB Project",
                              style: GoogleFonts.audiowide(
                                  color: Colors.orange,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, top: 10, bottom: 5),
                        child: Text(
                          "Register to start earning money globally",
                          style: GoogleFonts.exo2(
                              color: const Color.fromARGB(137, 255, 255, 255)),
                        ),
                      ),
                    )
                  ],
                ),
                if (sponsorData.isNotEmpty)
                  Container(
                    width: width * 0.65,
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Sponsor Name :",
                          style: GoogleFonts.audiowide(color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          sponsorData["userData"]["name"],
                          style: GoogleFonts.audiowide(color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                Form(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: width * 0.65,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 0, bottom: 10),
                      child: Text(
                        "Name",
                        style: GoogleFonts.audiowide(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.6),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            userName = value;
                          });
                        },
                        cursorColor: Colors.orange,
                        style: GoogleFonts.exo(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.exo(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: "NickName",
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.65,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Sponsor",
                        style: GoogleFonts.audiowide(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.6),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingController,
                        onChanged: (value) async {
                          setState(() {
                            sponsorID = value;
                          });
                          await getUserdataWithAddress(sponsorID);
                        },
                        cursorColor: Colors.orange,
                        style: GoogleFonts.exo(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.exo(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: "Sponsor",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    !isRegistering
                        ? ConstrainedBox(
                            constraints: BoxConstraints(minWidth: width * 0.6),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (sponsorID.isEmpty ||
                                      userAddress.isEmpty ||
                                      userName.isEmpty) {
                                    showCustomSnackBar(
                                        context: context,
                                        message: "All fields are required",
                                        iconColor: Colors.pinkAccent);
                                    return;
                                  }
                                  showModelBottomSheet(
                                      context,
                                      "0.0003",
                                      "Registration",
                                      "By accepting this request you accept the terms and conditions of work to join Moon BNB and its community.",
                                      "0xC4A39C048177A339a3C46759B89a9eC01c56407a",
                                      () async {
                                    await registration();
                                  });
                                },
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.exo2(
                                      color:
                                          const Color.fromARGB(208, 0, 0, 0)),
                                )),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: Container(
                        width: width * 0.63,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Already Registered ? ",
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
