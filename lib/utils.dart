import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

/// A utility class containing static methods and extensions.
final class Utils {
  Utils._(); // Private constructor to prevent instantiation.

  /// Fetches image data from the provided URL and converts it into a [Uint8List].
  ///
  /// The [image] parameter is a URL string pointing to the image resource.
  /// Returns the image data as a [Uint8List] if the request is successful (status code 200),
  /// otherwise returns null.
  static Future<Uint8List?> getConvertedUintListData(
      {required String image}) async {
    final http.Response response = await http.get(Uri.parse(image));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return bytes;
    } else {
      return null;
    }
  }

  static Future<Uint8List?> getAndUpdateToLocal({
    required String boxName,
    keyName,
    image,
  }) async {
    final Box box = Hive.box(boxName);
    final data = box.get(keyName);
    if (data != null) {
      return data;
    } else {
      final response = await getConvertedUintListData(image: image);
      if (response != null) {
        box.put(keyName, response);
        return response;
      } else {
        return null;
      }
    }
  }
}

/// Extension on [String] to determine the [ImageType] based on the file extension.
extension GetImageType on String {
  /// Determines the [ImageType] of the string (assumed to be a file path or URL).
  ///
  /// If the string contains ".svg", returns [ImageType.svg].
  /// If the string contains ".json", returns [ImageType.json].
  /// Otherwise, returns [ImageType.global].
  ImageType getImageType() {
    if (contains('.svg')) {
      return ImageType.svg;
    } else if (contains(".json")) {
      return ImageType.json;
    } else {
      return ImageType.global;
    }
  }
}

/// Enum representing the different types of images that can be displayed.
enum ImageType {
  /// Represents a global or raster image type.
  global,

  /// Represents an SVG image type.
  svg,

  /// Represents a Lottie JSON animation type.
  json,
}

extension GetErrorImage on num? {
  getErrorImage() => Icon(Icons.error, size: double.parse("$this"));
}
