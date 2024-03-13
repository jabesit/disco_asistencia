import 'package:disco_asistencia/model/user.dart';
import 'package:disco_asistencia/services/mongo.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isAdmisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Rut: ',
              ),
              Text(
                widget.user.rut == null
                    ? "no_value"
                    : widget.user.rut.toString().toUpperCase(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.fullName == null
                    ? "no_value"
                    : widget.user.fullName.toString().toUpperCase(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.birthday ?? "no_value",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Es Admisible?',
              ),
              Icon(widget.user.isAdmisible ? Icons.check_box : Icons.close),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onDoubleTap: () async {
              widget.user.isAdmisible = !widget.user.isAdmisible;
              Mongo.changeAdmisibleUser(widget.user);
              setState(() {});
            },
            child: Container(
              color: widget.user.isAdmisible ? Colors.green : Colors.red,
              height: 50,
              child: Center(
                  child: Text(widget.user.isAdmisible
                      ? "Puede Ingresar"
                      : "No Puede Ingresar")),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar')),
        ],
      ),
    );
  }
}
