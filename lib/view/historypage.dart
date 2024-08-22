import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagegenrator/controller/homecontroller.dart';
import 'package:imagegenrator/utilities/apiservices.dart';
import 'package:imagegenrator/utilities/bottomnavigationbar.dart';
import 'package:imagegenrator/utilities/colors.dart';
import 'package:imagegenrator/utilities/dimens.dart';
import 'package:imagegenrator/utilities/localstore.dart';
import 'package:imagegenrator/utilities/styles.dart';
import 'cartPage.dart';
import 'imageview.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late BuildContext ctx;

  final historyCtrl = Get.put(homeController());

  getSession() async {
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        historyCtrl.getDataHistory();
        historyCtrl.getDataCart();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        bottomNavigationBar: bottomlayout(index: 2, ctx: ctx),
        appBar: Sty().appbarLayout(title: 'History'),
        body: bodyLayout());
  }

  Widget bodyLayout() {
    return Obx(() => Padding(
          padding: EdgeInsets.only(
              left: Dim().d12, bottom: Dim().d20, top: Dim().d20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: historyCtrl.historyList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              var data = historyCtrl.historyList[index];
              return Container(
                margin: EdgeInsets.only(right: Dim().d12),
                decoration: BoxDecoration(
                    color: Clr().white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26, blurRadius: 4, spreadRadius: 1)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                    border: Border.all(color: Clr().black, width: 0.1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => imageview(
                            image: data['image'].toString(),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dim().d12),
                              topRight: Radius.circular(Dim().d12),
                            ),
                            child: CachedNetworkImage(
                              height: Dim().d140,
                              width: double.infinity,
                              imageUrl: data['image'].toString(),
                              placeholder: (context, url) => const Padding(
                                padding:  EdgeInsets.all(100.0),
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              height: Dim().d20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Clr().white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.zoom_out_map,
                                  size: Dim().d16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '₹${data['price']}',
                          style: Sty().mediumBoldText,
                        ),
                        Obx(
                          () => AnimatedButton(
                            pressEvent: () {
                              if (historyCtrl.cartList.any((e) =>
                                  e['image'].toString() ==
                                  data['image'].toString())) {
                                return;
                              }
                              final random = Random();
                              historyCtrl.addImgToCart(data['image'].toString(),
                                  random.nextInt(90) + 10);
                            },
                            text: historyCtrl.cartList.any((e) =>
                                    e['image'].toString() ==
                                    data['image'].toString())
                                ? 'Image Added'
                                : 'Add To Cart',
                            width: Dim().d100,
                            color: Clr().primaryColor,
                            isFixedHeight: true,
                            buttonTextStyle: Sty().smallText.copyWith(
                                color: Clr().white, fontSize: Dim().d12),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dim().d2,
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
