/*
import 'dart:io';

import 'package:disco_asistencia/provider/user_provider.dart';
import 'package:disco_asistencia/qr_page.dart';
import 'package:disco_asistencia/services/ocr/module.dart';
import 'package:disco_asistencia/state_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:disco_asistencia/model/user.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:ocr_scan_text/ocr_scan/services/ocr_scan_service.dart';

class MyHomePage extends ConsumerWidget {
  final myController = TextEditingController();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<User> filteredSearchListProvider = ref.watch(cartListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const QRPage()));
              },
            );
          },
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.file_open),
                onPressed: () async {
                  final userProvider = StateNotifierProvider<UserNotifier, User>(
                      (ref) => UserNotifier());
                 // final module = ScanAllModule();


                  module.start();
                  User user = ref.watch(userProvider);

                  final ImagePicker picker = ImagePicker();

                  final XFile? photo =
                      await picker.pickImage(source: ImageSource.camera);
                  if (photo == null) return;
                  File file = File(photo.path);

                  OcrScanService([module]).startScanProcess(file).then((value) {
                    if (value == null) return;
                    print("---> has value");

                    final entries = value.mapResult.entries;
                    final text = entries.first.value.firstOrNull?.cleanedText;

                    if (text == null) return;
                    if (text.length < 280) return;
                    print("---> has Text " + text.length.toString());

                    print("---> ${text.substring(0, 100)}");
                    print("---> ${text.substring(101, 200)}");
                    print("---> ${text.substring(201, 250)}");
                    print("---> ${text.substring(251, 300)}");
                    print("---> ${text.substring(300, text.length)}");

                    print("---> regexNombre");
                    RegExp regexNombre =
                        RegExp(r'NOMBRES(.*?)NACIONALIDAD|NOMBRES(.*?)APELLIDOS');
                    for (RegExpMatch match in regexNombre.allMatches(text)) {
                      if (match.group(0) != null) {
                        String name = match.group(0)!;
                        print("---> 0 name $name");
                        user.name = name;
                      }
                      if (match.group(1) != null) {
                        String name = match.group(1)!;
                        print("---> name $name");
                        user.name = name;
                      }
                    }

                    print("---> regexName");
                    RegExp regexName =
                        RegExp(r'APELLIDOS(.*?)NOMBRES|NOMBRES(.*?)APELLIDOS');
                    for (RegExpMatch match in regexName.allMatches(text)) {
                      if (match.group(1) != null) {
                        String lastname = match.group(1)!;
                        print("---> lastname $lastname");
                        user.lastname = lastname;
                      }
                    }

                    print("---> regexSerie");
                    RegExp regexSerie = RegExp(r'\b\d{3}\.\d{3}\.\d{3}\b');
                    for (RegExpMatch match in regexSerie.allMatches(text)) {
                      if (match.group(0) != null) {
                        String numeroSerie = match.group(0)!;
                        print("---> nroDocumento $numeroSerie");
                        user.serie = numeroSerie;
                      }
                    }

                    print("---> regexID");
                    RegExp regexID = RegExp(r'\b\d{1,3}\.\d{3}\.\d{3}-[\dkK]\b');
                    Iterable<RegExpMatch> matches2 = regexID.allMatches(text);
                    for (RegExpMatch match in matches2) {
                      if (match.group(0) != null) {
                        String rut = match.group(0)!;
                        print("---> rut $rut");
                        user.id = rut;
                      }
                    }

                    print("---> regexFechaDocumento");
                    RegExp regexFechaDocumento =
                        RegExp(r'\b\d{1,2} [A-Z]{3} \d{4}\b');
                    Map<int, String> myMap = {};
                    Iterable<RegExpMatch> matches3 =
                        regexFechaDocumento.allMatches(text);
                    for (RegExpMatch match in matches3) {
                      if (match.group(0) != null) {
                        String fechasDocumento = match.group(0)!;
                        print("---> fechasDocumento $fechasDocumento");
                        myMap[int.parse(fechasDocumento.split(" ")[2])] =
                            fechasDocumento;
                      }
                    }
                    List<int> sortedKeys = myMap.keys.toList()..sort();

                    if (myMap.isNotEmpty) {
                      if (myMap.length == 2) {
                        String fechaNacimiento = myMap[sortedKeys[0]]!;
                        String fechaEmision = myMap[sortedKeys[1]]!;

                        if (user.birthday == null) {
                          user.birthday = fechaNacimiento;
                        }
                        user.fechaEmision = fechaEmision;

                        print("---> fechaNacimiento: $fechaNacimiento");
                        print("---> fechaEmision: $fechaEmision");
                      } else if (myMap.length == 3) {
                        String fechaNacimiento = myMap[sortedKeys[0]]!;
                        String fechaEmision = myMap[sortedKeys[1]]!;
                        String fechaVencimiento = myMap[sortedKeys[2]]!;

                        if (user.birthday == null) {
                          user.birthday = fechaNacimiento;
                        }

                        user.fechaEmision = fechaEmision;
                        user.fechaExpiration = fechaVencimiento;

                        print("---> fechaNacimiento: $fechaNacimiento");
                        print("---> fechaEmision: $fechaEmision");
                        print("---> fechaVencimiento: $fechaVencimiento");
                      }
                    }
                    print("---> " + user.toString());
                    print("---> started " + module.started.toString());
                    print("---> distanceCorrelation: " +
                        module.distanceCorrelation.toString());

                    module.stop();
                  });
                });
          })
        ],
        backgroundColor: Colors.lightBlue,
        centerTitle: false,
        title: const Text(
          'Listado',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 40, 10, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "buscar rut",
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: filteredSearchListProvider.map((user) {
              return Container();
              //return UserCard(user: user);
            }).toList(),
          )
        ],
      ),
    );
  }
}
*/