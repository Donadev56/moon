import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/types/types.dart';
import 'package:moon/widget/colors_dialog.dart';

typedef ChangeModelType = void Function(String model);
typedef ChangeColor = void Function(String color);

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String address;
  final String path;
  final AppColors colors;
  final ChangeColor changeColor;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  TopBar({
    super.key,
    required this.path,
    required this.primaryColor,
    required this.secondaryColor,
    required this.address,
    required this.changeColor,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AppBar(
      surfaceTintColor: colors.grayColor,
      backgroundColor: colors.primaryColor,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          context.go(path);
        },
        icon: Icon(
          Icons.arrow_back,
          color: colors.textColor.withOpacity(0.5),
        ),
        color: secondaryColor,
      ),
      title: Row(
        children: [
          TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Container(
                    width: width * 0.4,
                    child: width < 345
                        ? null
                        : Text(
                            "Moon BNB",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.audiowide(
                              color: secondaryColor,
                              fontSize: width > 370 ? 19 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                ],
              )),
        ],
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
              color: colors.secondaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: address));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.wallet,
                        color: colors.textColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      address.isNotEmpty
                          ? Text(
                              "${address.substring(0, 4)}...${address.substring(38, address.length)}",
                              style: TextStyle(color: colors.textColor),
                            )
                          : Text(
                              "Disconnected",
                              style: TextStyle(color: colors.textColor),
                            )
                    ],
                  ),
                )),
          ),
        ),
        PopupMenuButton(
          color: colors.grayColor,
          icon: Icon(CupertinoIcons.ellipsis_vertical),
          iconColor: secondaryColor,
          onSelected: (value) async {
            if (value == "color") {
            } else if (value.toLowerCase() == "Lang".toLowerCase()) {
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
                              style:
                                  GoogleFonts.roboto(color: colors.textColor),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search languages...",
                                  hintStyle: GoogleFonts.roboto(
                                      color: colors.textColor.withOpacity(0.3)),
                                  fillColor:
                                      colors.secondaryColor.withOpacity(0.1),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(30)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: colors.themeColor),
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView.builder(
                                itemCount:
                                    _localization.supportedLanguageCodes.length,
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
                                      color: languageCode.contains(currentLang)
                                          ? colors.themeColor.withOpacity(0.1)
                                          : Colors.transparent,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        onTap: () {
                                          _localization.translate(languageCode);
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
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: colors.textColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(color: colors.textColor),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'color',
              child: Row(
                children: [
                  Icon(
                    Icons.color_lens,
                    color: colors.textColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change color',
                    style: TextStyle(color: colors.textColor),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'Lang',
              child: Row(
                children: [
                  Icon(
                    LucideIcons.languages,
                    color: colors.textColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change Language',
                    style: TextStyle(color: colors.textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
