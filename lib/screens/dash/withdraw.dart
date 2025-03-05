import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/model_bottom.dart';
import 'package:moon/widget/page_manager_app_bar.dart';
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
  final FlutterLocalization _localization = FlutterLocalization.instance;

  String name = "";
  String link = "https://moonbnb.app/#/register?ref=";
  bool isLoading = true;

  List<double> levels = [];
  String userAddress = "";
  int index = 0;
  bool isWithdrawing = false;
  double availableGain = 0;
  bool isPreviewMode = false;
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
  void initState() {
    super.initState();
    getLevels();
    getSavedTheme();

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
          final time = inDays(hist["actionDate"]);
          final amount = (hist["actionAmount"] / 1e18);

          final from = hist["actionFrom"];
          final idResult = await regManager.getUserInfo(from);
          if (idResult.isNotEmpty) {
            final userData = idResult["userData"];
            log("userData $userData");
            final id = ("${userData["countId"]}");
            log("user id: $id");
            final HistoryData newHistory = HistoryData(
                id: id,
                name: AppLocale.withdrawText.getString(context),
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
          colors: colors,
          context: context,
          amount: availableGain.toString(),
          actionName: "Withdraw of $availableGain BNB",
          termes:
              "You are about to withdraw $availableGain from your Global earnings and you will receive the amount directly in $userAddress",
          to: userAddress,
          onContinue: () async {
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
    bool isArabic = _localization.currentLocale!.languageCode.contains("ar");

    double boxSize = width * 0.9;
    return Scaffold(
      backgroundColor: colors.primaryColor,
      appBar: PageManagerTopBar(
        colors: colors,
        isPreviewMode: isPreviewMode,
        path: "/dashboard",
        changeColor: (data) {},
        address: userAddress,
        primaryColor: colors.primaryColor,
        secondaryColor: colors.textColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: boxSize,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  AppLocale.withdrawText.getString(context),
                  style: GoogleFonts.audiowide(
                      color: colors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              HistoryWidget(
                colors: colors,
                isArabic: isArabic,
                history: history,
                onTap: withdraw,
                amount: availableGain,
                isWithdrawing: isWithdrawing,
              )
            ],
          ),
        ),
      ),
    );
  }
}
