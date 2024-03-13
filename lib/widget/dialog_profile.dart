import 'package:disco_asistencia/model/user.dart';
import 'package:disco_asistencia/widget/profile.dart';
import 'package:flutter/material.dart';

class DialogProfile {
  void showModal(BuildContext context, User user) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) => Profile(
              user: user,
            )).whenComplete(() {});
  }
}
