import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_assets/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lottie/lottie.dart';

/// Common Network Image Which Supports [png,jpeg, gif, webp, svg] image formats
/// ```dart
/// CommonNetworkImage(
///               imageUrl: imageUrl,
///               width: width,
///               height: width,
///               fit: BoxFit.cover,
///             )
/// ```
/// for svg Type
/// ```dart
/// CommonNetworkImage(
///               imageUrl: imageUrl,
///               width: width,
///               height: width,
///               imageType:ImageType.svg,
///               fit: BoxFit.cover,
///             )
/// ```
class CommonNetworkImage extends StatelessWidget {
  const CommonNetworkImage(
      {Key? key,
      this.width,
      this.height,
      this.imageType = ImageType.global,
      this.fit = BoxFit.cover,
      this.repeatLottie = false,
      this.optionalImage,
      required this.imageUrl})
      : super(key: key);
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeatLottie;
  final String imageUrl;
  final ImageType imageType;
  final String? optionalImage;
  @override
  Widget build(BuildContext context) {
    if (imageUrl.contains('.json')) {
      return LottieBuilder.network(
        imageUrl,
        repeat: repeatLottie,
        height: height,
        width: width,
        fit: BoxFit.fill,
        // width: MediaQuery.of(context).size.width,
        errorBuilder: (s, f, fs) => optionalImage != null
            ? LottieBuilder.network(
                optionalImage!,
                repeat: repeatLottie,
                height: height,
                width: width,
                fit: BoxFit.fill,
                // width: MediaQuery.of(context).size.width,
                errorBuilder: (s, f, fs) => Icon(
                  Icons.error,
                  size: width,
                ),
              )
            : Icon(
                Icons.error,
                size: width,
              ),
      );
    } else if (imageUrl.contains(".svg")) {
      return SvgPicture.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholderBuilder: (context) => optionalImage != null
            ? optionalImage!.contains(".svg")
                ? SvgPicture.network(
                    optionalImage!,
                    height: height,
                    width: width,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => SizedBox(
                      height: height,
                    ),
                  )
                : optionalImage!.contains(".gif")
                    ? Image.network(
                        optionalImage!,
                        height: height,
                        width: width,
                        fit: BoxFit.contain,
                      )
                    : CommonNetworkImage(
                        imageUrl: optionalImage!,
                        width: width,
                        height: height,
                        fit: fit,
                      )
            : SizedBox(height: height),
      );
    } else if (imageUrl.contains(".gif")) {
      return Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return optionalImage != null
              ? optionalImage!.contains(".svg")
                  ? SvgPicture.network(
                      optionalImage!,
                      height: height,
                      width: width,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => SizedBox(),
                    )
                  : optionalImage!.contains(".gif")
                      ? Image.network(
                          optionalImage!,
                          height: height,
                          width: width,
                          fit: BoxFit.contain,
                        )
                      : CommonNetworkImage(
                          imageUrl: optionalImage!,
                          width: width,
                          height: height,
                          fit: fit,
                        )
              : width.getErrorImage();
        },
      );
    } else {
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => const SizedBox(),
        errorWidget: (s, f, fs) => optionalImage != null
            ? optionalImage!.contains(".svg")
                ? SvgPicture.network(
                    optionalImage!,
                    height: height,
                    width: width,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => width.getErrorImage(),
                  )
                : CommonNetworkImage(
                    imageUrl: optionalImage!,
                    width: width,
                    height: height,
                    fit: fit,
                  )
            : width.getErrorImage(),

        imageUrl: imageUrl,
        memCacheHeight: height?.toInt(),
        memCacheWidth: width?.toInt(),
        // "https://www.svgrepo.com/show/122770/user-online.svg",
        // "https://i.pinimg.com/originals/ef/09/36/ef0936558e58d6bebf73fee2ae895fe3.gif"
        // "https://cdn.pixabay.com/photo/2016/11/05/20/09/grooming-1801287_1280.png"
        // "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
      );
    }
  }
}

extension GetErrorImage on num? {
  getErrorImage() => Icon(Icons.error, size: double.parse("$this"));
}
