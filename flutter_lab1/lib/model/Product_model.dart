// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Product welcomeFromJson(String str) => Product.fromJson(json.decode(str));

String welcomeToJson(Product data) => json.encode(data.toJson());

class Product {
  prod product;

  Product({
    required this.product,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        product: prod.fromJson(json["Product"]),
      );

  Map<String, dynamic> toJson() => {
        "Product": product.toJson(),
      };
}

class prod {
  String id;
  String productName;
  String productType;
  int price;
  String unit;
  int v;

  prod({
    required this.id,
    required this.productName,
    required this.productType,
    required this.price,
    required this.unit,
    required this.v,
  });

  factory prod.fromJson(Map<String, dynamic> json) => prod(
        id: json["_id"],
        productName: json["product_name"],
        productType: json["product_type"],
        price: json["price"],
        unit: json["unit"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit,
        "__v": v,
      };
}
