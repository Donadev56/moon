import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/price.dart';

class PoolUsersList extends StatelessWidget {
  final List<HistoryData> history;
  const PoolUsersList({super.key, required this.history});

  double calculateTotalAmount(List<HistoryData> userH) {
    double gain = 0;
    for (final hist in userH) {
      gain += hist.amount;
    }

    return gain;
  }

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
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.exo(
                                  color: Colors.white, fontSize: 13),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
