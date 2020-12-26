import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'failure/failures.dart';
import 'merger.dart';
import 'parser.dart';
import 'printer/printer.dart';

/// This object responsible for interacting with the processing program
class Controller {
  /// Variables for displaying
  final PATH_TO_MERGE = 'Path to merge: ';
  final PATH_TO_SAVE = 'Path to save: ';
  final ERROR = 'ERROR:';
  final END_SEPARATOR = '\n' * 2;

  final Parser parser;
  final ImageMerger imageMerger;

  /// To calculate the elapsed time
  int time;

  /// Path to directory
  String input1;
  /// File to save and color of the canvas
  List<String> input2;

  Controller({
    @required this.parser,
    @required this.imageMerger
  });

  /// Produces user interactions
  void call() {
    for(;;) {
      printer(PATH_TO_MERGE);
      input1 = _getInputString();
      printer(PATH_TO_SAVE);
      input2 = _getSplittedString(_getInputString());

      time = DateTime.now().millisecondsSinceEpoch;

      if (_createNewImage().isRight()) {
        // if there are no errors the merge was successful
        printer('Successfully saved', newLine: '\n');
        _elapsedTime();
      }
    }
  }

  /// Possible exception handler
  Either<Failure, void> _createNewImage() {
    try {
      return Right(imageMerger(parser(input1, input2)));
    }
    on RangeError { // problems with picture size
      printer(ERROR,
          param: 'dimensions images are mismatched!!!', newLine: END_SEPARATOR);
      return Left(RangeFailure());
    }
    on FormatException { // problems with parsing received data
      printer(ERROR, param: 'input error!!!', newLine: END_SEPARATOR);
      return Left(FormatFailure());
    }
    on FileSystemException { // wrong way to folder or file
      printer(ERROR, param: 'path error!!!', newLine: END_SEPARATOR);
      return Left(FileSystemFailure());
    }
    on NoSuchMethodError { // empty values
      printer(ERROR, param: 'empty path!!!', newLine: END_SEPARATOR);
      return Left(EmptyPathFailure());
    }
    on Exception { // conversion is not possible
      printer(ERROR, param: 'to large file!!!', newLine: END_SEPARATOR);
      return Left(SizeFailure());
    }
  }

  /// Timing
  void _elapsedTime() =>
    printer('Elapsed time',
        param: '${(DateTime.now().millisecondsSinceEpoch - time) / 1000} s',
        newLine: END_SEPARATOR);

  /// Splitting information by spaces
  List<String> _getSplittedString(String input) => input.trim().split(' ');

  /// Receiving the information
  String _getInputString() => stdin.readLineSync();
}