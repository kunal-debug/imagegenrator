import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';
import 'dimens.dart';

class Sty {
  TextStyle microText = TextStyle(
    letterSpacing: 0.5,
    color: Colors.black,
    fontSize: 12.0,
  );
  TextStyle smallText = TextStyle(
    letterSpacing: 0.5,
    color: Colors.black,
    fontSize: 14.0,
  );
  TextStyle mediumText = TextStyle(
    letterSpacing: 0.5,
    color: Colors.black,
    fontSize: 16.0,
  );
  TextStyle mediumBoldText = TextStyle(
    letterSpacing: 0.5,
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );
  TextStyle largeText = TextStyle(
    letterSpacing: 0.5,
    color: Colors.black,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
  );
  TextStyle extraLargeText = TextStyle(
    letterSpacing: 0.5,
    color: Colors.black,
    fontSize: 24.0,
    fontWeight: FontWeight.w100,
  );

  ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Clr().primaryColor,
    padding: EdgeInsets.symmetric(
      vertical: Dim().d12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        Dim().d12,
      ),
    ),
  );

  appbarLayout({title}) {
    return AppBar(
      backgroundColor: Clr().primaryColor,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          color: Clr().white,
        ),
      ),
      title: Text(
        title,
        style: Sty().mediumBoldText.copyWith(color: Clr().white),
      ),
      centerTitle: true,
    );
  }
}
