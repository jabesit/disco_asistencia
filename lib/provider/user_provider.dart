import 'package:disco_asistencia/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User.empty());

  void setAdmisible(bool status) {
    state = User.isAdmisible(status);
  }

  void update(User user) {
    state = user;
  }

  void setObject(
      String rut, String name, String lastname, String birthday,
      String fechaEmision, String fechaExpiration, bool isAdmisible) {
    state = User(
        rut: rut,
        name: name,
        fechaEmision: fechaEmision,
        fechaExpiration: fechaExpiration,
        lastname: lastname,
        birthday: birthday,
        isAdmisible: isAdmisible);
  }

  void newToDate(bool value) {
    state = state.registerNewToDate(value);
  }
  
  void setObjectAdmisible(User user) {
    user.isAdmisible = !user.isAdmisible;
    state = user;
  }
}
