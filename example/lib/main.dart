import 'package:flutter/material.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Piano"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          height: 80,
          child: VirtualPiano(
            noteRange: const RangeValues(60, 72),
            highlightedNoteSets: const [
              // HighlightedNoteSet({44, 55, 77, 32}, Colors.green),
              // HighlightedNoteSet({34, 45, 67, 32}, Colors.blue)
            ],
            onNotePressed: (note, pos) {
              print("note pressed $note pressed at $pos");
            },
            onNoteReleased: (note) {
              print("note released $note");
            },
            onNotePressSlide: (note, pos) {
              print("note slide $note pressed at $pos");
            },
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
