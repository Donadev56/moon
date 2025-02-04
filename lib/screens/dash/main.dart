import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/widget/bottom.dart';
import 'package:moon/widget/custom_appbar.dart';
import 'package:moon/widget/events.dart';
import 'package:moon/widget/profit.dart';
import 'package:moon/widget/program.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final int level = 0;
  final int amount = 0;
  final List<ContractEvents> events = [
    ContractEvents(
        icon: LucideIcons.wallet,
        id: "233",
        name: "User Joined",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: Icons.monetization_on,
        id: "2",
        name: "Upgrade",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: LucideIcons.wallet,
        id: "134",
        name: "User Joined",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: Icons.monetization_on,
        id: "233",
        name: "Upgrade",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: LucideIcons.wallet,
        id: "23",
        name: "User Joined",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: Icons.monetization_on,
        id: "2343",
        name: "Upgrade",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: LucideIcons.wallet,
        id: "2334",
        name: "User Joined",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
    ContractEvents(
        icon: Icons.monetization_on,
        id: "533",
        name: "Upgrade",
        iconColor: Colors.greenAccent,
        time: "2 minutes"),
  ];

  String userAddress = "";
  int index = 2;

  @override
  void initState() {
    super.initState();
    getUserAddrss();
  }

  void getUserAddrss() async {
    try {
      final web3 = Web3Manager();
      await web3.getProvider();

      String address = await web3.getAddress();
      if (address.isEmpty) {
        log("No address found");
      } else {
        log("address : $address");
        setState(() {
          userAddress = address;
        });
      }
    } catch (e) {
      logError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double boxSize = width * 0.85;
    bool isDesktop = width > 600;

    return Scaffold(
      backgroundColor: Color(0XFF0D0D0D),
      appBar: TopBar(
        address: userAddress,
        primaryColor: Color(0XFF0D0D0D),
        secondaryColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg/blur_white_copy.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0XFF212121),
                ),
                margin: const EdgeInsets.only(top: 20),
                width: boxSize,
                height: 281,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "assets/image/a.webp",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Harshi Lm",
                                    style: GoogleFonts.exo2(
                                        color: Colors.white,
                                        fontSize: width > 400 ? 25 : 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FeatherIcons.edit3,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0XFF353535)),
                                child: Text(
                                  "ID673",
                                  style: GoogleFonts.exo2(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Date : 11/22/2004",
                                  style: GoogleFonts.exo2(
                                      color: Colors.white, fontSize: 12))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: const Color.fromARGB(22, 158, 158, 158),
                      thickness: 2,
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Personal Link",
                              style: GoogleFonts.exo2(
                                  color: Colors.white, fontSize: 17)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Invite new freinds using your personal link",
                              style: GoogleFonts.exo2(
                                  color:
                                      const Color.fromARGB(138, 255, 255, 255),
                                  fontSize: 12)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width > 380 ? width * 0.65 : boxSize * 0.9,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                height: 50,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: Color(0XFF353535),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "https://moonbnb.app/...",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                208, 255, 255, 255)),
                                      ),
                                      Spacer(),
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Copy",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    227, 255, 255, 255)),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            if (width > 380)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                    color: Color(0XFF353535),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular((50)),
                                            onTap: () {},
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Center(
                                                child: Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )))),
                              )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: boxSize,
                padding: const EdgeInsets.all(13),
                height: 115,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/bnb.png'),
                        fit: BoxFit.cover),
                    color: Color(0XFF212121),
                    border: Border(
                      bottom: BorderSide(color: Colors.orange, width: 3),
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Profit",
                        style: GoogleFonts.exo(
                            color: const Color.fromARGB(184, 255, 255, 255)),
                      ),
                      Text(
                        "0 BNB",
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
                            "0 BNB",
                            style: GoogleFonts.exo2(
                                color:
                                    const Color.fromARGB(188, 255, 255, 255)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: boxSize,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfitWidget(
                      imageUrl: "assets/image/32.png",
                      title: "Total Direct",
                      totalAmount: "0",
                      dailyAmount: "0"),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  ProfitWidget(
                      imageUrl: "assets/image/31.png",
                      title: "Total Team",
                      totalAmount: "0",
                      dailyAmount: "0"),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: boxSize,
                padding: const EdgeInsets.all(13),
                height: 110,
                decoration: BoxDecoration(
                    color: Color(0XFF212121),
                    image: DecorationImage(
                        image: AssetImage("assets/bg/blur_white_copy.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "People joined after you",
                        style: GoogleFonts.exo(
                            color: const Color.fromARGB(184, 255, 255, 255)),
                      ),
                      Text(
                        "0",
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
                            "10",
                            style: GoogleFonts.exo2(
                                color:
                                    const Color.fromARGB(188, 255, 255, 255)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
            Container(
              width: boxSize,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Programs",
                style: GoogleFonts.audiowide(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Container(
              width: boxSize / 2.05,
              padding: const EdgeInsets.all(4),
            ),
            ProgramWidjet(
              name: "M50",
              level: level,
              amount: 0,
              color: Colors.blue,
              imageString: "assets/bg/36.png",
            ),
            SizedBox(
              height: 15,
            ),
            ProgramWidjet(
              name: "MX",
              amount: 0,
              level: 0,
              color: Colors.orange,
              imageString: "assets/bg/37.png",
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: boxSize,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Events",
                style: GoogleFonts.audiowide(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            EventsWidget(events: events),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}
