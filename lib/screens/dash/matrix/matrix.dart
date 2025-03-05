import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/model_bottom.dart';
import 'package:moon/widget/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  double availableGain = 0;
  bool isPurchasing = false;

  Color primaryColor = Colors.orange;
  Map<String, dynamic> teamData = {};
  Map<String, dynamic> userData = {};
  List<double> levels = [];
  String userAddress = "";
  int index = 2;
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
    getColor();
    getUserAddress();
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

  Future<void> purchase(index, isOpen) async {
    try {
      final lvl = index + 1;

      if (lvl > level + 1) {
        log("$lvl and $level");
        showCustomSnackBar(
            context: context,
            message: "Previous level not activated",
            iconColor: Colors.red);
        return;
      }
      if (isOpen) {
        showCustomSnackBar(
            context: context,
            message: "Already Purchased",
            iconColor: Colors.orange);
        return;
      }
      showModelBottomSheet(
          colors: colors,
          context: context,
          amount: levels[index].toString(),
          actionName: "Level Purchase",
          termes:
              "By purchasing the level ${index + 1} at ${levels[index]} BNB, you accept the terms and conditions of work of moon Bnb and are aware of its operation.",
          to: "0xeA292baCc8801728152b3273161a8800E07Fc57C",
          onContinue: () async {
            Navigator.pop(context);
            setState(() {
              isPurchasing = true;
            });

            final manager = MoonContractManager();
            final result = await manager.purchase(lvl);
            if (result) {
              setState(() {
                level = lvl;
                isPurchasing = false;
              });
              if (!mounted) return;
              showCustomSnackBar(
                  context: context,
                  message: "Level Purchased Successfully",
                  iconColor: Colors.greenAccent);
            } else {
              setState(() {
                isPurchasing = false;
              });
              if (!mounted) return;

              showCustomSnackBar(
                  context: context,
                  message: "Failed to Purchase Level",
                  iconColor: Colors.pinkAccent);
            }
          });
    } catch (e) {
      logError(e.toString());
      setState(() {
        isPurchasing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.85;
    return Scaffold(
        backgroundColor: colors.primaryColor,
        appBar: TopBar(
          colors: colors,
          primaryColor: Color(0XFF0D0D0D),
          secondaryColor: Colors.white.withOpacity(0.6),
          address: userAddress,
          changeColor: changeColor,
          path: "/main",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                  width: boxSize,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "M50 ${AppLocale.totalEarningsText.getString(context)}",
                          style: GoogleFonts.roboto(
                            color: colors.textColor.withOpacity(0.8),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Skeletonizer(
                          enabled: isLoading,
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "$amount BNB",
                              style: GoogleFonts.audiowide(
                                color: primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: colors.textColor.withOpacity(0.1),
                      )
                    ],
                  )),
              Skeletonizer(
                enabled: isLoading,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    width: boxSize,
                    decoration: BoxDecoration(
                        color: colors.secondaryColor,
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
                                    "$availableGain",
                                    style: GoogleFonts.audiowide(
                                        color: colors.textColor,
                                        fontSize: width < 389 ? 14 : 18),
                                  ),
                                  Text(
                                      AppLocale.GlobalGainText.getString(
                                          context),
                                      style:
                                          GoogleFonts.exo(
                                              color: colors.textColor
                                                  .withOpacity(0.7),
                                              fontSize: 16))
                                ],
                              ),
                              Spacer(),
                              SizedBox(
                                width: width * 0.27,
                                height: 38,
                                child: ElevatedButton(
                                    onPressed: () {
                                      context.go("/withdraw");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.textColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocale.giftText.getString(context),
                                          style: GoogleFonts.exo2(
                                            fontSize: width < 389 ? 13 : 18,
                                            fontWeight: FontWeight.bold,
                                            color: colors.secondaryColor
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          LucideIcons.gift,
                                          color: colors.primaryColor,
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Skeletonizer(
                enabled: isLoading,
                child: Container(
                  width: boxSize,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    AppLocale.packagesText.getString(context),
                    style: GoogleFonts.audiowide(
                        color: colors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: boxSize,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(12, (index) {
                    final bool isOpen = index < level;
                    return Skeletonizer(
                        enabled: isLoading,
                        child: Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: colors.textColor
                                                .withOpacity(0.1))),
                                    color: colors.secondaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    )),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/bnb/b3.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${levels.isNotEmpty ? levels[index] : 0} BNB",
                                        style: GoogleFonts.roboto(
                                            color: colors.textColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {
                                    purchase(index, isOpen);
                                  },
                                  child: isPurchasing && index + 1 == level + 1
                                      ? Container(
                                          margin: const EdgeInsets.all(20),
                                          child: CircularProgressIndicator(
                                            color: colors.textColor,
                                          ),
                                        )
                                      : Container(
                                          child: Icon(
                                            isOpen
                                                ? LucideIcons.toggleRight
                                                : LucideIcons.toggleLeft,
                                            color: isOpen
                                                ? colors.themeColor
                                                : Colors.orange,
                                            size: 80,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 38,
                                child: ElevatedButton(
                                    onPressed: () {
                                      purchase(index, isOpen);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.grayColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          isOpen
                                              ? AppLocale.workingText
                                                  .getString(context)
                                              : AppLocale.purchaseText
                                                  .getString(context),
                                          style: GoogleFonts.exo2(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          isOpen
                                              ? Icons.check_circle
                                              : LucideIcons.shoppingCart,
                                          color: Colors.orange,
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ));
                  }),
                ),
              )
            ],
          ),
        ));
  }
}
