// entity/person.dart

import 'package:floor/floor.dart';

@entity
class CartEntity {
  @PrimaryKey(autoGenerate: true)
   final int id;

  final String itemsInCart;

  CartEntity(this.id,this.itemsInCart);
}