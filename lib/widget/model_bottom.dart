import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showModelBottomSheet(BuildContext context, String amount,
    String actionName, String termes, String to, VoidCallback onContinue) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: height * 0.55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Color(0XFF212121)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0XFF171717),
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
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text("op BNB",
                                  style: GoogleFonts.exo(
                                      color: const Color.fromARGB(
                                          142, 255, 255, 255),
                                      fontSize: 16))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0XFF171717),
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actionName,
                            style: GoogleFonts.audiowide(
                                color: Colors.white, fontSize: 17),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text("To",
                                  style: GoogleFonts.exo(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 12)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "${to.substring(0, 4)}...${to.substring(0, 4)}",
                                  style: GoogleFonts.exo(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0XFF171717),
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Terms and conditions",
                            style: GoogleFonts.audiowide(
                                color: Colors.white, fontSize: 17),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(termes,
                              style: GoogleFonts.exo(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      margin: const EdgeInsets.all(5),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            // close the modal
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 1, color: Colors.pinkAccent),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style:
                                    GoogleFonts.exo(color: Colors.pinkAccent),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 150,
                      margin: const EdgeInsets.all(5),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: onContinue,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                "Continue",
                                style:
                                    GoogleFonts.exo(color: Color(0XFF0D0D0D)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}
