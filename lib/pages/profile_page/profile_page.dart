import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gadc/functions/authentication/google_auth/google_auth.dart';
import 'package:gadc/functions/toast/show_toast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 24, 0),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: (getUserImageUrl() != "None")
                            ? Image.network(
                                getUserImageUrl(),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/icon.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 8), // Spacer between image and text
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello,',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 48,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 8), // Spacer between lines
                            (getUserName() == "None")
                                ? GestureDetector(
                                    onTap: () {
                                      // Login
                                      signInWithGoogle();
                                    },
                                    child: const Text(
                                      '... LOG IN?',
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 24,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  )
                                : Text(
                                    getUserName(),
                                    style: const TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 24,
                                      letterSpacing: 0,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 0, 0),
                child: Text(
                  'Contributions',
                  style: const TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 36,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              endIndent: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(2, (index) {
                  return Stack(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://picsum.photos/seed/584/600',
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(
                                  'NIT SILCHAR',
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '(72.69, 21.14)',
                                      style: const TextStyle(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.view_in_ar_rounded,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.edit_rounded,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })
                    .expand((widget) => [widget, const SizedBox(height: 16)])
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
