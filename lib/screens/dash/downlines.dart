import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/downlines_list.dart';
import 'package:moon/widget/profit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DownlinesScreen extends StatefulWidget {
  const DownlinesScreen({super.key});

  @override
  State<DownlinesScreen> createState() => _DownlinesScreenState();
}

class _DownlinesScreenState extends State<DownlinesScreen> {
  final List<DownlinesData> downlines = [];

  final int level = 0;
  final int amount = 0;
  String name = "";
  String link = "https://moonbnb.app/#/register?ref=";
  bool isLoading = true;
  int userId = 0;
  int joiningDate = 0;
  int totalUsers = 0;
  Color primaryColor = Colors.orange;
  Map<String, dynamic> teamData = {};

  Map<String, dynamic> userData = {};

  String userAddress = "";
  int index = 3;

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
          getUserTeamData(userAddress);
        });
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getUserTeamData(String userAddress) async {
    try {
      log("getting team data...");
      final regManager = RegistrationManager();
      final result = await regManager.getUserTeam(userAddress);
      if (result.isNotEmpty) {
        teamData = result["teamData"];
        final directsAddresses = teamData["directDownlinesArray"];
        log("directs addresses $directsAddresses");
        setState(() {
          log(json.encode(result).toString());
          isLoading = false;
        });
        for (final address in directsAddresses.reversed.toList()) {
          final userData = await getUserdataWithAddress(address);
          final name = userData["name"];
          log("current user name $name");
          final time = userData["joiningDate"];
          log("current user time $time");
          final id = userData["countId"];
          log("current user id $id");
          final DownlinesData newUser = DownlinesData(
              icon: FeatherIcons.user,
              name: name,
              time: "${inDays(time)} Days",
              id: id.toString(),
              iconColor: Colors.greenAccent);
          setState(() {
            downlines.add(newUser);
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

  int inDays(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(dateTime);

    return difference.inDays;
  }

  Future<Map<String, dynamic>> getUserdataWithAddress(String addr) async {
    try {
      final regManager = RegistrationManager();
      if (addr.isNotEmpty && addr.length > 30) {
        final data = await regManager.getUserInfo(addr);
        log(json.encode(data).toString());
        if (data.isNotEmpty) {
          userData = data["userData"];
          return userData;
        }

        return {};
      }

      return {};
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.85;

    return Scaffold(
      backgroundColor: Color(0XFF0D0D0D),
      appBar: TopBar(
        path: "/dashboard",
        changeColor: changeColor,
        address: userAddress,
        primaryColor: Color(0XFF0D0D0D),
        secondaryColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: boxSize,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfitWidget(
                            imageUrl: "assets/image/32.png",
                            title: "Total Direct",
                            totalAmount:
                                "${teamData["directDownlinesCount"] ?? 0}",
                            dailyAmount: "0"),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        ProfitWidget(
                            imageUrl: "assets/image/31.png",
                            title: "Total Team",
                            totalAmount: "${teamData["teamSize"] ?? 0}",
                            dailyAmount: "0"),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: boxSize,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    "Partners",
                    style: GoogleFonts.audiowide(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                DownlinesListWidget(downlines: downlines),
              ],
            )),
      ),
      bottomNavigationBar: BottomNav(
        primaryColor: primaryColor,
        currentIndex: index,
        onTap: (index) {
          if (index == 2) {
            context.go("/dashboard");
          } else if (index == 4) {
            context.go("/profile");
          }
        },
      ),
    );
  }
}
