library flutter_virtual_piano;

import 'package:flutter/material.dart';

class VirtualPiano extends StatefulWidget {
  /// The range of notes to render on the Piano.
  /// Note ranges are defined by their MIDI note values, so a value of 0 equals C-1 and a value of 127 equals G9.
  /// Values outside of this 0..127 range are invalid.
  final RangeValues noteRange;

  /// A list of sets of notes to be highlighted (colored).
  final List<HighlightedNoteSet>? highlightedNoteSets;

  /// Called when a key is pressed/touched.
  /// Parameters are the note of the key (int) and the vertical position of the touch on the key (double)
  final Function(int, double)? onNotePressed;

  /// Called when a key is released.
  final Function()? onNoteReleased;

  /// Called when a vertical drag/slide is performed on a key.
  /// Parameters are the note of the key (int) and the vertical position of the drag on the key (double)
  final Function(int, double)? onNotePressSlide;

  /// The color to render white keys.
  final Color whiteKeyColor;

  /// The color to render black keys.
  final Color blackKeyColor;

  /// The (material) elevation of the piano keys
  final double elevation;

  /// The width of the border around each key
  final double borderWidth;

  /// The blend between keys highlight color and base color
  final double keyHighlightColorBlend;

  const VirtualPiano({
    Key? key,
    required this.noteRange,
    this.highlightedNoteSets,
    this.onNotePressed,
    this.onNotePressSlide,
    this.onNoteReleased,
    this.whiteKeyColor = Colors.white,
    this.blackKeyColor = Colors.black,
    this.elevation = 2,
    this.borderWidth = 0.5,
    this.keyHighlightColorBlend = 0.8,
  }) : super(key: key);

  @override
  State<VirtualPiano> createState() => _VirtualPianoState();
}

class _VirtualPianoState extends State<VirtualPiano> {
  //#region keys
  static const _whites = [
    0,
    2,
    4,
    5,
    7,
    9,
    11,
    12,
    14,
    16,
    17,
    19,
    21,
    23,
    24,
    26,
    28,
    29,
    31,
    33,
    35,
    36,
    38,
    40,
    41,
    43,
    45,
    47,
    48,
    50,
    52,
    53,
    55,
    57,
    59,
    60,
    62,
    64,
    65,
    67,
    69,
    71,
    72,
    74,
    76,
    77,
    79,
    81,
    83,
    84,
    86,
    88,
    89,
    91,
    93,
    95,
    96,
    98,
    100,
    101,
    103,
    105,
    107,
    108,
    110,
    112,
    113,
    115,
    117,
    119,
    120,
    122,
    124,
    125,
    127
  ];

  static const _blacks = [
    1,
    3,
    0,
    6,
    8,
    10,
    0,
    13,
    15,
    0,
    18,
    20,
    22,
    0,
    25,
    27,
    0,
    30,
    32,
    34,
    0,
    37,
    39,
    0,
    42,
    44,
    46,
    0,
    49,
    51,
    0,
    54,
    56,
    58,
    0,
    61,
    63,
    0,
    66,
    68,
    70,
    0,
    73,
    75,
    0,
    78,
    80,
    82,
    0,
    85,
    87,
    0,
    90,
    92,
    94,
    0,
    97,
    99,
    0,
    102,
    104,
    106,
    0,
    109,
    111,
    0,
    114,
    116,
    118,
    0,
    121,
    123,
    0,
    126
  ];
  //#endregion

  Color? _colorForNote(int note) {
    for (int i = 0; i < (widget.highlightedNoteSets?.length ?? 0); i++) {
      var set = widget.highlightedNoteSets![i];
      if (set.noteValues.contains(note)) {
        return set.highlightColor;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var minValue = widget.noteRange.start.clamp(0, 127);
      var maxValue = widget.noteRange.end.clamp(0, 127);

      assert(minValue < maxValue);

      var firstWhiteKey = _whites.indexOf(_whites.firstWhere((value) => value > minValue)) - 1;
      var lastWhiteKey = _whites.lastIndexWhere((value) => value < maxValue) + 2;
      var whiteKeyCount = lastWhiteKey - firstWhiteKey;

      var firstBlackKey = _blacks.indexOf(_blacks.firstWhere((value) => value > minValue));
      var lastBlackKey = _blacks.lastIndexWhere((value) => value != 0 && value < maxValue) + 1;
      var blackKeyCount = lastBlackKey - firstBlackKey;

      var keyWidth = constraints.maxWidth / whiteKeyCount;
      var keyHeight = constraints.maxHeight;

      return Stack(
        alignment: Alignment.topLeft,
        children: [
          Row(
            // white
            children: List.generate(whiteKeyCount, (index) {
              var note = _whites[firstWhiteKey + index];
              return _PianoKey(
                note: note,
                width: keyWidth,
                height: keyHeight,
                color: Color.lerp(widget.whiteKeyColor, _colorForNote(note) ?? widget.whiteKeyColor, widget.keyHighlightColorBlend),
                onNotePressed: widget.onNotePressed,
                onNoteReleased: widget.onNoteReleased,
                onNotePressSlide: widget.onNotePressSlide,
                elevation: widget.elevation,
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: keyWidth / 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // black
              children: List.generate(blackKeyCount, (index) {
                var width = keyWidth;
                var note = _blacks[firstBlackKey + index];
                return Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: keyWidth / 6.0),
                  child: note != 0
                      ? _PianoKey(
                          note: note,
                          width: width,
                          height: keyHeight * 0.6,
                          color: Color.lerp(widget.blackKeyColor, _colorForNote(note) ?? widget.blackKeyColor, widget.keyHighlightColorBlend),
                          onNotePressed: widget.onNotePressed,
                          onNoteReleased: widget.onNoteReleased,
                          onNotePressSlide: widget.onNotePressSlide,
                        )
                      : SizedBox(
                          width: width,
                        ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}

class _PianoKey extends StatelessWidget {
  final bool showKeyLabel;
  final int note;
  final Color? color;
  final Color? borderColor;
  final double width;
  final double height;
  final double elevation;
  final double borderWidth;

  final Function(int, double)? onNotePressed;
  final Function()? onNoteReleased;
  final Function(int, double)? onNotePressSlide;

  const _PianoKey({
    this.showKeyLabel = false,
    required this.note,
    this.color,
    this.borderColor,
    required this.width,
    required this.height,
    Key? key,
    this.onNoteReleased,
    this.onNotePressed,
    this.onNotePressSlide,
    this.elevation = 2.0,
    this.borderWidth = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.only(bottomLeft: Radius.circular(width / 6), bottomRight: Radius.circular(width / 6));

    return Material(
      elevation: elevation,
      borderRadius: borderRadius,
      child: GestureDetector(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor ?? Colors.grey.shade700, width: borderWidth),
            borderRadius: borderRadius,
          ),
          child: showKeyLabel
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    _midiToNoteValue(note),
                    style: TextStyle(color: Colors.grey.shade700),
                  ))
              : null,
        ),
        onTapDown: onNotePressed != null
            ? (details) {
                onNotePressed!(note, details.localPosition.dy / height);
              }
            : null,
        onTapUp: onNoteReleased != null
            ? (details) {
                onNoteReleased!();
              }
            : null,
        onTapCancel: onNoteReleased != null
            ? () {
                onNoteReleased!();
              }
            : null,
        onVerticalDragUpdate: onNotePressSlide != null
            ? (details) {
                onNotePressSlide!(note, details.localPosition.dy / height);
              }
            : null,
      ),
    );
  }

  static const noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
  static String _midiToNoteValue(int midiValue) {
    var noteIndex = midiValue % 12;
    var octave = _midiOctave(midiValue);
    String name = noteNames[noteIndex];
    var slashIndex = name.indexOf("/");
    if (slashIndex > -1) {
      name = name.replaceRange(slashIndex, slashIndex, "$octave");
    }
    return name + "$octave";
  }

  static int _midiOctave(int midiValue) {
    return (midiValue / 12).floor() - 1;
  }
}

/// A data structure for defining notes to be highlighted and the color the keys should have.
class HighlightedNoteSet {
  final Color highlightColor;
  final Set<int> noteValues;

  const HighlightedNoteSet(this.noteValues, this.highlightColor);
}
