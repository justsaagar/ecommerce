import 'package:ecommerce_getx/constant/color_constant.dart';
import 'package:ecommerce_getx/controller/product_controller.dart';
import 'package:ecommerce_getx/model/product_model.dart';
import 'package:ecommerce_getx/widgets/app_image_assets.dart';
import 'package:ecommerce_getx/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key, required this.product, required this.productController})
      : super(key: key);

  final Product product;
  final ProductController productController;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: ColorConstant.darkGreen,
              margin: const EdgeInsets.all(10),
              child: AppImageAsset(
                image: product.featuredImage,
                height: 150,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: AppText(text: product.title)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => productController.addToCart(context, product),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
