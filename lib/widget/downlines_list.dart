import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';

class DownlinesListWidget extends StatelessWidget {
  final List<DownlinesData> downlines;
  const DownlinesListWidget({super.key, required this.downlines});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.85,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Colors.transparent,
              width: 1,
            )),
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(0, 33, 33, 33)),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300, minHeight: 100),
              child: ListView.builder(
                itemCount: downlines.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = downlines[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(78, 47, 47, 47)))),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        onTap: () {
                          log("Element cliqued");
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: event.iconColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            event.icon,
                            color: event.iconColor,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              event.name,
                              style: GoogleFonts.exo(
                                  color: Colors.white, fontSize: 15),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: event.iconColor, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  color: event.iconColor.withOpacity(0.2)),
                              child: Text(
                                "ID ${event.id}",
                                style: GoogleFonts.audiowide(
                                    color: Colors.white, fontSize: 10),
                              ),
                            )
                          ],
                        ),
                        trailing: Text(
                          event.time,
                          style: GoogleFonts.exo(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: width * 0.65,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0XFF434343),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.go("/dashboard");
                    log("See all events clicked");
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Go to Dashboard",
                              style: GoogleFonts.exo(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ],
        ));
  }
}
