import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;
  final ImageWidgetBuilder imageBuilder;
  final PlaceholderWidgetBuilder placeholder;
  final LoadingErrorWidgetBuilder errorWidget;

  const GridCard({
    Key? key,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.imageBuilder,
    required this.placeholder,
    required this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: imageBuilder,
              placeholder: placeholder,
              errorWidget: errorWidget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(location),
          ),
        ],
      ),
    );
  }
}
