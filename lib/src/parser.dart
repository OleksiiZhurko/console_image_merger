import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'const/colors.dart';
import 'dto/dto.dart';

/// Transformation of the received info into the [Dto] required for conversion
///
/// May throw following errors: [FormatException], [FileSystemException]
class Parser {
  /// Creates [Dto] according to the received data
  ///
  /// May throw [FormatException] (when there must be a number in the line, but
  /// it is not), [FileSystemException] (when the path is incorrect or the file
  /// name is given)
  Dto call(String string1, List<String> string2) {
    if (string2.length == 1) {
      return Dto(
          directory: Directory(string1),
          saveFile: File(string2[0]),
          color: TRANSPARENT);
    } else if (string2.length == 2) {
      return Dto(
          directory: Directory(string1),
          saveFile: File(string2[0]),
          color: littleEndianColor(int.parse(string2[1])));
    } else {
      throw FormatException();
    }
  }

  /// Represents a number in [Endian.little] format
  ///
  /// May throw [FormatException]
  @visibleForTesting
  int littleEndianColor(int color) {
    String number = color.toRadixString(16);

    return (ByteData(32)..setUint32(0, int.parse(
                  (number.length < 7) ? '0x${number}ff' : '0x$number')))
        .getUint32(0, Endian.little);
  }
}