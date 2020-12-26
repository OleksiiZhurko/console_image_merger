import 'package:test/test.dart';

import 'package:Images/src/parser.dart';

void main() {
  Parser parser;

  setUp(() {
    parser = Parser();
  });

  group('littleEndianColor', () {
    test('Case 1_1, hex string length < 7', () {
      final testColor = int.parse('0xff0000ff');
      final color = int.parse('0xff0000');
      final result = parser.littleEndianColor(color);

      expect(result, testColor);
    });

    test('Case 1_2, hex string length < 7', () {
      final testColor = int.parse('0xff63b428');
      final color = int.parse('0x28b463');
      final result = parser.littleEndianColor(color);

      expect(result, testColor);
    });

    test('Case 2_1, hex string length is 8', () {
      final testColor = int.parse('0xff00ffaa');
      final color = int.parse('0xaaff00ff');
      final result = parser.littleEndianColor(color);

      expect(result, testColor);
    });

    test('Case 2_2, hex string length is 7', () {
      final testColor = int.parse('0xa63b428');
      final color = int.parse('0x28b4630a');
      final result = parser.littleEndianColor(color);

      expect(result, testColor);
    });
  });
}