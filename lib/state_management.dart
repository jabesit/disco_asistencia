import 'package:disco_asistencia/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<User> cartList = [];
class CartNotifier extends StateNotifier<List<User>> {
  CartNotifier() : super(cartList);

  void add(User item) {
    state = [...state, item];
  }

  void clear() {
    state = [];
  }
/*
  void toogle({required String id}) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(status: !item.status) else item,
    ];
  }
*/
  int countTotalItems() {
    return state.length;
  }
}

final cartListProvider = StateNotifierProvider<CartNotifier, List<User>>((ref) {
  return CartNotifier();
});

final criteriaProvider = StateProvider<String>((ref) => 'none');
final filteredSearchListProvider = Provider((ref) {
  final filter = ref.watch(criteriaProvider);
  final cartList = ref.watch(cartListProvider);
  if (filter == 'none') {
    return cartList;
  } else if (filter == 'inscritos') {
    return cartList;
  /*} else if (filter == 'bloqueado') {
    return cartList.where((element) => element.status).toList();
  } else if (filter == 'no bloqueados') {
    return cartList.where((element) => !element.status).toList();
  */
  } else {
    return cartList.where((element) => element.rut == filter).toList();
  }
});
