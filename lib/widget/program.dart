import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef OnPreviewTap = void Function();

class ProgramWidjet extends StatelessWidget {
  final Color color;
  final String name;
  final double amount;
  final int level;
  final String imageString;
  final OnPreviewTap onPreviewTap;

  const ProgramWidjet({
    super.key,
    required this.color,
    required this.imageString,
    required this.name,
    required this.amount,
    required this.level,
    required this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width * 0.85,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imageString), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20),
              color: Color(0XFF212121)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: color, width: 3),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(
                          20,
                        ),
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7)),
                    color: Color(0XFF181818)),
                child: Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.exo(
                          color: const Color.fromARGB(184, 255, 255, 255),
                          fontSize: 18),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "$amount BNB",
                          style: GoogleFonts.exo2(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ],
                    )
                  ],
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
                        color: index < level ? color : Color(0XFF353535),
                        borderRadius: BorderRadius.circular(10)),
                    width: 34,
                    height: 34,
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      onPreviewTap();
                    },
                    child: SizedBox(
                        width: 170,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 3, color: color),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              "Preview",
                              style: GoogleFonts.exo2(
                                color: Colors.white,
                                fontSize: 18,
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
