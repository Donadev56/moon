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
import 'package:moon/widget/model_bottom.dart';
import 'package:moon/widget/snackbar.dart';
import 'package:moon/widget/withdraw_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  final List<HistoryData> history = [];

  String name = "";
  String link = "https://moonbnb.app/#/register?ref=";
  bool isLoading = true;

  Color primaryColor = Colors.orange;
  List<double> levels = [];
  String userAddress = "";
  int index = 0;
  bool isWithdrawing = false;
  double availableGain = 0;

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

  Future<void> getAvailableGain(addr) async {
    try {
      final manager = MoonContractManager();
      final result = await manager.checkAvailableAmount(addr);

      if (result > 0) {
        setState(() {
          log(json.encode(result).toString());
          availableGain = result / 1e18;
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
          getHistories(userAddress);
          getAvailableGain(userAddress);
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
      final result = await manager.getWithdrawals(addr);
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

  Future<void> withdraw() async {
    try {
      if (availableGain == 0) {
        showCustomSnackBar(
            context: context,
            message: "No available gain",
            iconColor: Colors.red);
        return;
      }

      showModelBottomSheet(
          context,
          availableGain.toString(),
          "Withdraw of $availableGain BNB",
          "You are about to withdraw $availableGain from your Global earnings and you will receive the amount directly in $userAddress",
          userAddress, () async {
        Navigator.pop(context);
        setState(() {
          isWithdrawing = true;
          getAvailableGain(userAddress);
          getHistories(userAddress);
        });

        final manager = MoonContractManager();
        final result = await manager.withdraw();
        if (result) {
          setState(() {
            availableGain = 0;
            isWithdrawing = false;
          });
          if (!mounted) return;
          showCustomSnackBar(
              context: context,
              message: "Withdraw Successfully",
              iconColor: Colors.greenAccent);
        } else {
          setState(() {
            isWithdrawing = false;
          });
          if (!mounted) return;

          showCustomSnackBar(
              context: context,
              message: "Failed to Withdraw Level",
              iconColor: Colors.pinkAccent);
        }
      });
    } catch (e) {
      logError(e.toString());
      setState(() {
        isWithdrawing = false;
      });
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
                "Withdraw",
                style: GoogleFonts.audiowide(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            HistoryWidget(
              history: history,
              onTap: withdraw,
              amount: availableGain,
              isWithdrawing: isWithdrawing,
            )
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
          } else if (index == 3) {
            context.go("/team");
          }
        },
      ),
    );
  }
}
