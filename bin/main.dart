import 'package:Images/src/controller.dart';
import 'package:Images/src/merger.dart';
import 'package:Images/src/parser.dart';

void main() {
  Controller(parser: Parser(), imageMerger: ImageMerger())();
}

