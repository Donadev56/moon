import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfitWidget extends StatelessWidget {
  final String title;
  final String totalAmount;
  final String dailyAmount;
  final String imageUrl;
  const ProfitWidget(
      {super.key,
      required this.title,
      required this.totalAmount,
      required this.dailyAmount,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.415,
        padding: const EdgeInsets.all(13),
        height: 102,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
            color: Color(0XFF212121),
            borderRadius: BorderRadius.circular(15)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.exo(
                    color: const Color.fromARGB(184, 255, 255, 255)),
              ),
              Text(
                totalAmount,
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
                    dailyAmount,
                    style: GoogleFonts.exo2(
                        color: const Color.fromARGB(188, 255, 255, 255)),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
