import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/moon.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/events.dart';
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

class _DashBoardScreenState extends State<DashBoardScreen> {
  int level = 0;
  double amount = 0;
  String name = "";
  String link = "https://moonbnb.pro/#/register?ref=";
  String defaultImage = "https://moonbnb.pro/a.webp";
  Uint8List? byteImage ;
  bool isByteImageAvailable = false;
  bool isLoading = true;
  int userId = 0;
  int joiningDate = 0;

  int totalUsers = 0;
  Color primaryColor = Colors.orange;
  Map<String, dynamic> teamData = {};
  Map<String, dynamic> moonData = {};

  Map<String, dynamic> userData = {};
  final List<ContractEvents> events = [];

  String userAddress = "";
  int index = 2;

  @override
  void initState() {
    super.initState();
    getColor();

    getUserAddress();
    getEvents();
    getMoonEvents();
    getUsersCount();
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
            events.add(
              ContractEvents(
                icon: FeatherIcons.user,
                id: (event["id"]).toString(),
                name: event["name"],
                iconColor: Colors.greenAccent,
                time:
                    '${(minutesElapsed(event["time"])) > 60 ? 60 : (minutesElapsed(event["time"]))} minutes',
              ),
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
            events.add(
              ContractEvents(
                icon: FeatherIcons.user,
                id: (event["id"]).toString(),
                name: event["name"],
                iconColor: Colors.greenAccent,
                time:
                    '${(minutesElapsed(event["time"])) > 60 ? 60 : (minutesElapsed(event["time"]))} minutes',
              ),
            );
          }
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
Future<void> getCurrentImage (addr) async {
  try {
    final url = Uri.parse("https://chat.sauraya.com/moon/getImage/$addr");
    final usrDataUrl = Uri.parse("https://chat.sauraya.com/moon/getUserData/$addr");
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double boxSize = width * 0.85;

    return Scaffold(
      backgroundColor: Color(0XFF0D0D0D),
      appBar: TopBar(
        path: "/",
        changeColor: changeColor,
        address: userAddress,
        primaryColor: Color(0XFF0D0D0D),
        secondaryColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg/blur_white_copy.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0XFF212121),
                ),
                margin: const EdgeInsets.only(top: 20),
                width: boxSize,
                height: 285,
                child: Column(
                  children: [
                    Skeletonizer(
                      enabled: isLoading,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: isByteImageAvailable ? Image.memory(byteImage!, width: 120 , height: 120 ,
                            fit: BoxFit.cover,)  : Image.asset(
                             "assets/image/a.webp",
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.exo2(
                                          color: Colors.white,
                                          fontSize: width > 400 ? 25 : 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        FeatherIcons.edit3,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0XFF353535)),
                                  child: Text(
                                    "ID ${userId.toString()}",
                                    style: GoogleFonts.exo2(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "Sponsor Id : ${userData["uplineCountID"]}",
                                      style: GoogleFonts.exo2(
                                          color: const Color.fromARGB(
                                              138, 255, 255, 255),
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(dateConverter(joiningDate),
                                    style: GoogleFonts.exo2(
                                        color: Colors.white, fontSize: 12))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: const Color.fromARGB(22, 158, 158, 158),
                      thickness: 2,
                    ),
                    Skeletonizer(
                        enabled: isLoading,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Personal Link",
                                  style: GoogleFonts.exo2(
                                      color: Colors.white, fontSize: 17)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Invite new freinds using your personal link",
                                  style: GoogleFonts.exo2(
                                      color: const Color.fromARGB(
                                          138, 255, 255, 255),
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
                                          color: Color(0XFF353535),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${link.substring(0, 17)}...",
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    208, 255, 255, 255)),
                                          ),
                                          Spacer(),
                                          TextButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                    ClipboardData(text: link));
                                                showCustomSnackBar(
                                                    context: context,
                                                    message: "Link copied",
                                                    icon: Icons.check_circle,
                                                    iconColor:
                                                        Colors.greenAccent);
                                              },
                                              child: Text(
                                                "Copy",
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        227, 255, 255, 255)),
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
                                        color: Color(0XFF353535),
                                        child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular((50)),
                                                onTap: () {},
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.share,
                                                      color: Colors.white,
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
                            image: AssetImage('assets/image/bnb.png'),
                            fit: BoxFit.cover),
                        color: Color(0XFF212121),
                        border: Border(
                          bottom: BorderSide(color: primaryColor, width: 3),
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Profit",
                            style: GoogleFonts.exo(
                                color:
                                    const Color.fromARGB(184, 255, 255, 255)),
                          ),
                          Text(
                            "$amount BNB",
                            style: GoogleFonts.exo2(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: const Color.fromARGB(177, 255, 255, 255),
                                size: 17,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "0 BNB",
                                style: GoogleFonts.exo2(
                                    color: const Color.fromARGB(
                                        188, 255, 255, 255)),
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
                        imageUrl: "assets/image/32.png",
                        title: "Total Direct",
                        totalAmount: "${teamData["directDownlinesCount"] ?? 0}",
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
                      color: Color(0XFF212121),
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
                          "People joined after you",
                          style: GoogleFonts.exo(
                              color: const Color.fromARGB(184, 255, 255, 255)),
                        ),
                        Text(
                          "${totalUsers - userId}",
                          style: GoogleFonts.exo2(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: const Color.fromARGB(177, 255, 255, 255),
                              size: 17,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "0",
                              style: GoogleFonts.exo2(
                                  color:
                                      const Color.fromARGB(188, 255, 255, 255)),
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
                  "Programs",
                  style: GoogleFonts.audiowide(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ),
            Container(
              width: boxSize / 2.05,
              padding: const EdgeInsets.all(4),
            ),
            Skeletonizer(
              enabled: isLoading,
              child: ProgramWidjet(
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
            SizedBox(
              height: 15,
            ),
            Skeletonizer(
              enabled: isLoading,
              child: ProgramWidjet(
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
                imageString: "assets/bg/37.png",
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Skeletonizer(
              enabled: isLoading,
              child: Container(
                width: boxSize,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Events",
                  style: GoogleFonts.audiowide(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ),
            EventsWidget(events: events),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        primaryColor: primaryColor,
        currentIndex: 2,
        onTap: (index) {
          if (index == 3) {
            context.go("/team");
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
