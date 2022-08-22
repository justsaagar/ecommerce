// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:ecommerce_getx/main.dart';
import 'package:ecommerce_getx/model/cart_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._instance();
  static Database? _db;

  DBHelper._instance();

  static const String dbName = 'cartDetails';

  //     ======================= My Cart Table =======================     //
  static const String cartTable = 'myCart';
  static const String id = 'id';
  static const String productId = 'productId';
  static const String title = 'title';
  static const String featuredImage = 'featuredImage';
  static const String price = 'price';
  static const String quantity = 'quantity';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    } else {
      logs('Database Name : $_db');
      logs('Database Check : ${_db!.isOpen}');
    }
    return _db;
  }

  _initDb() async {
    Directory documentDirectory = await getApplicationSupportDirectory();
    String path = join(documentDirectory.path, dbName);
    final db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $cartTable ($id integer primary key autoincrement, $productId TEXT, $title TEXT, $featuredImage TEXT, $price INTEGER, $quantity INTEGER)');
  }

  Future<List<CartModel>> getMyCartMap() async {
    Database? dbClient = await db;
    List<CartModel> catModelList = <CartModel>[];
    final List<Map<String, dynamic>> result = await dbClient!.query(cartTable);
    for (Map<String, dynamic> element in result) {
      CartModel cartModel = CartModel.fromJson(element);
      catModelList.add(cartModel);
    }
    logs('Get my cart map result : $result');
    return catModelList;
  }

  Future<int> addCart(CartModel product) async {
    Database? dbClient = await db;
    final int result = await dbClient!.insert(cartTable, product.toJson());
    logs('Add cart result : $result');
    return result;
  }

  Future<void> updateCart(String id, num proQuantity) async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery(
        'UPDATE $cartTable SET $quantity = ? WHERE $productId = ?',
        [proQuantity.toInt(), id]);
    logs('Update cart result : $result');
  }

  Future<int> deleteCartProduct(String id) async {
    Database? dbClient = await db;
    final int result = await dbClient!.delete(cartTable, where: '$productId = ?', whereArgs: [id]);
    logs('Delete cart product result : $result');
    return result;
  }

  Future<int> countMyCartMap() async {
    Database? dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.query(cartTable);
    logs('Count my cart map result : $result');
    return result.length;
  }

  Future<int> calculateMyCart() async {
    Database? dbClient = await db;
    int cartAmount = 0;
    final List<Map<String, dynamic>> result = await dbClient!.query(cartTable);
    for (Map<String, dynamic> element in result) {
      CartModel cartModel = CartModel.fromJson(element);
      num productTotal = cartModel.quantity * cartModel.price!;
      cartAmount += productTotal.toInt();
    }
    logs('Calculate my cart map result : $cartAmount');
    return cartAmount;
  }
}
