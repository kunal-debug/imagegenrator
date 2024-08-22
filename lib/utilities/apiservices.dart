import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';
import 'dimens.dart';
import 'styles.dart';

class STM {
  Future<dynamic> allApi(
      {ctx,
      Map<String, dynamic>? body,
      apiname,
      bool? load,
      loadtitle,
      apitype}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    AwesomeDialog dialog =
        STM().loadingDialog(ctx, load == true ? loadtitle : '');
    load == true ? dialog.show() : null;
    String url = 'https://dog.ceo/api/breeds/image/random';
    var header = {
      "Content-Type": "application/json",
      "responseType": "ResponseType.plain",
    };
    dynamic result;
    try {
      final response = apitype == 'post'
          ? await http
              .post(
                Uri.parse(url),
                body: json.encode(body),
                headers: header,
              )
              .timeout(const Duration(seconds: 500))
          : await http
              .get(
                Uri.parse(url),
                headers: header,
              )
              .timeout(const Duration(seconds: 500));
      if (response.statusCode == 200) {
        print(response.body);
        try {
          load == true ? dialog.dismiss() : null;
          result = json.decode(response.body.toString());
        } catch (_) {
          load == true ? dialog.dismiss() : null;
          result = response.body;
        }
      } else if (response.statusCode == 500) {
        load == true ? dialog.dismiss() : null;
        errorDialog(ctx,
            'Something went wrong on the server side. Please try again later ${response.statusCode} Occurred in $apiname');
      } else if (response.statusCode == 401) {
        load == true ? dialog.dismiss() : null;
        errorDialog(ctx,
            'Something went wrong on the server side. Please try again later ${response.statusCode} Occurred in $apiname');
      } else {
        load == true ? dialog.dismiss() : null;
        errorDialog(ctx,
            'Something went wrong on the server side. Please try again later ${response.statusCode} Occurred  in $apiname');
      }
    } catch (e) {
      load == true ? dialog.dismiss() : null;
      if (e is TimeoutException) {
        showToast('TimeOut!!!,Please try again');
      } else if (e is CertificateException) {
        showToast(
            'CertificateException!!! SSL not verified while fetching data from $apiname');
      } else if (e is HandshakeException) {
        showToast(
            'HandshakeException!!! Connection not secure while fetching data from $apiname');
      } else if (e is FormatException) {
        showToast(
            'FormatException!!! Data cannot parse and unexpected format while fetching data from $apiname');
      } else {
        showToast('Something went wrong in $apiname');
      }
    }
    return result;
  }

  Future<bool?> showToast(title) {
    return Fluttertoast.showToast(
        msg: title,
        backgroundColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
        textColor: Clr().white,
        toastLength: Toast.LENGTH_LONG);
  }

  void errorDialog(BuildContext context, String message) {
    AwesomeDialog(
            context: context,
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {},
            btnOkColor: Colors.red)
        .show();
  }

  AwesomeDialog loadingDialog(BuildContext context, String title) {
    AwesomeDialog dialog = AwesomeDialog(
      width: 250,
      context: context,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: Container(
        height: Dim().d160,
        padding: EdgeInsets.all(Dim().d16),
        decoration: BoxDecoration(
          color: Clr().white,
          borderRadius: BorderRadius.circular(Dim().d32),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Dim().d12),
              child: SpinKitSquareCircle(
                color: Clr().primaryColor,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Sty().mediumBoldText,
            ),
          ],
        ),
      ),
    );
    return dialog;
  }

  Future<bool> checkInternet(context, widget) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      internetAlert(context, widget);
      return false;
    }
  }

  internetAlert(context, widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Padding(
        padding: EdgeInsets.all(Dim().d20),
        child: Column(
          children: [
            // SizedBox(child: Lottie.asset('assets/no_internet_alert.json')),
            Text(
              'Connection Error',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontSize: 18.0,
                  ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'No Internet connection found.',
              style: Sty().smallText,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult.contains(ConnectivityResult.mobile) ||
                      connectivityResult.contains(ConnectivityResult.wifi)) {
                    Get.back();
                  }
                },
                child: Text(
                  "Try Again",
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  List<BottomNavigationBarItem> getBottomList(index) {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'History',
      ),
    ];
  }

  void successDialogWithAffinity(
      BuildContext context, String message, Widget widget,funt) {
    AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        headerAnimationLoop: true,
        title: 'Success',
        desc: message,
        btnOkText: "OK",
        btnOkOnPress: () {
          Get.offAll(()=> widget);
          funt;
        },
        btnOkColor: Colors.green)
        .show();
  }



}
