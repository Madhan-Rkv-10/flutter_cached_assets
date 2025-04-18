import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// --- MAIN APP ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationCacheDirectory();
  await Hive.openBox("myBox", path: dir.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UserScreen(),
    );
  }
}

// --- UI TO DISPLAY USER DATA ---
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<User> userFuture;
  final Box box = Hive.box("myBox");
  final String sampleJson =
      '''{"data": { "name": "Alen","image": "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg","local": false,"imageType": "jpg"}}''';

  @override
  void initState() {
    super.initState();
    userFuture = _loadUser();
  }

  Future<User> _loadUser() async {
    final data = await box.get("sample-data");
    if (data != null) {
      return await Future.value(User.fromJson(data));
    } else {
      final jsonMap = jsonDecode(sampleJson)["data"];
      final res = await Future.value(User.fromJson(jsonMap));
      box.put("sample-data", res.toJson());
      return res;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Caching Example')),
      body: FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.image == null) {
            return const Center(child: Text('Failed to load user.'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  user.name ?? 'No Name',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    user.image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Image Type: ${user.imageType?.toString().split('.').last}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- ENUM & EXTENSIONS ---
enum RawImageType { global, svg, json }

extension GetImageType on String {
  RawImageType? getImageType() {
    if (contains('.svg')) return RawImageType.svg;
    if (contains('.json')) return RawImageType.json;
    return RawImageType.global;
  }
}

extension GetStringType on RawImageType {
  String getImageType() {
    if (this == RawImageType.global) {
      return ".png";
    } else if (this == RawImageType.svg) {
      return ".svg";
    } else {
      return ".json";
    }
  }
}

extension ConvertToUint on List<dynamic> {
  Uint8List convertLocalDataTOUint8List() {
    List<int> intList = map((value) => int.parse("$value")).toList();
    return Uint8List.fromList(intList);
  }
}

// --- NETWORK IMAGE UTILITY ---
class Utils {
  static Future<Uint8List?> getConvertedUintListData({
    required String image,
  }) async {
    final http.Response response = await http.get(Uri.parse(image));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }
}

// --- USER MODEL ---
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
  factory User.create() {
    return User._internal();
  }
  static Future<User> fromJson(Map<dynamic, dynamic> json) async {
    RawImageType? type;
    Uint8List? formattedImage;

    final isFromLocal = json["local"] ?? false;
    if (isFromLocal) {
      final imageFormat = json["imageType"] as String;
      final List<dynamic> localImage = json['image'];
      formattedImage = localImage.convertLocalDataTOUint8List();
      type = imageFormat.getImageType();
    } else {
      final imageUrl = json["image"];
      formattedImage =
          imageUrl != null
              ? await Utils.getConvertedUintListData(image: imageUrl)
              : null;

      final String rawImageType = json["image"] ?? "";
      final String? imageFormat = json["imageType"];
      type =
          imageFormat != null
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

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "imageUrl": imageUrl,
      "local": true,
      "imageType": imageType!.getImageType(),
    };
  }
}
