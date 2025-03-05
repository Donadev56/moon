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
import 'package:moon/utils/register.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/model_bottom.dart';
import 'package:moon/widget/snackbar.dart';

class AuthScreen extends StatefulWidget {
  final String? ref;

  const AuthScreen({super.key, this.ref});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

final List<Map<String, dynamic>> options = [
  {"title": "Home ", "icon": Icons.home},
  {"title": "Registration ", "icon": LucideIcons.logIn},
  {"title": "Login ", "icon": Icons.login},
];

class _AuthScreenState extends State<AuthScreen> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  String sponsorID = "";
  String userName = "";
  String userAddress = "";

  Map<String, dynamic> sponsorData = {};
  bool isRegistering = false;
  late TextEditingController _textEditingController;
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

  Future<void> getUserAddress() async {
    try {
      final web3 = Web3Manager();
      String address = await web3.getAddress();
      if (address.isNotEmpty) {
        setState(() {
          userAddress = address;
        });
        if (!mounted) return;
        showCustomSnackBar(
            context: context,
            icon: Icons.check_circle,
            message: "Address Connected ${address.substring(0, 4)} ...",
            iconColor: Colors.greenAccent);
      } else {
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            message: "Address not found",
            iconColor: Colors.pinkAccent);
      }
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(
          context: context,
          message: e.toString(),
          iconColor: Colors.pinkAccent);
    }
  }

  Future<void> registration() async {
    try {
      Navigator.pop(context);
      setState(() {
        isRegistering = true;
      });

      log('registering user');
      if (sponsorID.isEmpty || userAddress.isEmpty || userName.isEmpty) {
        // close the  modal
        showCustomSnackBar(
            context: context,
            message: "All fields are required",
            iconColor: Colors.pinkAccent);
        setState(() {
          isRegistering = false;
        });

        return;
      }

      final regManager = RegistrationManager();

      final isReg = await regManager.isRegistered(userAddress);
      if (isReg) {
        setState(() {
          isRegistering = false;
        });
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            icon: Icons.error,
            message: "User already registered",
            iconColor: Colors.red);
        context.go('/main');

        return;
      }
      final success = await regManager.register(sponsorID, userName);
      if (success) {
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            icon: Icons.check_circle,
            message: "Registration Successful",
            iconColor: Colors.greenAccent);

        setState(() {
          sponsorID = "";
          userName = "";
        });
        if (!mounted) return;
        context.go('/dashboard');
      } else {
        setState(() {
          isRegistering = false;
        });
        if (!mounted) return;

        showCustomSnackBar(
            context: context,
            icon: Icons.error,
            message: "Registration Failed",
            iconColor: Colors.red);
      }
    } catch (e) {
      logError(e.toString());
      setState(() {
        isRegistering = false;
      });

      if (!mounted) return;
      Navigator.pop(context);
      showCustomSnackBar(
          context: context,
          message: e.toString(),
          iconColor: Colors.pinkAccent);
    }
  }

  @override
  void initState() {
    super.initState();
    getSavedTheme();
    getUserAddress();

    _textEditingController = TextEditingController();

    if (widget.ref != null) {
      setState(() {
        final String ref = widget.ref!;
        sponsorID = ref;
        _textEditingController.text = sponsorID;
        getUserdataWithAddress(ref);
      });
    }
  }

  Future<void> getUserdataWithAddress(String id) async {
    try {
      final regManager = RegistrationManager();
      final addr = await regManager.getSponsorAddress(int.parse(id));
      if (addr.isNotEmpty && addr.length > 30) {
        final data = await regManager.getUserInfo(addr);
        log(json.encode(data).toString());
        if (data.isNotEmpty) {
          setState(() {
            sponsorData = data;
          });
        }
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                    color: colors.secondaryColor),
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
                              color: Color(0XFF0D0D0D),
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
                                          color: colors.textColor),
                                      fillColor: colors.secondaryColor,
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
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 25),
                      child: Align(
                        alignment: isArabic
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocale.registerInText.getString(context),
                              style: GoogleFonts.audiowide(
                                  color: colors.textColor, fontSize: 25),
                            ),
                            Text(
                              "MoonBNB Project",
                              style: GoogleFonts.audiowide(
                                  color: Colors.orange,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: isArabic
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, top: 10, bottom: 5),
                        child: Text(
                          AppLocale.regDescText.getString(context),
                          style: GoogleFonts.exo2(
                              color: colors.textColor.withOpacity(0.5)),
                        ),
                      ),
                    )
                  ],
                ),
                if (sponsorData.isNotEmpty)
                  Container(
                    width: width * 0.65,
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Text(
                          "${AppLocale.SponsorText.getString(context)} ${AppLocale.nameText.getString(context)}:",
                          style: GoogleFonts.audiowide(color: colors.textColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          sponsorData["userData"]["name"],
                          style:
                              GoogleFonts.audiowide(color: colors.themeColor),
                        )
                      ],
                    ),
                  ),
                Form(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: width * 0.65,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 0, bottom: 10),
                      child: Text(
                        AppLocale.nameText.getString(context),
                        style: GoogleFonts.audiowide(
                            color: colors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.6),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            userName = value;
                          });
                        },
                        cursorColor: colors.themeColor,
                        style: GoogleFonts.exo(color: colors.textColor),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.exo(color: colors.textColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: colors.textColor),
                              borderRadius: BorderRadius.circular(0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: colors.textColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: colors.grayColor.withOpacity(0.4)),
                          ),
                          labelText: AppLocale.NickNameText.getString(context),
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.65,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        AppLocale.SponsorText.getString(context),
                        style: GoogleFonts.audiowide(
                            color: colors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.6),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingController,
                        onChanged: (value) async {
                          setState(() {
                            sponsorID = value;
                          });
                          await getUserdataWithAddress(sponsorID);
                        },
                        cursorColor: colors.themeColor,
                        style: GoogleFonts.exo(color: colors.textColor),
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.exo(color: colors.textColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: colors.textColor),
                              borderRadius: BorderRadius.circular(0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: colors.textColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: colors.grayColor.withOpacity(0.4)),
                          ),
                          labelText: AppLocale.SponsorText.getString(context),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    !isRegistering
                        ? ConstrainedBox(
                            constraints: BoxConstraints(minWidth: width * 0.6),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (sponsorID.isEmpty ||
                                      userAddress.isEmpty ||
                                      userName.isEmpty) {
                                    showCustomSnackBar(
                                        context: context,
                                        message: "All fields are required",
                                        iconColor: Colors.pinkAccent);
                                    return;
                                  }
                                  showModelBottomSheet(
                                      colors: colors,
                                      context: context,
                                      amount: "0.0003",
                                      actionName: "Registration",
                                      termes:
                                          "By accepting this request you accept the terms and conditions of work to join Moon BNB and its community.",
                                      to: "0xC4A39C048177A339a3C46759B89a9eC01c56407a",
                                      onContinue: () async {
                                        await registration();
                                      });
                                },
                                child: Text(
                                  AppLocale.registerText.getString(context),
                                  style:
                                      GoogleFonts.exo2(color: colors.textColor),
                                )),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: colors.textColor,
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: Container(
                        width: width * 0.63,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocale.alreadyRegistered.getString(context),
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            color: colors.textColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
