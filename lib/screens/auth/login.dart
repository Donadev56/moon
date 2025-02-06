import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color primaryColor = Colors.greenAccent;
  String userAddress = "";
  bool isLoading = true;
  double amount = 0;
  String name = "";
  String link = "https://moonbnb.pro/#/register?ref=";
  int userId = 0;
  int joiningDate = 0;
  int totalUsers = 0;
  Map<String, dynamic> teamData = {};

  Map<String, dynamic> userData = {};
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

  Future<void> getUserMoonData(String addr) async {
    try {
      final manager = MoonContractManager();
      final result = await manager.getUserInfo(addr);

      if (result.isNotEmpty) {
        setState(() {
          log(json.encode(result).toString());
          final data = result["response"];
          log("response $data");
          setState(() {
            amount = data["totalIncome"] / 1e18;
          });
        });
      }

      isLoading = false;
    } catch (e) {
      logError(e.toString());
      isLoading = false;
    }
  }

  Future<void> getUserdataWithAddress(String addr) async {
    try {
      final regManager = RegistrationManager();
      if (addr.isNotEmpty && addr.length > 30) {
        final data = await regManager.getUserInfo(addr);
        log(json.encode(data).toString());
        if (data.isNotEmpty) {
          setState(() {
            userData = data["userData"];
            name = userData["name"];
            userId = userData["countId"];
            joiningDate = userData["joiningDate"];
            link = "$link$userId";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getColor();
    getUserAddress();
    getUsersCount();
  }

  Future<void> getUsersCount() async {
    try {
      log("getting users count...");
      final regManager = RegistrationManager();
      final result = await regManager.getNumberOfUsers();
      setState(() {
        totalUsers = result;
      });
    } catch (e) {
      logError(e.toString());
    }
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
          getUserdataWithAddress(userAddress);
          getUserMoonData(userAddress);

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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.8;

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
                              "Login to Your ",
                              style: GoogleFonts.audiowide(
                                  color: Colors.white, fontSize: 25),
                            ),
                            Text(
                              "MoonBNB Account",
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
                          "Connect you wallet to login to your account",
                          style: GoogleFonts.exo2(
                              color: const Color.fromARGB(137, 255, 255, 255)),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  width: width * 0.8,
                  decoration: BoxDecoration(
                      color: Color(0XFF171717),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                "assets/bnb/b3.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$amount BNB",
                                  style: GoogleFonts.audiowide(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text("Total Earnings",
                                    style: GoogleFonts.exo(
                                        color: const Color.fromARGB(
                                            142, 255, 255, 255),
                                        fontSize: 16))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                        width: boxSize,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Name :",
                              style: GoogleFonts.exo2(
                                  color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              name.isNotEmpty ? name : " Not Found",
                              style: GoogleFonts.exo2(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ],
                        )),
                    Container(
                        width: boxSize,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 0, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "User Id :",
                              style: GoogleFonts.exo2(
                                  color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              userId > 0 ? "$userId" : " Not Found",
                              style: GoogleFonts.exo2(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ],
                        )),
                    Container(
                        width: boxSize,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 0, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Global Team :",
                              style: GoogleFonts.exo2(
                                  color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              name.isNotEmpty
                                  ? "${totalUsers - userId} "
                                  : " Not Found",
                              style: GoogleFonts.exo2(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  width: width * 0.80,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () async {
                      final regManager = RegistrationManager();
                      final isReg = await regManager.isRegistered(userAddress);
                      if (isReg) {
                        context.go('/dashboard');
                      } else {
                        context.go('/register');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/register');
                  },
                  child: Container(
                    width: width * 0.80,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Don't have an account? Sign up",
                      style: GoogleFonts.exo2(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
