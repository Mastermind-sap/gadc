import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageWithSVG extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  NetworkImageWithSVG({
    required this.url,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        fit: fit,
        width: width,
        height: height,
        placeholderBuilder: (BuildContext context) =>
            placeholder ?? CircularProgressIndicator(),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) =>
            placeholder ?? CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
