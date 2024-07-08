import 'package:flutter/material.dart';
import 'package:gadc/pages/nearby_page/fav_page.dart';
import 'package:gadc/pages/nearby_page/nearby_main_page.dart';

class SurroundingPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const SurroundingPage({
    super.key,
    this.latitude,
    this.longitude,
  });

  @override
  State<SurroundingPage> createState() => _SurroundingPageState();
}

class _SurroundingPageState extends State<SurroundingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? const Color.fromARGB(255, 29, 36, 40)
                          : Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          child: Text(
                            "EXPLORE",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "FAVS",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                      indicatorColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  NearbyMainPage(
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                  ),
                  const FavPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
