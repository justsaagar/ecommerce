import 'dart:convert';

import 'package:ecommerce_getx/constant/string_constant.dart';
import 'package:ecommerce_getx/main.dart';
import 'package:ecommerce_getx/model/cart_model.dart';
import 'package:ecommerce_getx/model/product_model.dart';
import 'package:ecommerce_getx/services/db_helper.dart';
import 'package:ecommerce_getx/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxList<Product> productList = <Product>[].obs;

  Future<void> getProducts(BuildContext context) async {
    String? getProducts =
        await RestServices.getRestCall(context, RestConstants.productList);
    if (getProducts != null && getProducts.isNotEmpty) {
      Map<String, dynamic> getProductMap = jsonDecode(getProducts);
      if (getProductMap['status'] == 200) {
        ProductsModel productsModel = productsModelFromJson(getProducts);
        productList.value = productsModel.productDataList!;
      }
    }
    refresh();
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    List<CartModel> cartList = await DBHelper.instance.getMyCartMap();
    CartModel existCartModel = cartList.firstWhere(
      (element) => element.productId == product.id.toString(),
      orElse: () => CartModel(),
    );
    CartModel cartModel = CartModel(
      productId: product.id.toString(),
      title: product.title,
      price: product.price,
      featuredImage: product.featuredImage,
      quantity: existCartModel.quantity,
    );
    if (existCartModel.productId != null && existCartModel.productId!.isNotEmpty) {
      cartModel.quantity += 1;
      DBHelper.instance.updateCart(existCartModel.productId!, cartModel.quantity);
      showMessage(message: StringConstant.updateQuantity);
    } else {
      DBHelper.instance.addCart(cartModel);
      showMessage(message: StringConstant.addCart);
    }
    refresh();
  }
}
