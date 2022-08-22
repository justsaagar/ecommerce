import 'package:ecommerce_getx/constant/color_constant.dart';
import 'package:ecommerce_getx/constant/string_constant.dart';
import 'package:ecommerce_getx/screen/product_screen/product_screen.dart';
import 'package:ecommerce_getx/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const MyApp());
}

void logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}

showMessage({@required String? message, bool isError = false}) {
  Get.closeAllSnackbars();
  Get.snackbar('', '',
    snackPosition: SnackPosition.BOTTOM,
    isDismissible: false,
    backgroundColor: isError ? Colors.red : ColorConstant.darkGreen,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    titleText: AppText(
      text: message!,
      fontSize: 14,
      fontColor: ColorConstant.themeScaffold,
      fontWeight: FontWeight.bold,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringConstant.appTitle,
      debugShowCheckedModeBanner: false,
      home: ProductScreen(),
    );
  }
}
