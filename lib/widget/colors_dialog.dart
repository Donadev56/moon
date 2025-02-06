import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showDropdownDialog(BuildContext context, List<Color> colors, changeColor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0XFF353535),
        title: Text(
          "Choose a color",
          style: GoogleFonts.exo(color: Colors.white),
        ),
        content: DropdownButton<String>(
          borderRadius: BorderRadius.circular(10),
          value: "orange",
          onChanged: (String? newValue) {
            changeColor(newValue);

            Navigator.of(context).pop();
          },
          items: <String>['orange', 'blue', 'green']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      );
    },
  );
}
