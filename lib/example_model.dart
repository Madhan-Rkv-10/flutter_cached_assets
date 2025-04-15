// import 'dart:convert';
// import 'dart:typed_data';

// // Helper class to define the image type (optional)
// class RawImageType {
//   final String type;
//   RawImageType(this.type);

//   static RawImageType? getImageType(String imageFormat) {
//     switch (imageFormat) {
//       case "JPEG":
//         return RawImageType("JPEG");
//       case "PNG":
//         return RawImageType("PNG");
//       default:
//         return null;
//     }
//   }
// }

// // Extension to decode the base64 image
// extension ImageConversion on String {
//   // Convert base64 string to Uint8List
//   Uint8List toUint8List() {
//     return base64Decode(this);
//   }
// }

// class User {
//   String? name;
//   Uint8List? image;
//   String? imageUrl;
//   final bool local;
//   final RawImageType? imageType;

//   User._internal({
//     this.name,
//     this.image,
//     this.imageUrl,
//     this.local = false,
//     this.imageType,
//   });

//   // Deserialize from JSON
//   static Future<User> fromJson(Map<String, dynamic> json) async {
//     RawImageType? type;
//     Uint8List? formattedImage;

//     final isFromLocal = json["local"] ?? false;
//     if (isFromLocal) {
//       // Decode the base64 image data if the image is from local
//       final image = json["image"] as String?;
//       formattedImage = image?.toUint8List();

//       // If image type is provided, map it to RawImageType
//       final String imageFormat = json["imageUrl"] ?? "Unknown";
//       type = RawImageType.getImageType(imageFormat);
//     } else {
//       // Handle non-local image logic (if needed)
//       formattedImage = json["image"] != null
//           ? base64Decode(json["image"]) // Fallback to base64 decode
//           : null;

//       final String rawImageType = json["imageUrl"] ?? "";
//       type = RawImageType.getImageType(rawImageType) ?? RawImageType("Unknown");
//     }

//     return User._internal(
//       name: json["name"] ?? "",
//       image: formattedImage,
//       imageUrl: json["imageUrl"],
//       local: json['local'] ?? false,
//       imageType: type,
//     );
//   }

//   // Serialize to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "image": image != null ? base64Encode(image!) : null,
//       "imageUrl": imageUrl,
//       "local": true,
//       "imageType": imageType?.type ?? "Unknown",
//     };
//   }
// }

// void main() async {
//   const sampleJson = '''
//   {
//     "data": {
//       "name": "Alen",
//       "imageUrl": "",
//       "image": "aGVsbG8=",
//       "local": true
//     }
//   }
//   ''';

//   final jsonMap = jsonDecode(sampleJson)["data"];
//   final user = await User.fromJson(jsonMap);

//   // Printing out the result
//   print("Name: ${user.name}");
//   print("Image type: ${user.imageType?.type}");
//   print("Image (base64): ${base64Encode(user.image!)}");

//   // Serialize back to JSON
//   final jsonData = jsonEncode(user.toJson());
//   print("Serialized JSON: $jsonData");
// }
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

// Enum to represent different image types
enum RawImageType {
  global,
  svg,
  json,
}

// Extension on String to determine the RawImageType based on the file extension
extension GetImageType on String {
  RawImageType getImageType() {
    if (contains('.svg')) {
      return RawImageType.svg;
    } else if (contains(".json")) {
      return RawImageType.json;
    } else {
      return RawImageType.global;
    }
  }
}

// Extension on List<dynamic> to convert local data to Uint8List
extension ConvertToUint on List<dynamic> {
  Uint8List convertLocalDataTOUint8List() {
    List<int> intList = map((value) => int.parse("$value")).toList();
    return Uint8List.fromList(intList);
  }
}

// Static method to convert an image URL into Uint8List by fetching it via HTTP request
class HomeScreenUtils {
  static Future<Uint8List?> getConvertedUintListData(
      {required String image}) async {
    final http.Response response = await http.get(Uri.parse(image));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }
}

// The User model class
class User {
  String? name;
  Uint8List? image;
  String? imageUrl;
  final bool local;
  final RawImageType? imageType;

  User._internal({
    this.name,
    this.image,
    this.imageUrl,
    this.local = false,
    this.imageType,
  });

  // Deserialize from JSON
  static Future<User> fromJson(Map<String, dynamic> json) async {
    RawImageType? type;
    Uint8List? formattedImage;

    final isFromLocal = json["local"] ?? false;
    if (isFromLocal) {
      // For local images
      final imageFormat = json["imageType"];
      final List<dynamic> localImage = json['image'];
      formattedImage = localImage.convertLocalDataTOUint8List();
      type = imageFormat.getImageType();
    } else {
      // For remote images (URLs)
      final imageUrl = json["image"];
      formattedImage = imageUrl != null
          ? await HomeScreenUtils.getConvertedUintListData(image: imageUrl)
          : null;

      final String rawImageType = json["image"] ?? "";
      final String? imageFormat = json["imageType"];
      type = imageFormat != null
          ? imageFormat.getImageType()
          : rawImageType.getImageType();
    }

    return User._internal(
      name: json["name"] ?? "",
      image: formattedImage,
      imageUrl: json["imageUrl"],
      local: json['local'] ?? false,
      imageType: type,
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image != null ? base64Encode(image!) : null,
      "imageUrl": imageUrl,
      "local": local,
      "imageType": imageType?.toString().split('.').last ?? "Unknown",
    };
  }
}

void main() async {
  // Sample JSON input
  const sampleJson = '''
  {
    "data": {
      "name": "Alen",
      "imageUrl": "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
      "image": "aGVsbG8=",
      "local": true,
      "imageType": "jpg"
    }
  }
  ''';

  final jsonMap = jsonDecode(sampleJson)["data"];
  final user = await User.fromJson(jsonMap);

  // Printing out the result
  print("Name: ${user.name}");
  print("Image type: ${user.imageType}");
  print("Image (base64): ${base64Encode(user.image!)}");

  // Serialize back to JSON
  final jsonData = jsonEncode(user.toJson());
  print("Serialized JSON: $jsonData");
}
