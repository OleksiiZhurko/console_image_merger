import 'dart:io';

import 'package:collection/collection.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';

import 'const/colors.dart';
import 'const/image_formats.dart';
import 'dto/dto.dart';
import 'printer/printer.dart';

/// Working with images
///
/// May throw following errors: [RangeError], [FileSystemException], [Exception]
class ImageMerger {
  /// To iterate over an array of pictures
  int _index;
  /// [Image.width]
  int _imageW;
  /// [Image.height]
  int _imageH;
  /// Number of pictures in width
  int _nImgW;
  /// Number of pictures in height
  int _nImgH;
  /// Template picture
  Image _img;
  Image _mergedImage;
  List<String> _pathsToImages;

  /// Facade of creating a new picture
  void call(Dto dto) {
    _produceFileNames(dto.directory);
    _pathsToImages.forEach(print);
    _createImageTemplate(_pathsToImages[0]);
    _createFilledCanvas(createCanvas(_imageW, _imageH, _pathsToImages.length), dto.color);
    printer('LOG:', param: 'canvas was filled', newLine: '\n');
    _merge();
    printer('LOG:', param: 'images were merged', newLine: '\n');
    _saveImg(dto.saveFile);
  }

  /// Getting paths to all files
  void _produceFileNames(Directory dir) =>
      _pathsToImages = dir.listSync()
          .whereType<File>()
          .map((file) => file.path)
          .toList()
        ..sort(compareNatural);

  /// Filling the canvas with color
  void _createFilledCanvas(Image image, int color) =>
    _mergedImage = (color != TRANSPARENT) ? image.fill(color) : image;

  /// Creating a template picture
  void _createImageTemplate(String path) {
    _img = decodeImage((File(path)).readAsBytesSync());
    _imageW = _img.width;
    _imageH = _img.height;
  }

  /// Canvas creation
  @visibleForTesting
  Image createCanvas(int width, int height, int images) {
    _nImgW = 1;
    _nImgH = 1;

    if (width < height) {
      while (_nImgW * _nImgH < images) _nImgW = ++_nImgH * height ~/ width;
      while (_nImgH * (_nImgW - 1) >= images) --_nImgW;
    } else {
      while (_nImgW * _nImgH < images) _nImgH = ++_nImgW * width ~/ height;
      while (_nImgW * (_nImgH - 1) >= images) --_nImgH;
    }

    printer('LOG: sizes', param: '$_nImgW $_nImgH', newLine: '\n');

    return Image(_nImgW * width, _nImgH * height);
  }

  /// Merging pictures together
  ///
  /// May throw [RangeError] (if the length does not match),
  /// [FileSystemException] (in case of problems with the file)
  void _merge() {
    _index = 0;

    for (var one = 0; one < _nImgH; one++) {
      for (var two = 0; two < _nImgW; two++) {
        if (_index < _pathsToImages.length) {
          copyInto(
              _mergedImage,
              decodeImage((File(_pathsToImages[_index++])).readAsBytesSync()),
              dstX: _imageW * two,
              dstY: _imageH * one,
              blend: false
          );
        } else {
          return;
        }
      }
    }
  }

  /// Converting to the desired type and saving
  ///
  /// May throw [Exception] (when the requested save type cannot be so large)
  void _saveImg(File resultFile) {
    int _indexDot = resultFile.path.lastIndexOf('.');

    if (_indexDot + 1 != resultFile.path.length) {
      switch(resultFile.path.substring(_indexDot + 1)) {
        case JPG:
        case JPG_JPEG:
        case JPG_JPE:
        case JPG_JIF:
        case JPG_JFIF:
        case JPG_JFI:
          resultFile.writeAsBytesSync(encodeJpg(_mergedImage));
          printer('LOG: format', param: '.$JPG', newLine: '\n');
          return;
        case GIF:
          resultFile.writeAsBytesSync(encodeGif(_mergedImage));
          printer('LOG: format', param: '.$GIF', newLine: '\n');
          return;
        case ICO:
          resultFile.writeAsBytesSync(encodeIco(_mergedImage));
          printer('LOG: format', param: '.$ICO', newLine: '\n');
          return;
        case TGA:
        case TGA_ICB:
        case TGA_VDA:
        case TGA_VST:
          resultFile.writeAsBytesSync(encodeTga(_mergedImage));
          printer('LOG: format', param: '.$TGA', newLine: '\n');
          return;
        case CUR:
          resultFile.writeAsBytesSync(encodeCur(_mergedImage));
          printer('LOG: format', param: '.$CUR', newLine: '\n');
          return;
      }
    }

    resultFile.writeAsBytesSync(encodePng(_mergedImage));
    printer('LOG: format', param: '.$PNG', newLine: '\n');
  }
}