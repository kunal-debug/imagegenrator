import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagegenrator/controller/homecontroller.dart';

import '../utilities/bottomnavigationbar.dart';
import '../utilities/styles.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key});

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  late BuildContext ctx;
  final cartCtrl = Get.put(homeController());


  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        bottomNavigationBar: bottomlayout(index: 1, ctx: ctx),
        appBar: Sty().appbarLayout(title: 'Cart'),
        body: bodyLayout()
    );
  }

  Widget bodyLayout(){
    return Obx(() => ListView.builder(itemCount: 3,itemBuilder: (context, index) {
      return Container();
    },));
  }

}
