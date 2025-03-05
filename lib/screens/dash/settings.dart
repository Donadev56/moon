// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/widget/options.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  AppColors colors = AppColors(
      primaryColor: Color(0XFF0D0D0D),
      themeColor: Colors.greenAccent,
      greenColor: Colors.greenAccent,
      secondaryColor: Color(0XFF121212),
      grayColor: Color(0XFF353535),
      textColor: Colors.white,
      redColor: Colors.pinkAccent);
  final currentIndex = 4;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  Future<void> getSavedTheme() async {
    final manager = ColorsManager();
    final savedTheme = await manager.getDefaultTheme();
    setState(() {
      colors = savedTheme;
    });
  }

  @override
  void initState() {
    super.initState();
    getSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: colors.secondaryColor,
        backgroundColor: colors.primaryColor,
        title: Text(
          "Settings",
          style: GoogleFonts.roboto(
              color: colors.textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [
            CustomOptionWidget(
                backgroundColor: colors.secondaryColor,
                containerRadius: BorderRadius.circular(10),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                spaceName: "Profile",
                spaceNameStyle: GoogleFonts.roboto(color: colors.textColor),
                options: [
                  Option(
                      title: "Profile settings",
                      icon: Icon(
                        LucideIcons.user,
                        color: colors.textColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.textColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.textColor)),
                ],
                onTap: (index) {
                  if (index == 0) {
                    context.go("/profile");
                  }
                }),
            CustomOptionWidget(
                backgroundColor: colors.secondaryColor,
                containerRadius: BorderRadius.circular(10),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                spaceName: "preferences",
                spaceNameStyle: GoogleFonts.roboto(color: colors.textColor),
                options: [
                  Option(
                      title: "Change App colors",
                      icon: Icon(
                        LucideIcons.palette,
                        color: colors.textColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.textColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.textColor)),
                  Option(
                      title: "Language",
                      icon: Icon(
                        LucideIcons.languages,
                        color: colors.textColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.textColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.textColor),
                      subtitle: Text(
                        "English",
                        style: GoogleFonts.roboto(
                            color: colors.textColor.withOpacity(0.7)),
                      ))
                ],
                onTap: (index) {
                  if (index == 0) {
                    context.go("/settings/change_theme");
                  } else if (index == 1) {
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
                                        fillColor: colors.secondaryColor
                                            .withOpacity(0.1),
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
                                      itemBuilder:
                                          (BuildContext listCtx, index) {
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
                                            color: languageCode
                                                    .contains(currentLang)
                                                ? colors.themeColor
                                                    .withOpacity(0.1)
                                                : Colors.transparent,
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
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
                  }
                }),
            CustomOptionWidget(
                backgroundColor: colors.secondaryColor,
                containerRadius: BorderRadius.circular(10),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                spaceName: "Social Network",
                spaceNameStyle: GoogleFonts.roboto(color: colors.textColor),
                options: [
                  Option(
                      title: "Join telegram",
                      icon: Icon(
                        LucideIcons.send,
                        color: colors.textColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.textColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.textColor)),
                  Option(
                      title: "Join Whatsapp",
                      icon: Icon(
                        LucideIcons.messageCircle,
                        color: colors.textColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.textColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.textColor)),
                  Option(
                      title: "Customer service",
                      icon: Icon(
                        LucideIcons.headphones,
                        color: colors.textColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.textColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.textColor)),
                ],
                onTap: (index) {
                  if (index == 0) {
                    launchUrl(Uri.parse("https://t.me/eternalprotocol"));
                  } else if (index == 1) {
                    launchUrl(Uri.parse(
                        "https://www.whatsapp.com/channel/0029Vb2TpR9HrDZWVEkhWz21"));
                  } else if (index == 2) {
                    launchUrl(Uri.parse("mailto:team@moonbnb.pro"));
                  }
                }),
            CustomOptionWidget(
                backgroundColor: colors.redColor.withOpacity(0.025),
                containerRadius: BorderRadius.circular(10),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                spaceName: "Others",
                spaceNameStyle: GoogleFonts.roboto(color: colors.textColor),
                options: [
                  Option(
                      title: "Logout",
                      icon: Icon(
                        LucideIcons.logOut,
                        color: colors.redColor,
                      ),
                      trailing: Icon(
                        LucideIcons.chevronRight,
                        color: colors.redColor,
                      ),
                      color: colors.textColor,
                      titleStyle: GoogleFonts.roboto(color: colors.redColor)),
                ],
                onTap: (index) {
                  if (index == 0) {
                    context.go("/");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
