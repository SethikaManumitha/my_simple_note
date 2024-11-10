import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_simple_note/controller/note_controller.dart';
import 'package:my_simple_note/model/note.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  String title = '';
  String body = '';
  String selectedColor = "blue";
  final NoteController controller = NoteController();
  final FocusNode bodyFocusNode = FocusNode(); // Focus node for the body field

  final Map<String, String> colorMeanings = {
    'red': 'Urgent',
    'yellow': 'Personal',
    'green': 'Work',
    'blue': 'General',
  };

  @override
  void dispose() {
    bodyFocusNode.dispose(); // Dispose the focus node when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Create Note", style: TextStyle(color: Colors.white, fontSize: 25.0)),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Color:", style: TextStyle(fontSize: 16.0)),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colorMeanings.keys.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getColor(color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.black : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        colorMeanings[color]!,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => setState(() => title = value),
            ),
            TextField(
              focusNode: bodyFocusNode,
              decoration: InputDecoration(
                labelText: 'Body',
                alignLabelWithHint: true,
                border: bodyFocusNode.hasFocus ? InputBorder.none : const UnderlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => setState(() => body = value),
            ),
          ],
        ),
      ),

      // Pass a note object into the controller when clicked
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String creationDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          Note newNote = Note(
            title: title,
            body: body,
            date: creationDate,
            color: selectedColor,
          );
          controller.insertNote(newNote);
          Navigator.pop(context);
        },
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.add,color: Colors.white),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'blue':
      default:
        return Colors.blue;
    }
  }
}
