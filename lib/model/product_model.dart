// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(String str) => ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  ProductsModel({
    this.status,
    this.message,
    this.totalRecord,
    this.totalPage,
    this.productDataList,
  });

  num? status;
  String? message;
  num? totalRecord;
  num? totalPage;
  List<Product>? productDataList;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    status: json["status"],
    message: json["message"],
    totalRecord: json["totalRecord"],
    totalPage: json["totalPage"],
    productDataList: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalRecord": totalRecord,
    "totalPage": totalPage,
    "data": List<dynamic>.from(productDataList!.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.price,
    this.featuredImage,
    this.status,
    this.createdAt,
  });

  num? id;
  String? slug;
  String? title;
  String? description;
  num? price;
  String? featuredImage;
  String? status;
  DateTime? createdAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    slug: json["slug"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    featuredImage: json["featured_image"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "title": title,
    "description": description,
    "price": price,
    "featured_image": featuredImage,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
  };
}
