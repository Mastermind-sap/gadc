import 'package:flutter/material.dart';
import 'package:gadc/functions/launch_url/launch_url.dart';
import 'package:lottie/lottie.dart';

class DeveloperMessageWidget extends StatefulWidget {
  @override
  _DeveloperMessageWidgetState createState() => _DeveloperMessageWidgetState();
}

class _DeveloperMessageWidgetState extends State<DeveloperMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Message from\nTHE DEVELOPERS',
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              endIndent: 150,
            ),
            Container(
              width: double.infinity,
              height: 300,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Lottie.asset(
                        'assets/tut_background.json',
                        width: 400,
                        height: 300,
                        fit: BoxFit.scaleDown,
                        frameRate: FrameRate(120),
                        animate: true,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/gaurav.png',
                        width: 185,
                        height: 300,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.86, -0.81),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '"Gave my best,\nHope this app\nmake one\'s \nnavigation easier!"',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1, -1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'GAURAV',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 36,
                                  letterSpacing: 0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        launchURL(
                                            'https://www.linkedin.com/in/gauravbk08/');
                                      },
                                      child: Image.asset(
                                        'assets/linkedin_icon.png',
                                        height: 36,
                                        width: 36,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        launchURL(
                                            'https://github.com/Gaurav-822');
                                      },
                                      child: Image.asset(
                                        'assets/github_icon.png',
                                        height: 36,
                                        width: 36,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 24,
                              ),
                              SizedBox(
                                height: 24,
                                child: VerticalDivider(
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                'FLUTTER , UNITY\nANDROID, UI/UX,\nGEMINI\'s RAG',
                              ),
                            ].divide(const SizedBox(width: 2)),
                          ),
                        ].divide(const SizedBox(height: 8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 48,
              endIndent: 48,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/gugu.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIDDHARTH',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 8),
                              child: Text(
                                'UNITY, UI/UX',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launchURL(
                                          'https://www.linkedin.com/in/siddharth-shankar-6003a1255/');
                                    },
                                    child: Image.asset(
                                      'assets/linkedin_icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchURL('https://github.com/Sid-NITS');
                                    },
                                    child: Image.asset(
                                      'assets/github_icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '"Experience the world in a\nwhole new way\nwith our\n3D mapping app"',
                                    style: TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 14,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/mastermind_sap.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SAPTARISHI',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 8),
                              child: Text(
                                'FLUTTER',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launchURL(
                                          'https://www.linkedin.com/in/saptarshi-adhikari/');
                                    },
                                    child: Image.asset(
                                      'assets/linkedin_icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchURL(
                                          'https://github.com/Mastermind-sap');
                                    },
                                    child: Image.asset(
                                      'assets/github_icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '"Creating Aura\nwas a journey\nto simplify navigation\nand enrich\neveryday travels."',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/pragyan.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRAGYAN',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 8),
                              child: Text(
                                'AI',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launchURL(
                                          'https://www.linkedin.com/in/pragyan-das-197086255/');
                                    },
                                    child: Image.asset(
                                      'assets/linkedin_icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchURL(
                                          'https://github.com/pragyan4261');
                                    },
                                    child: Image.asset(
                                      'assets/github_icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '"Hope it helps\neveryone\nfind their way easly!"',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ].divide(const SizedBox(height: 8)),
        ),
      ),
    );
  }
}

extension on List<Widget> {
  List<Widget> divide(Widget divider) {
    return [
      for (int i = 0; i < length; i++) ...[
        if (i > 0) divider,
        this[i],
      ],
    ];
  }
}
