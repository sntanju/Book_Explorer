import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageLoader extends StatelessWidget {
  final String? imageUrl; // made nullable
  final double width;
  final double height;
  final BoxFit fit;

  /// Optional placeholder widget
  final Widget? placeholder;

  const NetworkImageLoader({
    super.key,
    this.imageUrl,
    this.width = 50,
    this.height = 70,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    // If imageUrl is null or empty, show asset image directly
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Image.asset(
        'assets/images/bookImage.jpg',
        width: width,
        height: height,
        fit: fit,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/bookImage.jpg',
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
