import 'dart:developer';
import 'dart:io';

import 'package:disco_asistencia/model/user.dart';
import 'package:disco_asistencia/provider/user_providers.dart';
import 'package:disco_asistencia/services/mongo.dart';
import 'package:disco_asistencia/widget/dialog_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Convert {
  static Future<String> imageToText(XFile pickedFile) async {
    File fileImagePath = File(pickedFile.path);

    final inputImage = InputImage.fromFile(fileImagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    return recognizedText.text;
  }

  static Future<void> showProfile(
      XFile pickedFile, BuildContext context, WidgetRef ref) async {
    String text = await Convert.imageToText(pickedFile);
    User user = User.fromString(text);
    print(text);
    log("---> $user");

    ref.read(asyncProductScreenProvider.notifier).addProduct(user);

    DialogProfile().showModal(context, user);
  }

  static Future<void> showProfile2(BuildContext context, String rut) async {
    final user = User(
        rut: rut,
        name: "name",
        fechaEmision: "fechaEmision",
        fechaExpiration: "fechaExpiration",
        lastname: "lastname",
        birthday: "birthday",
        isAdmisible: true);

    //ref.read(asyncProductScreenProvider.notifier).addProduct(user);

    final data = await Mongo.checkUserExist(user);
    if (data == null) {
      await Mongo.insert(user);
      DialogProfile().showModal(context, user);
    } else {
      DialogProfile().showModal(context, data);
    }
  }
}
