import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cached_assets/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class CommomMemoryImage extends StatelessWidget {
  const CommomMemoryImage({
    super.key,
    required this.imageType,
    required this.image,
    this.height,
    this.reverse = false,
    this.width,
    this.fit = BoxFit.contain,
  });
  final ImageType imageType;
  final Uint8List image;
  final double? height, width;
  final BoxFit fit;
  final bool reverse;
  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageType.global:
        return Image.memory(
          image,
          width: width,
          height: height,
          cacheHeight: height != null ? int.parse("$height") : null,
          cacheWidth: width != null ? int.parse("$width") : null,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        );
      case ImageType.svg:
        return SvgPicture.memory(
          image,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (context) => const Icon(Icons.error),
        );
      case ImageType.json:
        return LottieBuilder.memory(
          image,
          width: width,
          height: height,
          fit: fit,
          reverse: reverse,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        );
    }
  }
}
