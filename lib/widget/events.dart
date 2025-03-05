import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html';

class EventsWidget extends StatelessWidget {
  final List<ContractEvents> regEvents;
  final AppColors colors;
  final List<ContractEvents> purchaseEvents;
  final TabController tabController;
  final bool isArabic;
  const EventsWidget({
    super.key,
    required this.regEvents,
    required this.tabController,
    required this.purchaseEvents,
    required this.isArabic,
    required this.colors,
  });

  List<ContractEvents> getFilteredEvents(List<ContractEvents> contractEvents) {
    final List<ContractEvents> lastEvents = contractEvents;
    lastEvents.sort((a, b) => a.time.compareTo(b.time));
    return lastEvents.sublist(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 400,
      child: TabBarView(controller: tabController, children: [
        Container(
          width: width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.secondaryColor),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300, minHeight: 100),
                child: ListView.builder(
                  itemCount: getFilteredEvents(regEvents).length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = getFilteredEvents(regEvents)[index];
                    if (regEvents.isEmpty) {
                      return Text(
                        "Loading..",
                        style: GoogleFonts.roboto(color: colors.textColor),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      colors.secondaryColor.withOpacity(0.8)))),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        child: Directionality(
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              onTap: () {},
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
                                        color: colors.textColor, fontSize: 12),
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
                                        color:
                                            event.iconColor.withOpacity(0.2)),
                                    child: Text(
                                      "ID ${event.id}",
                                      style: GoogleFonts.audiowide(
                                          color: colors.textColor,
                                          fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                              trailing: Text(
                                "${event.time} min",
                                style: GoogleFonts.exo(color: colors.textColor),
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: width * 0.75,
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
                      window.open(
                          "https://opbnb.bscscan.com/address/0xC0556304608f0C30662323C315cABE3B93F642DD",
                          "_blank");
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
                                Icons.remove_red_eye,
                                color: colors.textColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocale.seeAllEventsText.getString(context),
                                style: GoogleFonts.exo(color: colors.textColor),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.secondaryColor),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300, minHeight: 100),
                child: ListView.builder(
                  itemCount: getFilteredEvents(purchaseEvents).length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = getFilteredEvents(purchaseEvents)[index];
                    if (purchaseEvents.isEmpty) {
                      return Text(
                        "Loading..",
                        style: GoogleFonts.roboto(color: colors.textColor),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: colors.secondaryColor))),
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          child: Directionality(
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              onTap: () {},
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
                                        color: colors.textColor, fontSize: 12),
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
                                        color:
                                            event.iconColor.withOpacity(0.2)),
                                    child: Text(
                                      "ID ${event.id}",
                                      style: GoogleFonts.audiowide(
                                          color: colors.textColor,
                                          fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                              trailing: Text(
                                "${event.time} min",
                                style: GoogleFonts.exo(color: colors.textColor),
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: width * 0.8,
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
                      window.open(
                          "https://opbnb.bscscan.com/address/0xC0556304608f0C30662323C315cABE3B93F642DD",
                          "_blank");
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
                                Icons.remove_red_eye,
                                color: colors.textColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocale.seeAllEventsText.getString(context),
                                style: GoogleFonts.exo(color: colors.textColor),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
