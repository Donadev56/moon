import 'dart:js_interop';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/ethereum.dart';
import 'package:moon/utils/register.dart';
import 'package:moon/widget/snackbar.dart';

void showPreviewDialog({
  required bool mounted,
  required BuildContext context,
  required AppColors colors,
  required Future<void> Function() reInit,
  required RegistrationManager regManager,
  required Future<UserData?> Function(String) userdataWithAddress,
  required Future<Uint8List?> Function(String) currentImage,
}) {
  showDialog(
      context: context,
      builder: (ctx) {
        UserData? searchingUserData;
        Uint8List? foundedUserImage;

        return StatefulBuilder(builder: (ctx, setLocalState) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Scaffold(
                backgroundColor: colors.secondaryColor,
                appBar: AppBar(
                  title: searchingUserData != null
                      ? Text(
                          "${searchingUserData?.name}",
                          style: GoogleFonts.roboto(color: colors.textColor),
                        )
                      : null,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: colors.textColor,
                      )),
                  backgroundColor: colors.secondaryColor,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  TextField(
                                    style: TextStyle(color: colors.textColor),
                                    cursorColor: colors.themeColor,
                                    onChanged: (value) async {
                                      final id = int.tryParse(value);
                                      if (id != null) {
                                        final address =
                                            await regManager.getAddressById(id);

                                        if (address.isNotEmpty) {
                                          final user =
                                              await userdataWithAddress(
                                                  address);
                                          if (user != null) {
                                            setLocalState(() {
                                              searchingUserData = user;
                                            });
                                          }

                                          final userImage =
                                              await currentImage(address);
                                          if (userImage != null) {
                                            setLocalState(() {
                                              foundedUserImage = userImage;
                                            });
                                          }
                                        } else {
                                          logError("address is empty");
                                        }
                                      } else {
                                        logError("id is null");
                                      }
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                      hintText: 'Enter an ID',
                                      hintStyle: TextStyle(
                                          color: colors.textColor
                                              .withOpacity(0.8)),
                                      filled: true,
                                      fillColor:
                                          Color(0XFF353535).withOpacity(0.4),
                                      prefixIcon: Icon(Icons.search,
                                          color: colors.textColor
                                              .withOpacity(0.8)),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (searchingUserData != null)
                                    Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        child: foundedUserImage != null
                                            ? Image.memory(
                                                foundedUserImage!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "assets/image/dog.jpg",
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  if (searchingUserData != null)
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        spacing: 15,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${searchingUserData?.name}",
                                            style: GoogleFonts.roboto(
                                                color: colors.textColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${searchingUserData?.address.substring(0, 10)}...${searchingUserData?.address.substring((searchingUserData?.address.length as int) - 10, (searchingUserData?.address.length as int))}",
                                            style: GoogleFonts.roboto(
                                              color: colors.textColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              spacing: 15,
                                              children: [
                                                TextButton.icon(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color: colors.textColor,
                                                  ),
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: searchingUserData
                                                                    ?.address ??
                                                                ""));
                                                  },
                                                  label: Text(
                                                    "Copy address",
                                                    style: GoogleFonts.roboto(
                                                        color:
                                                            colors.textColor),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              colors.grayColor),
                                                ),
                                                TextButton.icon(
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                    color: colors.primaryColor,
                                                  ),
                                                  onPressed: () async {
                                                    final eth = Web3Manager();
                                                    if (searchingUserData
                                                            ?.address !=
                                                        null) {
                                                      final saveResponse = await eth
                                                          .savePreviewAddress(
                                                              address:
                                                                  searchingUserData
                                                                          ?.address
                                                                      as String);
                                                      if (saveResponse) {
                                                        await reInit();
                                                        if (mounted) {
                                                          showCustomSnackBar(
                                                              context: context,
                                                              message:
                                                                  "Done ! please reload the page",
                                                              iconColor: colors
                                                                  .themeColor,
                                                              icon: Icons
                                                                  .check_circle);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  label: Text(
                                                    "Enter preview",
                                                    style: GoogleFonts.roboto(
                                                        color: colors
                                                            .primaryColor),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              colors.textColor),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
      });
}
