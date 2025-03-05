import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

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
  Uint8List? byteImage;
  bool isByteImageAvailable = false;
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
    getSavedTheme();
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
          getCurrentImage(userAddress);

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
    bool isArabic = _localization.currentLocale!.languageCode.contains("ar");

    return Scaffold(
        backgroundColor: colors.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: colors.primaryColor,
          actions: [
            Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colors.grayColor),
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
                                ? AppLocale.connectWalletText.getString(context)
                                : "${userAddress.substring(0, 4)}...${userAddress.substring(userAddress.length - 4, userAddress.length)}",
                            style:
                                GoogleFonts.audiowide(color: colors.textColor),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: colors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      context: context,
                      builder: (BuildContext ctx) {
                        return Container(
                          decoration: BoxDecoration(
                              color: colors.primaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  style: GoogleFonts.roboto(
                                      color: colors.textColor),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Search languages...",
                                      hintStyle: GoogleFonts.roboto(
                                          color: colors.textColor
                                              .withOpacity(0.3)),
                                      fillColor: Color(0XFF212121),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: colors.themeColor),
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                    itemCount: _localization
                                        .supportedLanguageCodes.length,
                                    itemBuilder: (BuildContext listCtx, index) {
                                      final currentLang = _localization
                                              .currentLocale?.languageCode ??
                                          "";
                                      final languageCode = _localization
                                          .supportedLanguageCodes[index];
                                      final countryCode = _localization
                                          .supportedLocales
                                          .toList()[index]
                                          .countryCode;
                                      return ColoredBox(
                                          color:
                                              languageCode.contains(currentLang)
                                                  ? colors.themeColor
                                                      .withOpacity(0.1)
                                                  : Colors.transparent,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(left: 15),
                                            onTap: () {
                                              _localization
                                                  .translate(languageCode);
                                              Navigator.pop(context);
                                            },
                                            title: Text(
                                              "$languageCode - $countryCode",
                                              style: GoogleFonts.roboto(
                                                  color: colors.textColor),
                                            ),
                                          ));
                                    }),
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: Icon(
                  LucideIcons.languages,
                  color: colors.textColor,
                ))
          ],
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Moon BNB",
              style:
                  GoogleFonts.audiowide(color: colors.textColor, fontSize: 18),
            ),
          ),
          backgroundColor: colors.primaryColor,
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: width * 0.8,
                  padding: const EdgeInsets.all(20),
                  height: 300,
                  decoration: BoxDecoration(
                      color: colors.secondaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
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
                      Column(
                        children: [
                          Container(
                              width: boxSize,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${AppLocale.nameText.getString(context)} :",
                                    style: GoogleFonts.exo2(
                                        color:
                                            colors.textColor.withOpacity(0.7),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: width * 0.5),
                                    child: Text(
                                      name.isNotEmpty ? name : "---",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  )
                                ],
                              )),
                          Container(
                              width: boxSize,
                              margin: const EdgeInsets.only(top: 0, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${AppLocale.userIdText.getString(context)} :",
                                    style: GoogleFonts.roboto(
                                        color:
                                            colors.textColor.withOpacity(0.7),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userId > 0 ? "$userId" : "---",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              )),
                          SizedBox(
                              width: boxSize,
                              child: Row(
                                children: [
                                  Text(
                                    "M50 ${AppLocale.teamText.getString(context)} :",
                                    style: GoogleFonts.roboto(
                                        color:
                                            colors.textColor.withOpacity(0.7),
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    name.isNotEmpty
                                        ? "${totalUsers - userId} "
                                        : "---",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.8,
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
                                  "$amount BNB",
                                  style: GoogleFonts.audiowide(
                                      color: colors.textColor, fontSize: 18),
                                ),
                                Text(
                                    "${AppLocale.totalEarningsText.getString(context)}",
                                    style: GoogleFonts.exo(
                                        color:
                                            colors.textColor.withOpacity(0.6),
                                        fontSize: 16))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: width * 0.80,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () async {
                      final regManager = RegistrationManager();
                      final isReg = await regManager.isRegistered(userAddress);
                      if (isReg) {
                        context.go('/main');
                      } else {
                        context.go('/register');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLocale.LoginText.getString(context),
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryColor,
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
                      AppLocale.dontHaveAnAccountText.getString(context),
                      style: GoogleFonts.exo2(
                        fontSize: 16,
                        color: colors.textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: colors.secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      child: Directionality(
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onTap: () {
                              launchUrl(Uri.parse(
                                  "https://download.moonbnb.app/app/download/"));
                            },
                            leading: Icon(
                              LucideIcons.walletMinimal,
                              color: colors.textColor,
                            ),
                            title: Text(
                              AppLocale.addWalletText.getString(context),
                              style:
                                  GoogleFonts.roboto(color: colors.textColor),
                            ),
                            subtitle: Text(
                              AppLocale.downloadWalletDescText
                                  .getString(context),
                              style: GoogleFonts.roboto(
                                  color: colors.textColor.withOpacity(0.2),
                                  fontSize: 10),
                            ),
                            trailing: Icon(
                              Icons.download,
                              color: colors.textColor,
                            ),
                          )),
                    ))
              ],
            ),
          ),
        ));
  }
}
