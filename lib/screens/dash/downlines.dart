import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/downlines_list.dart';
import 'package:moon/widget/page_manager_app_bar.dart';
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
  bool isPreviewMode = false;

  Map<String, dynamic> userData = {};

  String userAddress = "";
  int index = 3;

  AppColors colors = AppColors(
      primaryColor: Color(0XFF0D0D0D),
      themeColor: Colors.greenAccent,
      greenColor: Colors.greenAccent,
      secondaryColor: Color(0XFF121212),
      grayColor: Color(0XFF353535),
      textColor: Colors.white,
      redColor: Colors.pinkAccent);
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
              iconColor: colors.themeColor);
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
      backgroundColor: colors.primaryColor,
      appBar: PageManagerTopBar(
        colors: colors,
        isPreviewMode: isPreviewMode,
        path: "/dashboard",
        changeColor: changeColor,
        address: userAddress,
        primaryColor: colors.primaryColor,
        secondaryColor: colors.textColor,
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
                            colors: colors,
                            imageUrl: "assets/image/32.png",
                            title: AppLocale.totalDirectText.getString(context),
                            totalAmount:
                                "${teamData["directDownlinesCount"] ?? 0}",
                            dailyAmount: "0"),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        ProfitWidget(
                            colors: colors,
                            imageUrl: "assets/image/31.png",
                            title: AppLocale.totalTeamText.getString(context),
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
                    AppLocale.partnersText.getString(context),
                    style: GoogleFonts.audiowide(
                        color: colors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                DownlinesListWidget(colors: colors, downlines: downlines),
              ],
            )),
      ),
    );
  }
}
