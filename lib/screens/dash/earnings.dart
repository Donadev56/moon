import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/history_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Earnings extends StatefulWidget {
  const Earnings({super.key});

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  final List<HistoryData> history = [];

  String name = "";
  String link = "https://moonbnb.app/#/register?ref=";
  bool isLoading = true;

  Color primaryColor = Colors.orange;
  List<double> levels = [];
  String userAddress = "";
  int index = 1;

  @override
  void initState() {
    super.initState();
    getLevels();

    getColor();
    getUserAddress();
  }

  void getLevels() {
    List<double> lvls = List.filled(12, 0);
    lvls[0] = 0.005;

    for (int i = 1; i < lvls.length; i++) {
      lvls[i] = lvls[i - 1] * 2;
    }

    setState(() {
      levels = lvls;
    });
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
          getHistories(userAddress);
        });
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getHistories(addr) async {
    try {
      final manager = MoonContractManager();
      final regManager = RegistrationManager();
      final result = await manager.getHistories(addr);
      if (result.isNotEmpty) {
        log(json.encode(result).toString());
        final data = result["response"];
        for (final hist in json.decode(data).reversed.toList()) {
          final name = hist["actionName"];
          final time = inDays(hist["actionDate"]).toString();
          final amount = (hist["actionAmount"] / 1e18).toString();
          final from = hist["actionFrom"];
          final idResult = await regManager.getUserInfo(from);
          if (idResult.isNotEmpty) {
            final userData = idResult["userData"];
            log("userData $userData");
            final id = ("${userData["countId"]}");
            log("user id: $id");
            final HistoryData newHistory = HistoryData(
                id: id,
                name: name,
                icon: Icons.monetization_on,
                iconColor: Colors.greenAccent,
                time: time,
                amount: amount);
            setState(() {
              history.add(newHistory);
            });
          }
        }
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  int inDays(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(dateTime);

    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.9;
    return Scaffold(
      backgroundColor: Color(0XFF0D0D0D),
      appBar: TopBar(
        path: "/dashboard",
        changeColor: changeColor,
        address: userAddress,
        primaryColor: Color(0XFF0D0D0D),
        secondaryColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: boxSize,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Earnings",
                style: GoogleFonts.audiowide(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            HistoryWidget(history: history)
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        primaryColor: primaryColor,
        currentIndex: index,
        onTap: (index) {
          if (index == 2) {
            context.go("/dashboard");
          } else if (index == 4) {
            context.go("/profile");
          } else if (index == 1) {
            context.go("/earnings");
          } else if (index == 0) {
            context.go("/withdraw");
          }
        },
      ),
    );
  }
}
