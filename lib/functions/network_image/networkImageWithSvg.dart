import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      return Image.network(
        url,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: placeholder ??
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes!)
                        : null,
                  ),
            );
          }
        },
      );
    }
  }
}
