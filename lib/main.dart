import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_assets/utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.openBox("myBox", path: dir.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cached Assets',
      home: SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({super.key});

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final imageUrl =
      "https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg";
  final gifUrl = "https://i.gifer.com/J4o.gif";
  final Box box = Hive.box("myBox");
  final myJson =
      "https://lottie.host/52fb4acd-10a3-43b2-9667-7729b7309284/hpuwuYuwVO.json";
  Uint8List? image;
  final offerImageJson =
      "https://s3.ap-south-1.amazonaws.com/innopay-dev/Banner/eid-1-innopay.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240619T132030Z&X-Amz-SignedHeaders=host&X-Amz-Expires=86400&X-Amz-Credential=AKIA5PCHL76R5WIEFNEH%2F20240619%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=ac924f5cf1c105c5d353113c7b54c941211db0a5c042c1eae7b07337cab9eaea";
  Future<Uint8List?> getUint8ListFromNetworkImage() async {
    final data = box.get('image');
    if (data != null) {
      return data;
    } else {
      final response =
          await Utils.getConvertedUintListData(image: offerImageJson);
      if (response != null) {
        box.put("image", response);
        return response;
      } else {
        return null;
      }
    }
  }

  Future<Uint8List?> getUint8ListFromNetworkJson() async {
    final Box box = Hive.box("myBox");
    final data = box.get('json');
    if (data != null) {
      return data;
    } else {
      final response =
          await Utils.getConvertedUintListData(image: offerImageJson);
      if (response != null) {
        box.put("json", response);
        return response;
      } else {
        return null;
        // throw Exception('Failed to load image');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final value = getUint8ListFromNetworkJson().then((value) {
      setState(() {
        image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Assets'),
      ),
      body: Column(
        children: [
          // image != null
          //     ? Image.memory(image!)
          //     : const CircularProgressIndicator.adaptive(),
          // Lottie.network(offerImageJson, height: 300, width: 300),
          image != null
              ? Lottie.memory(image!)
              : const CircularProgressIndicator.adaptive(),

          // Lottie.network(
          //   "https://lottie.host/embed/52fb4acd-10a3-43b2-9667-7729b7309284/hpuwuYuwVO.json",
          //   height: 300,
          //   delegates: const LottieDelegates(),
          //   options: LottieOptions(enableMergePaths: true),
          //   errorBuilder: (context, error, stackTrace) =>
          //       Text(error.toString()),
          //   onWarning: (p0) => const Text("data"),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
