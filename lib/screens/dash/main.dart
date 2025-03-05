import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/screens/dash/page_manager.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/events.dart';
import 'package:moon/widget/func/show_preview_dialog.dart';
import 'package:moon/widget/page_manager_app_bar.dart';
import 'package:moon/widget/poolUsersList.dart';
import 'package:moon/widget/profit.dart';
import 'package:moon/widget/program.dart';
import 'package:moon/widget/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({
    super.key,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  int level = 0;
  double amount = 0;
  String name = "";
  String link = "https://moonbnb.pro/#/register?ref=";
  String defaultImage = "https://moonbnb.pro/a.webp";
  Uint8List? byteImage;
  bool isByteImageAvailable = false;
  bool isLoading = true;
  int userId = 0;
  int joiningDate = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String timerRemainingTime = "";
  Uint8List? foundedUserImage;
  bool isPreviewMode = false;
  final List<String> poolLevel = [
    "level 1",
    "level 2",
    "level 3",
    "level 4",
    "level 5",
    "level 6",
    "level 7",
    "level 8",
    "level 9",
    "level 10",
    "level 11",
    "level 12",
  ];
  int dropdownValue = 1;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  int totalUsers = 0;
  Map<String, dynamic> teamData = {};
  Map<String, dynamic> moonData = {};
  late TabController tabController;
  String searchingAddress = "";

  Map<String, dynamic> userData = {};
  UserData? searchingUserData;

  final List<ContractEvents> purchaseEvents = [];
  final List<ContractEvents> regEvents = [];
  final regManager = RegistrationManager();

  List<HistoryData> poolUsers = [];

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
    getSavedTheme();

    getColor();
    getUserAddress();
    getEvents();
    getMoonEvents();
    getUsersCount();
    getTime();
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> reInit() async {
    getColor();

    await getUserAddress();
    await getEvents();
    await getMoonEvents();
    await getUsersCount();
    getTime();
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
            moonData = data;
            amount = moonData["totalIncome"] / 1e18;
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

  Future<void> getEvents() async {
    try {
      log("getting events...");
      final regManager = RegistrationManager();
      final result = await regManager.getEvents();
      if (result.isNotEmpty) {
        setState(() {
          log(result.toString());
          final contractEvents = result["events"];
          for (final event in json.decode(contractEvents).reversed.toList()) {
            regEvents.add(
              ContractEvents(
                  icon: FeatherIcons.user,
                  id: (event["id"]).toString(),
                  name: AppLocale.userJoinedText.getString(context),
                  iconColor: Colors.greenAccent,
                  time: (minutesElapsed(event["time"]))),
            );
          }
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  Future<void> getMoonEvents() async {
    try {
      log("getting events...");
      final regManager = MoonContractManager();
      final result = await regManager.getEvents();
      if (result.isNotEmpty) {
        setState(() {
          log(result.toString());
          final contractEvents = result["events"];
          for (final event in json.decode(contractEvents).reversed.toList()) {
            purchaseEvents.add(
              ContractEvents(
                  icon: FeatherIcons.user,
                  id: (event["id"]).toString(),
                  name: AppLocale.purchaseText.getString(context),
                  iconColor: Colors.greenAccent,
                  time: (minutesElapsed(event["time"]))),
            );
          }
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  void changeColor(String value) async {}

  void getColor() async {}

  Future<void> getUserAddress() async {
    try {
      final web3 = Web3Manager();

      String address = await web3.getAddress();
      final isPreview = await web3.isPreviewAddressAvailable();
      setState(() {
        isPreviewMode = isPreview;
      });
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
          getCurrentImage(userAddress);
        });
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getUsersInPool(int pool) async {
    try {
      setState(() {
        poolUsers = [];
      });
      final MoonContractManager manager = MoonContractManager();
      final result = await manager.getPoolUserAddresses(pool);
      final List<dynamic> addresses = result;
      for (final addr in addresses) {
        setState(() {
          poolUsers.add(HistoryData(
              id: "",
              name: addr,
              icon: Icons.person,
              iconColor: Colors.greenAccent,
              time: 0,
              amount: 0));
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  Future<void> getUserdataWithAddress(String addr) async {
    try {
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

  Future<UserData?> userdataWithAddress(String addr) async {
    try {
      if (addr.isNotEmpty && addr.length > 30) {
        final data = await regManager.getUserInfo(addr);
        log(json.encode(data).toString());
        if (data.isNotEmpty) {
          userData = data["userData"];
          final name = userData["name"];
          final userId = userData["countId"];
          final joiningDate = userData["joiningDate"];
          final UserData userFoundedData = UserData(
              name: name,
              userId: (userId).toString(),
              joiningDate: (joiningDate).toString(),
              address: addr);
          return userFoundedData;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      logError(e.toString());
      return null;
    }
  }

  String dateConverter(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((timestamp) * 1000);
    return dateTime.toString().split('T')[0];
  }

  int minutesElapsed(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(dateTime);

    return difference.inMinutes;
  }

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
          isByteImageAvailable = true;
        });
      }
      if (usrResponse.statusCode == 200) {
        final usrData = json.decode(usrResponse.body);
        setState(() {
          name = usrData["name"];
          log("Name :$name");
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  Future<Uint8List?> currentImage(addr) async {
    try {
      final url = Uri.parse("https://chat.sauraya.com/moon/getImage/$addr");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final bytes = base64Decode(response.body.split(',').last);
        return bytes;
      }
      return null;
    } catch (e) {
      logError(e.toString());
      return null;
    }
  }

  void getTime() {
    DateTime targetDate = DateTime(2025, 03, 12);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.isAfter(targetDate)) {
        log("Time's up");
        timer.cancel();
        setState(() {
          timerRemainingTime = "Event started";
        });
        return;
      }

      Duration difference = targetDate.difference(now);

      int days = difference.inDays;
      int hours = difference.inHours.remainder(24);
      int minutes = difference.inMinutes.remainder(60);
      int seconds = difference.inSeconds.remainder(60);

      setState(() {
        timerRemainingTime =
            "$days ${AppLocale.daysText.getString(context)} $hours ${AppLocale.hourText.getString(context)} $minutes ${AppLocale.minText.getString(context)} $seconds ${AppLocale.secondText.getString(context)}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.85;
    bool isArabic = _localization.currentLocale!.languageCode.contains("ar");
    final bool isDesktop = width > 724;

    return Scaffold(
      backgroundColor: colors.primaryColor,
      appBar: PageManagerTopBar(
        colors: colors,
        reInit: reInit,
        isPreviewMode: isPreviewMode,
        onSearchTap: () {
          showPreviewDialog(
            colors: colors,
            mounted: mounted,
            reInit: reInit,
            context: context,
            regManager: regManager,
            userdataWithAddress: userdataWithAddress,
            currentImage: currentImage,
          );
        },
        path: "/",
        changeColor: changeColor,
        address: userAddress,
        primaryColor: colors.primaryColor,
        secondaryColor: colors.textColor,
      ),
      body: RefreshIndicator(
        onRefresh: reInit,
        child: SingleChildScrollView(
          key: _refreshIndicatorKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(top: 20),
                  width: boxSize,
                  child: Column(
                    spacing: 10,
                    children: [
                      Skeletonizer(
                        enabled: isLoading,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: isByteImageAvailable
                                  ? Image.memory(
                                      byteImage!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/image/dog.jpg",
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  name.length > 10
                                      ? "${name.substring(0, 10)}..."
                                      : name,
                                  style: GoogleFonts.exo2(
                                      color: colors.textColor,
                                      fontSize: width > 400 ? 25 : 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (width > 350)
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PagesManagerView(pageIndex: 4),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      FeatherIcons.edit3,
                                      color: colors.textColor,
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            colors.themeColor.withOpacity(0.1)),
                                    child: Text(
                                      "${AppLocale.userIdDashText.getString(context)} ${userId.toString()}",
                                      style: GoogleFonts.exo2(
                                          color: colors.themeColor,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "${AppLocale.SponsorText.getString(context)}: ${userData["uplineCountID"]}",
                                        style: GoogleFonts.exo2(
                                            color: colors.textColor
                                                .withOpacity(0.5),
                                            fontSize: 16)),
                                  ),
                                  /* Container(
                                width: width * 0.3,
                                child: Text(dateConverter(joiningDate),
                                overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.exo2(
                                        color: Colors.white, fontSize: 12)),
                               )  */
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: colors.grayColor.withOpacity(0.3),
                        thickness: 2,
                      ),
                      Skeletonizer(
                          enabled: isLoading,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    AppLocale.PersonalLinkText.getString(
                                        context),
                                    style: GoogleFonts.exo2(
                                        color: colors.textColor, fontSize: 17)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    AppLocale.inviteText.getString(context),
                                    style: GoogleFonts.exo2(
                                        color:
                                            colors.grayColor.withOpacity(0.5),
                                        fontSize: 12)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width > 380
                                        ? width * 0.65
                                        : boxSize * 0.9,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      height: 50,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: colors.secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${link.substring(0, 17)}...",
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: colors.textColor
                                                      .withOpacity(0.7)),
                                            ),
                                            Spacer(),
                                            TextButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: link));
                                                  showCustomSnackBar(
                                                      context: context,
                                                      message: "Link copied",
                                                      icon: Icons.check_circle,
                                                      iconColor:
                                                          colors.themeColor);
                                                },
                                                child: Text(
                                                  AppLocale.copyText
                                                      .getString(context),
                                                  style: TextStyle(
                                                      color: colors.textColor
                                                          .withOpacity(0.5)),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  if (width > 380)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                          color: colors.grayColor,
                                          child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          (50)),
                                                  onTap: () {},
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.share,
                                                        color: colors.textColor,
                                                      ),
                                                    ),
                                                  )))),
                                    )
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Skeletonizer(
                  enabled: isLoading,
                  child: Container(
                      width: boxSize,
                      padding: const EdgeInsets.all(13),
                      height: 115,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/image/wa.png'),
                              fit: BoxFit.cover),
                          color: colors.secondaryColor,
                          border: Border(
                            bottom: BorderSide(
                                color: colors.primaryColor, width: 3),
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocale.totalProfitText.getString(context),
                              style: GoogleFonts.exo(
                                  color: colors.textColor.withOpacity(0.6)),
                            ),
                            Text(
                              "$amount BNB",
                              style: GoogleFonts.exo2(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                  fontSize: 25),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: colors.textColor.withOpacity(0.7),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "0 BNB",
                                  style: GoogleFonts.exo2(
                                      color: colors.textColor.withOpacity(0.6)),
                                )
                              ],
                            )
                          ],
                        ),
                      ))),
              SizedBox(
                height: 10,
              ),
              Skeletonizer(
                enabled: isLoading,
                child: SizedBox(
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
              SizedBox(
                height: 10,
              ),
              Skeletonizer(
                enabled: isLoading,
                child: Container(
                    width: boxSize,
                    padding: const EdgeInsets.all(13),
                    height: 110,
                    decoration: BoxDecoration(
                        color: colors.secondaryColor,
                        image: DecorationImage(
                            image: AssetImage("assets/bg/blur_white_copy.png"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(15)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.peopleJoinAfterYouText.getString(context),
                            style: GoogleFonts.exo(
                                color: colors.textColor.withOpacity(0.7)),
                          ),
                          Text(
                            "${totalUsers - userId}",
                            style: GoogleFonts.exo2(
                                fontWeight: FontWeight.bold,
                                color: colors.textColor,
                                fontSize: 25),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: colors.textColor.withOpacity(0.7),
                                size: 17,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "0",
                                style: GoogleFonts.exo2(
                                    color: colors.textColor.withOpacity(0.7)),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
              Skeletonizer(
                enabled: isLoading,
                child: Container(
                  width: boxSize,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    AppLocale.programsText.getString(context),
                    style: GoogleFonts.audiowide(
                        color: colors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
              ),
              Container(
                width: boxSize / 2.05,
                padding: const EdgeInsets.all(4),
              ),
              !isDesktop
                  ? Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: boxSize),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: ProgramWidjet(
                              colors: colors,
                              width: boxSize,
                              previewText:
                                  AppLocale.previewText.getString(context),
                              onPreviewTap: () {
                                context.go('/preview');
                              },
                              name: "M50",
                              level: level,
                              amount: amount,
                              color: Colors.blue,
                              imageString: "assets/bg/36.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: boxSize),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: ProgramWidjet(
                              colors: colors,
                              width: boxSize,
                              previewText: timerRemainingTime,
                              onPreviewTap: () {
                                showCustomSnackBar(
                                    context: context,
                                    message: "Not Available yet",
                                    icon: Icons.error,
                                    iconColor: Colors.pinkAccent);
                              },
                              name: "MX",
                              amount: 0,
                              level: 0,
                              color: Colors.orange,
                              imageString: "assets/bitcoin/bit2.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  : Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: boxSize / 2),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: ProgramWidjet(
                              colors: colors,
                              width: boxSize / 2,
                              previewText:
                                  AppLocale.previewText.getString(context),
                              onPreviewTap: () {
                                context.go('/preview');
                              },
                              name: "M50",
                              level: level,
                              amount: amount,
                              color: Colors.blue,
                              imageString: "assets/bg/36.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: boxSize / 2),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: ProgramWidjet(
                              colors: colors,
                              width: width / 2.5,
                              previewText: timerRemainingTime,
                              onPreviewTap: () {
                                showCustomSnackBar(
                                    context: context,
                                    message: "Not Available yet",
                                    icon: Icons.error,
                                    iconColor: Colors.pinkAccent);
                              },
                              name: "MX",
                              amount: 0,
                              level: 0,
                              color: Colors.orange,
                              imageString: "assets/bitcoin/bit2.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
              Skeletonizer(
                enabled: isLoading,
                child: Container(
                  width: boxSize,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    AppLocale.EventsText.getString(context),
                    style: GoogleFonts.audiowide(
                        color: colors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
              ),
              TabBar(
                  dividerColor: Colors.transparent,
                  controller: tabController,
                  labelColor: colors.textColor,
                  unselectedLabelColor: colors.textColor,
                  indicatorColor: colors.themeColor,
                  tabs: [
                    Tab(
                      child: Text(
                        AppLocale.registrationText.getString(context),
                        style: GoogleFonts.roboto(color: colors.textColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocale.purchaseText.getString(context),
                        style: GoogleFonts.roboto(color: colors.textColor),
                      ),
                    )
                  ]),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: boxSize,
                ),
                child: EventsWidget(
                  colors: colors,
                  isArabic: isArabic,
                  regEvents: regEvents,
                  tabController: tabController,
                  purchaseEvents: purchaseEvents,
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
