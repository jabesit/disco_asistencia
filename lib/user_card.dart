import 'package:disco_asistencia/model/user.dart';
import 'package:disco_asistencia/services/mongo.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final User user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(196, 196, 196, 1),
      child: ListTile(
        onTap: null,
        // leading: CircleAvatar(backgroundImage: AssetImage(user.imgUrl)),
        title: Text(
          "rut", //widget.user.name ?? "no_name",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.user.rut ?? "no_id",
        ),
        trailing: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundColor: widget.user.isAdmisible ? Colors.green : Colors.red,
                child: IconButton(
                    onPressed: () {
                      widget.user.isAdmisible = !widget.user.isAdmisible;
                      Mongo.changeAdmisibleUser(widget.user);
                      setState(() {});
                    },
                    icon: Icon(
                      widget.user.isAdmisible ? Icons.check : Icons.block,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
