// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:highrich/DAO/CartDao.dart';
import 'package:highrich/entity/CartEntity.dart';
import 'package:highrich/model/cart_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;



part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CartEntity])
abstract class AppDatabase extends FloorDatabase {
  CartDao get cartDao;
}