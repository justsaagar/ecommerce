import 'package:ecommerce_getx/services/db_helper.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  void updateQuantity(String productId, num quantity, {bool isAdd = true}) {
    if (!isAdd && quantity - 1 == 0) {
      DBHelper.instance.deleteCartProduct(productId);
    } else {
      DBHelper.instance.updateCart(productId, isAdd ? quantity + 1 : quantity - 1);
    }
    refresh();
  }
}
