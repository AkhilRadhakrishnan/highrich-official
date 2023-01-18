// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:highrich/entity/CartEntity.dart';

@dao
abstract class CartDao {
  @Query('SELECT * FROM CartEntity')
  Future<List<CartEntity>> getGuestCart();

  @Query('SELECT * FROM CartEntity WHERE id = :id')
  Stream<CartEntity> findPersonById(int id);

  @Query("DELETE FROM CartEntity")
  Future<List<CartEntity>> clearCartEntity();

  // @Query('UPDATE CartEntity SET order_price=:price WHERE order_id = :id')
  // Stream<CartEntity> updateGuestCart(int id);


  @insert
  Future<void> addToGuestCart(CartEntity cartEntity);
}

