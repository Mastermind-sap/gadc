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
          _currentPage++;
        } else {
          _currentPage = 0;
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
    // Ensure this runs only once after initState
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.imageUrls.isNotEmpty)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
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
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.location),
          ),
        ],
      ),
    );
  }
}
