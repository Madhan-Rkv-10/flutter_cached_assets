import 'dart:typed_data';
import 'package:http/http.dart' as http;

final class Utils {
  Utils._();
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
}

extension GetImageType on String {
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

enum ImageType { global, svg, json }
