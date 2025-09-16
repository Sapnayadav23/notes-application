import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes_app/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Map<String, String> note;

  const NoteDetailsScreen({super.key, required this.note});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  Future<void> _deleteNote() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList = prefs.getStringList("notes") ?? [];

    // Remove the note
    notesList.removeWhere((e) {
      final map = Map<String, String>.from(jsonDecode(e));
      return map['title'] == widget.note['title'] &&
          map['subtitle'] == widget.note['subtitle'];
    });

    await prefs.setStringList("notes", notesList);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Note Details",
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Note"),
                  content:
                      const Text("Are you sure you want to delete this note?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () {
                          _deleteNote();
                          Navigator.pop(context);
                        },
                        child: const Text("Delete")),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.note['title']!,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(widget.note['subtitle']!,
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
