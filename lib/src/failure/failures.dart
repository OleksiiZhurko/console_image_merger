import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const<dynamic>[]]) : super(properties);
}

class SizeFailure extends Failure {}

class RangeFailure extends Failure {}

class FormatFailure extends Failure {}

class EmptyPathFailure extends Failure {}

class FileSystemFailure extends Failure {}
