import 'package:ecommerce_getx/constant/color_constant.dart';
import 'package:ecommerce_getx/constant/string_constant.dart';
import 'package:ecommerce_getx/controller/cart_controller.dart';
import 'package:ecommerce_getx/main.dart';
import 'package:ecommerce_getx/model/cart_model.dart';
import 'package:ecommerce_getx/services/db_helper.dart';
import 'package:ecommerce_getx/widgets/app_image_assets.dart';
import 'package:ecommerce_getx/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logs('Current screen --> $runtimeType');
    return GetBuilder<CartController>(
        initState: (state) {},
        builder: (CartController cartController) {
          return Scaffold(
            appBar: AppBar(
              title: const AppText(text: StringConstant.myCartTitle, fontColor: Colors.white),
              centerTitle: true,
              elevation: 0,
            ),
            body: FutureBuilder<List<CartModel>>(
              future: DBHelper.instance.getMyCartMap(),
              builder: (context, AsyncSnapshot<List<CartModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(color: ColorConstant.transparent);
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: AppText(
                        text: StringConstant.someWentWrong,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return snapshot.data!.isEmpty
                        ? const Center(
                            child: AppText(
                              text: StringConstant.emptyCart,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : OrientationBuilder(builder: (context, orientation) => buildCartProductView(orientation, snapshot, cartController,));
                  } else {
                    return const AppText(
                      text: StringConstant.noData,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    );
                  }
                } else {
                  return Center(
                    child: AppText(
                      text: snapshot.connectionState.name,
                      fontSize: 20,
                    ),
                  );
                }
              },
            ),
            bottomNavigationBar: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(color: ColorConstant.darkGreen),
              child: Row(
                children: [
                  FutureBuilder<int>(
                    future: DBHelper.instance.countMyCartMap(),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: ColorConstant.transparent);
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: AppText(
                              text: '${StringConstant.totalItemCount} : 0',
                              fontColor: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return AppText(
                            text: '${StringConstant.totalItemCount} : ${snapshot.data}',
                            fontColor: Colors.white,
                          );
                        } else {
                          return const AppText(
                            text: '${StringConstant.totalItemCount} : 0',
                            fontColor: Colors.white,
                          );
                        }
                      } else {
                        return Center(
                          child: AppText(
                            text: snapshot.connectionState.name,
                            fontSize: 20,
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  FutureBuilder<int>(
                    future: DBHelper.instance.calculateMyCart(),
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: ColorConstant.transparent);
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: AppText(
                              text: '${StringConstant.grandTotalCount} : 00',
                              fontColor: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return AppText(
                            text: '${StringConstant.grandTotalCount} : ${snapshot.data}',
                            fontColor: Colors.white,
                          );
                        } else {
                          return const AppText(
                            text: '${StringConstant.grandTotalCount} : 00',
                            fontColor: Colors.white,
                          );
                        }
                      } else {
                        return Center(
                          child: AppText(
                            text: snapshot.connectionState.name,
                            fontSize: 20,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  GridView buildCartProductView(Orientation orientation, AsyncSnapshot<List<CartModel>> snapshot, CartController cartController) {
    return GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
      childAspectRatio: 2.7 / 1,
      crossAxisSpacing: 12,
      mainAxisSpacing: 15,
      primary: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      children: List.generate(snapshot.data!.length, (index) {
        CartModel cartModel = snapshot.data![index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppImageAsset(image: cartModel.featuredImage),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: cartModel.title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        productPrice(cartModel.price!),
                        const SizedBox(height: 10),
                        productQuantity(cartModel.quantity),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            cartController.updateQuantity(
                              cartModel.productId!,
                              cartModel.quantity,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: ColorConstant.darkGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: ColorConstant.themeScaffold,
                              size: 16,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        InkWell(
                          onTap: () {
                            cartController.updateQuantity(
                              cartModel.productId!,
                              cartModel.quantity,
                              isAdd: false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: ColorConstant.darkGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: ColorConstant.themeScaffold,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        );
      }),
    );
  }

  Row productPrice(num price) {
    return Row(
      children: [
        const AppText(text: StringConstant.price, fontSize: 14),
        const Expanded(child: SizedBox()),
        AppText(text: '$price', fontSize: 14),
      ],
    );
  }

  Row productQuantity(num quantity) {
    return Row(
      children: [
        const AppText(text: StringConstant.quantity, fontSize: 14),
        const Expanded(child: SizedBox()),
        AppText(text: '$quantity', fontSize: 14),
      ],
    );
  }
}
