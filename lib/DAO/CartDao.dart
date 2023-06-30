// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:highrich/entity/CartEntity.dart';
import 'package:highrich/model/cart_model.dart';

@dao
abstract class CartDao {
  @Query('SELECT * FROM CartEntity')
  Future<List<CartEntity>> getGuestCart();

  @Query('SELECT * FROM CartEntity WHERE id = :id')
  Stream<CartEntity> findPersonById(int id);

  @Query("DELETE * FROM CartEntity")
  Future<void> clearCartEntity();




  @insert
  Future<void> addToGuestCart(CartEntity cartEntity);
}
