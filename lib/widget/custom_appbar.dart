import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/logger/logger.dart';

typedef ChangeModelType = void Function(String model);

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String address;

  const TopBar({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AppBar(
      surfaceTintColor: primaryColor,
      backgroundColor: primaryColor,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(FeatherIcons.alignLeft),
        color: secondaryColor,
      ),
      title: Row(
        children: [
          TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "Moon BNB",
                    style: GoogleFonts.audiowide(
                      color: secondaryColor,
                      fontSize: width > 370 ? 19 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
        ],
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(61, 33, 33, 33),
              borderRadius: BorderRadius.circular(30)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  log("taped");
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.wallet,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      address.isNotEmpty
                          ? Text(
                              "${address.substring(0, 4)}...${address.substring(0, 4)}",
                              style: TextStyle(color: Colors.white),
                            )
                          : Text(
                              "Disconnected",
                              style: TextStyle(color: Colors.white),
                            )
                    ],
                  ),
                )),
          ),
        ),
        PopupMenuButton(
          color: Colors.pinkAccent,
          icon: Icon(CupertinoIcons.ellipsis_vertical),
          iconColor: secondaryColor,
          onSelected: (value) async {},
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
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
