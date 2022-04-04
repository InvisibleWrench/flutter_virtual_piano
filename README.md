A virtual piano for flutter, that renders the keys of a piano and with support for interaction and highlighting.

## Features

Keys are based on MIDI note values so middle C (4) is 63.
Key callback are `onNoteReleased`, `onNotePressed` and `onNotePressSlide`.
onNoteReleased and onNotePressSlide has two arguments, the relevant note and the vertical position of the touch/slide on the key. The latter can be used for simulating variable velocity or polyphonic aftertouch.


## Usage

```dart
VirtualPiano(
noteRange: const RangeValues(21, 108),
highlightedNoteSets: const [
HighlightedNoteSet({44, 55, 77, 32}, Colors.green),
],
onNotePressed: (note, pos) {
// Play note
},
)
```