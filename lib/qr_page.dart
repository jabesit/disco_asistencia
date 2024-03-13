// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:disco_asistencia/model/user.dart';
import 'package:disco_asistencia/provider/user_provider.dart';
import 'package:disco_asistencia/utils/convert.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QRPage extends ConsumerWidget {
  final String name = "QRPage";
  MobileScannerController cameraController = MobileScannerController();
  final userProvider =
      StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
  late String rut = "no_rut";

  QRPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(rut),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                String text = barcode.rawValue!;
                String? rutConverted = User.empty().rutFromQR(text);
                if (rutConverted != null) {
                  rut = rutConverted;
                  log("rut $rut");
                  cameraController.stop();
                  Convert.showProfile2(context, rut)
                      .whenComplete(() => cameraController.start());
                }
              }
            }
          },
        ),
      ),
    );
  }
}
