import 'dart:io';

import 'package:meta/meta.dart';

/// This object used to transfer information about the path to the processed
/// directory, the path of saving and the color of the canvas
class Dto {
  /// The processing directory
  Directory directory;
  /// Save result
  File saveFile;
  /// The canvas color
  int color;

  Dto({
    @required this.directory,
    @required this.saveFile,
    @required this.color
  });
}