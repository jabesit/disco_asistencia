import 'dart:async';

import 'package:disco_asistencia/model/user.dart';
import 'package:disco_asistencia/services/mongo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

class ProductScreenNotifier extends AsyncNotifier<List<User>> {
  Timer? _debounceTimer;
  List<User> listaNew = [];

  Future<List<User>> _fetchProducts() async {
    final filter = ref.watch(searchTextProvider);
    print("filter" + filter);
    final allProducts = await Mongo.getUsers();
    listaNew = allProducts;
    if (filter.isNotEmpty) {
      return allProducts
          .where((product) =>
              product.rut.toString().toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      return allProducts;
    }
  }

  @override
  Future<List<User>> build() async {
    return _fetchProducts();
  }

  Future<List<User>> _fetchLocal(User user, List<User> list) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      print("size::" + list.length.toString());
      list.add(user);
      print("size::::" + list.length.toString());

      print("size:::::::" + listaNew.length.toString());
      return list;
    });
    return list;
  }

  Future<void> refreshList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      print("size:::::::" + listaNew.length.toString());
      return listaNew;
    });
  }

  Future<void> addProduct(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      listaNew.add(user);
      await Mongo.insert(user);
      return listaNew;
     // _fetchLocal(user, list);
    });
  }

  Future<void> deleteProduct(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      //await ProductRepository.instance.delete(id);
      return _fetchProducts();
    });
  }

  //This seems wrong, as I feel there should be no need for the DebounceTimer.
  void updateSearchText(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchTextProvider.notifier).update((_) => value);
      _fetchProducts();
    });
  }
}

final asyncProductScreenProvider =
    AsyncNotifierProvider<ProductScreenNotifier, List<User>>(() {
  return ProductScreenNotifier();
});
