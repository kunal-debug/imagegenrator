import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 0));
  runApp(
    GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}
