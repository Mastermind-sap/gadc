import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;

  const GridCard({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: (Theme.of(context).brightness == Brightness.dark)
          ? const Color.fromARGB(255, 29, 36, 40)
          : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.threed_rotation_outlined,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.create_rounded,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
