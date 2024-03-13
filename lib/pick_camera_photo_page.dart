// ignore_for_file: use_build_context_synchronously
import 'package:camera/camera.dart';
import 'package:disco_asistencia/utils/convert.dart';
import 'package:disco_asistencia/widget/camera/flutter_camera_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraOverlayPage extends ConsumerWidget {
  final List<CameraDescription> cameras;

  const CameraOverlayPage(this.cameras, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: cameras.isEmpty
          ? const Center(
              child: Text(
                'No camera found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : CameraOverlay(
              cameras.first,
              loadingWidget: Container(
                color: Colors.white,
              ),
              (XFile file) async {
                print("captured " + file.path);

                Convert.showProfile(file, context, ref);
              },
              info:
                  'Posiciona tu tarjeta Identicacion dentro del rectangulo y asegurate que la imagen sea legible',
              label: 'Scaneando Carnet',
            ),
    );
  }
}
