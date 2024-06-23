import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cached_assets/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

/// A widget that displays an image from a [Uint8List] in various formats such as
/// raster image, SVG, or Lottie animation.
class CommomMemoryImage extends StatelessWidget {
  /// Creates a [CommomMemoryImage] widget.
  ///
  /// The [imageType] and [image] parameters are required.
  /// The [height], [width], [reverse], and [fit] parameters are optional.
  const CommomMemoryImage({
    super.key,
    required this.imageType,
    required this.image,
    this.height,
    this.repeat = false,
    this.width,
    this.fit = BoxFit.contain,
  });

  /// The type of the image. This determines how the image data is interpreted and displayed.
  final ImageType imageType;

  /// The raw image data in the form of a [Uint8List].
  final Uint8List image;

  /// The optional height of the image.
  final double? height;

  /// The optional width of the image.
  final double? width;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit fit;

  /// Whether to play the animation in reverse. Only applicable if the [imageType] is [ImageType.json].
  final bool repeat;

  @override
  Widget build(BuildContext context) {
    // print(int.parse(height.toString()));
    switch (imageType) {
      case ImageType.global:
        return Image.memory(
          image,
          width: width,
          height: height,
          cacheHeight: height?.toInt(),
          cacheWidth: width?.toInt(),
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
          renderCache: RenderCache.drawingCommands,
          fit: fit,
          repeat: repeat,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        );
    }
  }
}
