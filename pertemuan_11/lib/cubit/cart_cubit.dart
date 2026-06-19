import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';

class CartCubit extends Cubit<List<Product>> {
  CartCubit() : super(const []);

  void addProduct(Product product) => emit([...state, product]);

  void removeProduct(Product product) {
    final updatedCart = List<Product>.from(state);
    final index = updatedCart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      updatedCart.removeAt(index);
      emit(updatedCart);
    }
  }

  int quantityOf(Product product) =>
      state.where((item) => item.id == product.id).length;
  int get totalPrice => state.fold(0, (total, item) => total + item.price);
}
