import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridCard extends StatefulWidget {
  final String title;
  final String location;
  final List<String> imageUrls;
  final ImageWidgetBuilder imageBuilder;
  final PlaceholderWidgetBuilder placeholder;
  final LoadingErrorWidgetBuilder errorWidget;

  const GridCard({
    Key? key,
    required this.title,
    required this.location,
    required this.imageUrls,
    required this.imageBuilder,
    required this.placeholder,
    required this.errorWidget,
  }) : super(key: key);

  @override
  _GridCardState createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    if (widget.imageUrls.isNotEmpty) {
      _timer = Timer.periodic(Duration(seconds: 10 + Random().nextInt(5)),
          (Timer timer) {
        if (_currentPage < widget.imageUrls.length - 1) {
          setState(() {
            _currentPage++;
          });
        } else {
          setState(() {
            _currentPage = 0;
          });
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      precacheImages();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void precacheImages() {
    for (String imageUrl in widget.imageUrls) {
      if (imageUrl.isNotEmpty) {
        precacheImage(CachedNetworkImageProvider(imageUrl), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.imageUrls.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    imageBuilder: widget.imageBuilder,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: widget.errorWidget,
                  ),
                );
              },
            ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8.0),
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.location,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
