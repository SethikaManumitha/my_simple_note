import 'package:flutter/material.dart';
import 'view_note.dart';

class NoteCard extends StatelessWidget {
  final int? id;
  final String title;
  final String body;
  final String date;
  final Color color;
  final Function onDelete;

  const NoteCard({
    Key? key,
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.color,
    required this.onDelete,
  }) : super(key: key);

  String _getLabelFromColor(Color color) {
    switch (color) {
      case Colors.red:
        return "U";
      case Colors.blue:
        return "G";
      case Colors.orange:
        return "P";
      case Colors.green:
        return "W";
      default:
        return "C";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewNoteScreen(
                id: id,
                title: title,
                body: body,
                date: date,
                color: color,
                onDelete: onDelete,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: color,
              radius: 20.0,
              child: Text(
                  _getLabelFromColor(color),
                  style: const TextStyle(color: Colors.white),
              )),
          title: Text(title, style: const TextStyle(fontSize: 20.0)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date),
            ],
          ),
        ),
      ),
    );
  }
}


