import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_assets/common_memory_image.dart';
import 'package:flutter_cached_assets/utils.dart';
import 'package:hive/hive.dart';
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
      home: FlutterCachedAssets(),
    );
  }
}

class FlutterCachedAssets extends StatefulWidget {
  const FlutterCachedAssets({super.key});

  @override
  FlutterCachedAssetsState createState() => FlutterCachedAssetsState();
}

class FlutterCachedAssetsState extends State<FlutterCachedAssets> {
  final Box box = Hive.box("myBox");

  Uint8List? gif;
  Uint8List? png;
  Uint8List? jpeg;
  Uint8List? json;

  Uint8List? svg;
  // Assigning variables based on image type
  String svgImage = "https://www.svgrepo.com/show/122770/user-online.svg";
  String gifImage =
      "https://i.pinimg.com/originals/ef/09/36/ef0936558e58d6bebf73fee2ae895fe3.gif";
  String pngImage =
      "https://cdn.pixabay.com/photo/2016/11/05/20/09/grooming-1801287_1280.png";
  final myJson =
      "https://lottie.host/embed/df1ab053-079b-498a-8f3f-e430117521ca/igi7qLSh2J.json";
  String jpgImage =
      "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg";
  @override
  void initState() {
    super.initState();
    Future.wait<Uint8List?>([
      Utils.getAndUpdateToLocal(
              boxName: "myBox", keyName: 'json', image: myJson)
          .then((value) {
        setState(() {
          json = value;
        });
        return json;
      }),
      Utils.getAndUpdateToLocal(
              boxName: "myBox", keyName: 'jpgImage', image: jpgImage)
          .then((value) {
        setState(() {
          jpeg = value;
        });
        return jpeg;
      }),
      Utils.getAndUpdateToLocal(
              boxName: "myBox", keyName: 'svgImage', image: svgImage)
          .then((value) {
        setState(() {
          svg = value;
        });
        return svg;
      }),
      Utils.getAndUpdateToLocal(
              boxName: "myBox", keyName: 'gifImage', image: gifImage)
          .then((value) {
        setState(() {
          gif = value;
        });
        return gif;
      }),
      Utils.getAndUpdateToLocal(
              boxName: "myBox", keyName: 'pngImage', image: pngImage)
          .then((value) {
        setState(() {
          png = value;
        });
        return png;
      })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Assets'),
      ),
      body: Column(
        children: [
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.transparent, BlendMode.color),
            child: HorizontalWidget(
                image: (json != null)
                    ? CommomMemoryImage(
                        imageType: ImageType.json,
                        image: json!,
                        repeat: true,
                        height: 100,
                      )
                    : const CircularProgressIndicator.adaptive(),
                text: "JSON"),
          ),
          HorizontalWidget(
              image: (svg != null)
                  ? CommomMemoryImage(
                      imageType: ImageType.svg,
                      image: svg!,
                      height: 100,
                    )
                  : const CircularProgressIndicator.adaptive(),
              text: "SVG"),
          HorizontalWidget(
              image: (gif != null)
                  ? CommomMemoryImage(
                      imageType: ImageType.global,
                      image: gif!,
                      height: 100,
                    )
                  : const CircularProgressIndicator.adaptive(),
              text: "GiF"),
          HorizontalWidget(
              image: (png != null)
                  ? CommomMemoryImage(
                      imageType: ImageType.global,
                      image: png!,
                      height: 100,
                    )
                  : const CircularProgressIndicator.adaptive(),
              text: "PNG"),
          HorizontalWidget(
              image: (jpeg != null)
                  ? CommomMemoryImage(
                      imageType: ImageType.global,
                      image: jpeg!,
                      height: 100,
                    )
                  : const CircularProgressIndicator.adaptive(),
              text: "JPEG")
        ],
      ),
    );
  }
}

class HorizontalWidget extends StatelessWidget {
  const HorizontalWidget({super.key, required this.image, required this.text});
  final Widget image;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: image),
        Expanded(child: Text(text)),
      ],
    );
  }
}
