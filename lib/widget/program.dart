import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';

typedef OnPreviewTap = void Function();

class ProgramWidjet extends StatelessWidget {
  final Color color;
  final AppColors colors;
  final String name;
  final double amount;
  final int level;
  final String imageString;
  final OnPreviewTap onPreviewTap;
  final String previewText;
  final double width;

  const ProgramWidjet({
    super.key,
    required this.color,
    required this.imageString,
    required this.name,
    required this.amount,
    required this.level,
    required this.onPreviewTap,
    required this.previewText,
    required this.width,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imageString), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20),
              color: colors.secondaryColor),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(
                      20,
                    ),
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8,
                    sigmaY: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(
                              20,
                            ),
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7)),
                        color: color.withOpacity(0.1)),
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.exo(
                              color: colors.textColor.withOpacity(0.7),
                              fontSize: 18),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "$amount BNB",
                              style: GoogleFonts.exo2(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                  fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Wrap(
                children: List.generate(12, (index) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: index < level ? color : colors.grayColor,
                        borderRadius: BorderRadius.circular(10)),
                    width: 30,
                    height: 30,
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      onPreviewTap();
                    },
                    child: SizedBox(
                        width: width * 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(35)),
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              previewText,
                              style: GoogleFonts.exo2(
                                color: colors.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
