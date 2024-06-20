import 'package:flutter/material.dart';
import 'package:flutter_cached_assets/utils.dart';

class CommomMemoryImage extends StatelessWidget {
  const CommomMemoryImage({
    super.key,
    required this.imageType,
    required this.image,
  });
  final ImageType imageType;
  final String image;
  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageType.global:
        return const Text("global");

      case ImageType.svg:
        return const Text("svg");

      case ImageType.json:
        return const Text("json");
    }
  }
}
