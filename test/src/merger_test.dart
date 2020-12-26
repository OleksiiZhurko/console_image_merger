import 'package:Images/src/merger.dart';
import 'package:test/test.dart';

void main() {
  ImageMerger imageMerger;

  setUp(() {
    imageMerger = ImageMerger();
  });

  group('createCanvas', () {
    test('Case 1', () {
      final testWidth = 980 * 7;
      final testHeight = 1141 * 7;
      final width = 980;
      final height = 1141;
      final images = 49;
      final image = imageMerger.createCanvas(width, height, images);

      expect(image.width, testWidth);
      expect(image.height, testHeight);
    });

    test('Case 2', () {
      final testWidth = 1727 * 6;
      final testHeight = 941 * 11;
      final width = 1727;
      final height = 941;
      final images = 62;
      final image = imageMerger.createCanvas(width, height, images);

      expect(image.width, testWidth);
      expect(image.height, testHeight);
    });

    test('Case 3', () {
      final testWidth = 1024 * 3;
      final testHeight = 1024 * 3;
      final width = 1024;
      final height = 1024;
      final images = 9;
      final image = imageMerger.createCanvas(width, height, images);

      expect(image.width, testWidth);
      expect(image.height, testHeight);
    });
  });
}