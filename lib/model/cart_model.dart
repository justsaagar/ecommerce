// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

List<CartModel> cartModelFromJson(String str) =>
    List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  CartModel({
    this.id,
    this.productId,
    this.title,
    this.featuredImage,
    this.price,
    this.quantity = 1,
  });

  String? productId;
  num? id;
  String? title;
  String? featuredImage;
  num? price;
  num quantity;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        productId: json["productId"],
        id: json["id"],
        title: json["title"],
        featuredImage: json["featuredImage"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "id": id,
        "title": title,
        "featuredImage": featuredImage,
        "price": price,
        "quantity": quantity,
      };
}
