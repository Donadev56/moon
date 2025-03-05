import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/price.dart';

class HistoryWidget extends StatelessWidget {
  final List<HistoryData> history;
  final AppColors colors;
  const HistoryWidget({super.key, required this.history, required this.colors});

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
    final manager = PriceManager();

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
            color: colors.grayColor.withOpacity(0.3)),
        child: Column(
          children: [
            Container(
              width: width * 0.9,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                "${calculateTotalAmount(history).toStringAsFixed(8)} BNB",
                style: GoogleFonts.roboto(
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            FutureBuilder(
                future: manager.getPrice(),
                builder: (BuildContext ctx, AsyncSnapshot result) {
                  if (result.hasData) {
                    return Container(
                      width: width * 0.9,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "= ${(calculateTotalAmount(history) * result.data).toStringAsFixed(5)} USDT",
                        style: GoogleFonts.roboto(
                            color: colors.textColor.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    );
                  } else {
                    return Container(
                      width: width * 0.9,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Loading...",
                        style: GoogleFonts.roboto(
                            color: colors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    );
                  }
                }),
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
                                color: colors.grayColor.withOpacity(0.3)))),
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
                                  color: colors.textColor, fontSize: 13),
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
                                    color: colors.textColor, fontSize: 10),
                              ),
                            )
                          ],
                        ),
                        trailing: Text(
                          "${event.amount}",
                          style: GoogleFonts.exo(
                              color: colors.textColor, fontSize: 11),
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
                color: colors.grayColor,
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
                              color: colors.textColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocale.GoToDashboardText.getString(context),
                              style: GoogleFonts.exo(color: colors.textColor),
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
