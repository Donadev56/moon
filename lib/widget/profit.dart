import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/types/types.dart';

class ProfitWidget extends StatelessWidget {
  final String title;
  final String totalAmount;
  final String dailyAmount;
  final String imageUrl;
  final AppColors colors;
  const ProfitWidget(
      {super.key,
      required this.title,
      required this.totalAmount,
      required this.dailyAmount,
      required this.imageUrl,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.415,
        padding: const EdgeInsets.all(13),
        height: 102,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  imageUrl,
                ),
                scale: 0.2),
            color: colors.secondaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    GoogleFonts.exo(color: colors.textColor.withOpacity(0.8)),
              ),
              Text(
                totalAmount,
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
                    dailyAmount,
                    style: GoogleFonts.exo2(
                        color: colors.textColor.withOpacity(0.7)),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
