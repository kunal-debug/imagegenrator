import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagegenrator/controller/homecontroller.dart';
import 'package:imagegenrator/utilities/apiservices.dart';
import 'package:imagegenrator/utilities/bottomnavigationbar.dart';
import 'package:imagegenrator/utilities/dimens.dart';
import 'package:imagegenrator/utilities/styles.dart';
import 'package:imagegenrator/view/imageview.dart';
import '../utilities/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeCtrl = Get.put(homeController());
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomlayout(ctx: ctx, index: 0),
      appBar: AppBar(
        backgroundColor: Clr().primaryColor,
        centerTitle: true,
        title: Text(
          'Image Generator',
          style: Sty().mediumText.copyWith(
                color: Clr().white,
              ),
        ),
      ),
      body: bodyLayout(),
    );
  }

  Widget bodyLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dim().d12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => homeCtrl.img.toString() != ''
                ? Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                        child: CachedNetworkImage(
                          height: Dim().d400,
                          width: double.infinity,
                          imageUrl: homeCtrl.img.toString(),
                          placeholder: (context, url) => const Padding(
                            padding: const EdgeInsets.all(120.0),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                      homeCtrl.img.toString() == ''
                          ? Container()
                          : Positioned(
                              bottom: 10,
                              right: 30,
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    ()=>
                                    imageview(
                                      image: homeCtrl.img.value,
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Clr().white,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.zoom_out_map),
                                  ),
                                ),
                              ),
                            )
                    ],
                  )
                : Container(),
          ),
          SizedBox(
            height: Dim().d20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AnimatedButton(
                  pressEvent: () {
                    homeCtrl.getImgData(ctx: ctx);
                  },
                  text: 'Fetch New Img',
                  height: Dim().d100,
                  color: Clr().primaryColor,
                  isFixedHeight: true,
                  buttonTextStyle: Sty()
                      .smallText
                      .copyWith(color: Clr().white, fontSize: Dim().d12),
                ),
              ),
              SizedBox(
                width: Dim().d12,
              ),
              Obx(() => homeCtrl.img.toString() != ''
                  ? Expanded(
                      child: AnimatedButton(
                        pressEvent: () {
                          if (homeCtrl.addImgStatus.value == false) {
                            final random = Random();
                            homeCtrl.addImgToCart(
                                homeCtrl.img.value, random.nextInt(90) + 10);
                          }
                        },
                        text: homeCtrl.addImgStatus.value == true
                            ? 'Image Added'
                            : 'Add To Cart',
                        height: Dim().d100,
                        width: Dim().d120,
                        color: Clr().primaryColor,
                        isFixedHeight: true,
                        buttonTextStyle: Sty()
                            .smallText
                            .copyWith(color: Clr().white, fontSize: Dim().d12),
                      ),
                    )
                  : Container())
            ],
          )
        ],
      ),
    );
  }
}
