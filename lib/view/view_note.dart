import 'package:flutter/material.dart';
import 'package:my_simple_note/controller/note_controller.dart';
import 'package:my_simple_note/view/edit_note.dart';

class ViewNoteScreen extends StatelessWidget {
  final int? id;
  final String title;
  final String body;
  final String date;
  final Color color;
  final Function onDelete;

  final NoteController controller = NoteController();

  ViewNoteScreen({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "View Note",
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16.0),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                final updatedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(
                      id: id,
                      title: title,
                      body: body,
                      date: date,
                      color: color,
                    ),
                  ),
                );

                // update the view
                if (updatedNote != null) {
                  onDelete();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _showDeleteConfirmationDialog(context),
            ),
          ],
        ),
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Divider(),
            Text(
              date,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              body,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete',style: TextStyle(color: Colors.red)),
              onPressed: () async {
                if (id != null) {
                  await controller.deleteNote(id!);
                  onDelete();
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
