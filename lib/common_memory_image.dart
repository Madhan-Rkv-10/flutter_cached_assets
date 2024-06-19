import 'package:flutter/material.dart';
import 'package:flutter_cached_assets/utils.dart';

class CommomMemoryImage extends StatefulWidget {
  const CommomMemoryImage({
    super.key,
    required this.imageType,
    required this.image,
  });
  final ImageType imageType;
  final String image;
  @override
  State<CommomMemoryImage> createState() => _CommomMemoryImageState();
}

class _CommomMemoryImageState extends State<CommomMemoryImage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
