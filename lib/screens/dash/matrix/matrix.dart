import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  int level = 0;
  double amount = 0;
  String name = "";
  String link = "https://moonbnb.app/#/register?ref=";
  bool isLoading = true;
  int userId = 0;
  int joiningDate = 0;

  Color primaryColor = Colors.greenAccent;
  Map<String, dynamic> teamData = {};

  Map<String, dynamic> userData = {};

  String userAddress = "";
  int index = 2;

  @override
  void initState() {
    super.initState();
    getColor();

    getUserAddress();
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

  Future<void> getUserLvl(String addr) async {
    try {
      log("getting users level...");
      final regManager = MoonContractManager();
      final result = await regManager.getUserLevelInM50(addr);
      setState(() {
        level = result;
      });
    } catch (e) {
      logError(e.toString());
    }
  }

  Future<void> getUserTeamData(String userAddress) async {
    try {
      log("getting team data...");
      final regManager = RegistrationManager();
      final result = await regManager.getUserTeam(userAddress);
      if (result.isNotEmpty) {
        setState(() {
          log(json.encode(result).toString());
          teamData = result["teamData"];
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

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
          getUserTeamData(userAddress);
          getUserLvl(userAddress);
          getUserMoonData(userAddress);
        });
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.85;
    return Scaffold(
        backgroundColor: Color(0XFF0D0D0D),
        appBar: TopBar(
          primaryColor: Color(0XFF0D0D0D),
          secondaryColor: Colors.white,
          address: userAddress,
          changeColor: changeColor,
          path: "/dashboard",
        ),
        body: Container(
          alignment: Alignment.center,
          width: boxSize,
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "M50 Preview",
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "$amount BNB",
                          style: GoogleFonts.audiowide(
                            color: Colors.orange,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
