import 'package:ecommerce_getx/constant/color_constant.dart';
import 'package:ecommerce_getx/constant/string_constant.dart';
import 'package:ecommerce_getx/controller/product_controller.dart';
import 'package:ecommerce_getx/main.dart';
import 'package:ecommerce_getx/model/product_model.dart';
import 'package:ecommerce_getx/screen/cart_screen/cart_screen.dart';
import 'package:ecommerce_getx/screen/product_screen/product_view.dart';
import 'package:ecommerce_getx/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return GetBuilder<ProductController>(
      initState: (state) => productController.getProducts(context),
      builder: (ProductController productsController) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              title: const AppText(text: StringConstant.productTitle, fontColor: Colors.white),
              centerTitle: true,
              elevation: 0,
              actions: [
                cartButtonView(context),
              ],
            ),
            body: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 5,
                  childAspectRatio: 1 / 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 15,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    productsController.productList.length,
                    (index) {
                      Product product = productsController.productList[index];
                      return ProductView(
                        product: product,
                        productController: productsController,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  InkWell cartButtonView(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => CartScreen()),
      child: Container(
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.shopping_cart,
          color: ColorConstant.themeScaffold,
          size: 26,
        ),
      ),
    );
  }
}
