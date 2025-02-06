import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';

class HistoryWidget extends StatelessWidget {
  final List<HistoryData> history;
  final double amount;
  final VoidCallback onTap;
  final bool isWithdrawing;
  const HistoryWidget(
      {super.key,
      required this.history,
      required this.amount,
      required this.onTap,
      required this.isWithdrawing});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.9,
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
                itemCount: history.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = history[index];
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
                                  color: Colors.white, fontSize: 13),
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
                                "${event.amount} BNB",
                                style: GoogleFonts.audiowide(
                                    color: Colors.white, fontSize: 10),
                              ),
                            )
                          ],
                        ),
                        trailing: Text(
                          "${event.time} days ",
                          style: GoogleFonts.exo(
                              color: Colors.white, fontSize: 11),
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
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTap,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: isWithdrawing
                            ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.dollarSign,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Claim $amount BNB",
                                    style: GoogleFonts.exo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
