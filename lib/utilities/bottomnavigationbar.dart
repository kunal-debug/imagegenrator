import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagegenrator/view/cartPage.dart';
import 'package:imagegenrator/view/historypage.dart';
import 'package:imagegenrator/view/homePage.dart';
import 'apiservices.dart';
import 'colors.dart';

Widget bottomlayout({ctx, index}) {
  return BottomNavigationBar(
    elevation: 50,
    backgroundColor: Clr().white,
    selectedItemColor: Clr().primaryColor,
    unselectedItemColor: Clr().grey,
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          Get.offAll(HomePage());
          break;
        case 1:
          Get.to(() => cartPage());
          break;
        case 2:
          Get.to(() => HistoryPage());
          break;
      }
    },
    items: STM().getBottomList(index),
  );
}
