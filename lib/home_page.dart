// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:disco_asistencia/pick_camera_photo_page.dart';
import 'package:disco_asistencia/provider/user_providers.dart';
import 'package:disco_asistencia/qr_page.dart';
import 'package:disco_asistencia/user_card.dart';
import 'package:disco_asistencia/utils/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:disco_asistencia/model/user.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends ConsumerWidget {
  final myController = TextEditingController();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemValue = ref.watch(asyncProductScreenProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => QRPage()));
              },
            );
          },
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.file_open),
                onPressed: () async {
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    Convert.showProfile(pickedFile, context, ref);
                  }
                });
          }),
          Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () async {
                  await availableCameras().then((cameras) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CameraOverlayPage(cameras)));
                  });
                });
          }),
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
                      onChanged: (value) {
                        ref
                            .read(asyncProductScreenProvider.notifier)
                            .updateSearchText(value);
                      },
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
          itemValue.when(
            data: (item) => SizedBox(
              height: 400,
              child: RefreshIndicator(
                onRefresh: () async {
                  return await ref.refresh(asyncProductScreenProvider);
                },
                child: ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = item[index];
                    return UserCard(user: user);
                  },
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text(e.toString())),
          ),
        ],
      ),
    );
  }
}
