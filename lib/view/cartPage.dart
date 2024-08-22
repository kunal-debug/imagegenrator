import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagegenrator/controller/homecontroller.dart';
import 'package:imagegenrator/view/homePage.dart';

import '../utilities/apiservices.dart';
import '../utilities/bottomnavigationbar.dart';
import '../utilities/colors.dart';
import '../utilities/dimens.dart';
import '../utilities/styles.dart';
import 'imageview.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key});

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  late BuildContext ctx;
  final cartCtrl = Get.put(homeController());

  getSession() async {
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        cartCtrl.getDataCart();
        cartCtrl.getTotalPrice();
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        bottomNavigationBar: bottomlayout(index: 1, ctx: ctx),
        appBar: Sty().appbarLayout(title: 'Cart'),
        body: cartCtrl.cartList.isEmpty ? SizedBox(
          height: MediaQuery.of(ctx).size.height / 1.3,
          child: Center(
            child: Text('No Image Added',style: Sty().mediumBoldText,),
          ),
        ) : bodyLayout());
  }

  Widget bodyLayout() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() =>
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dim().d12, bottom: Dim().d20, top: Dim().d20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: cartCtrl.cartList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    var data = cartCtrl.cartList[index];
                    return Container(
                      margin: EdgeInsets.only(right: Dim().d12),
                      decoration: BoxDecoration(
                          color: Clr().white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 1)
                          ],
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dim().d12)),
                          border: Border.all(color: Clr().black, width: 0.1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                    () =>
                                    imageview(
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
                                    placeholder: (context, url) =>
                                    const Padding(
                                      padding: EdgeInsets.all(100.0),
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
                          Text(
                            '₹${data['price']}',
                            style: Sty().mediumBoldText,
                          ),
                          SizedBox(
                            height: Dim().d2,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            )),
        Obx(() => Container(
          width: double.infinity,
          padding: EdgeInsets.all(Dim().d20),
          decoration: BoxDecoration(
            color: Clr().primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ₹${cartCtrl.totalPrice}',
                style: Sty().mediumBoldText.copyWith(color: Clr().white,),),
              AnimatedButton(
                pressEvent: () {
                  STM().successDialogWithAffinity(ctx, 'Success', HomePage(),cartCtrl.deleteCart());
                },
                text: 'Proceed',
                width: Dim().d100,
                color: Clr().white,
                isFixedHeight: true,
                buttonTextStyle: Sty().smallText.copyWith(
                    color: Clr().primaryColor, fontSize: Dim().d12),
              )
            ],
          ),
        ))
      ],
    );
  }
}
