import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/functions/firebase/authentication/google_auth/google_auth.dart';
import 'package:gadc/functions/launch_url/launch_url.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:gadc/pages/profile_page/developers_page.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "None";
  String userImageUrl = "None";
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    updateUserDetails();
    fetchUserData();
  }

  void updateUserDetails() {
    setState(() {
      userName = getUserName();
      userImageUrl = getUserImageUrl();
    });
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('your_collection')
            .where('uid', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .get();

        List<Map<String, dynamic>> fetchedData = [];
        querySnapshot.docs.forEach((doc) {
          if (doc.exists) {
            Map<String, dynamic> data = {
              'unityData': doc['unityData'],
              'latitude': doc['latitude'],
              'longitude': doc['longitude'],
              'timestamp': doc['timestamp'],
              'imageUrl': doc['imageUrl'],
              'name': doc['name'],
            };
            fetchedData.add(data);
          }
        });

        setState(() {
          // Handle fetched data as needed, for example:
          fetchedData.forEach((data) {
            imageUrls.add(data['imageUrl']);
          });
        });
      } catch (error) {
        print("Error fetching user data: $error");
        showToast('Failed to fetch data: $error');
      }
    }
  }

  Future<void> handleLogin() async {
    await signInWithGoogle();
    updateUserDetails();
    fetchUserData();
  }

  Future<void> handleLogout() async {
    // Implement your logout logic here, e.g., sign out from Google
    await signOut();
    setState(() {
      userName = "None";
      userImageUrl = "None";
      imageUrls = [];
    });
  }

  Future<String> saveScreenshot(Uint8List screenshot) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/screenshot.png';
    final file = File(filePath);
    await file.writeAsBytes(screenshot);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 26, 8, 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
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
                ),
              ),
              // Welcome message and user details
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 8, 0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: (userName == "None")
                          ? GestureDetector(
                              onTap: handleLogin,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  pause: Duration(
                                    milliseconds: 500,
                                  ),
                                  animatedTexts: [
                                    TypewriterAnimatedText('AURA'),
                                    TypewriterAnimatedText(
                                        'Mhm... Who Are You ..'),
                                    TypewriterAnimatedText('.. Login ?'),
                                  ],
                                  onTap: () {
                                    handleLogin();
                                  },
                                ),
                              ),
                            )
                          : Text(
                              userName,
                              style: const TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 36,
                                letterSpacing: 0,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: (userImageUrl != "None")
                          ? CachedNetworkImage(
                              imageUrl: userImageUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/anonymous_profile.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              Column(
                children: [
                  const Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 0),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Contributions',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  // List of contributions
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 150,
                      child: (imageUrls.isNotEmpty)
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageUrls.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildListItem(imageUrls[index]);
                              },
                            )
                          : LottieBuilder.asset(
                              "assets/cat.json",
                              repeat: false,
                              frameRate: const FrameRate(120),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  'SETTINGS',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    BetterFeedback.of(context)
                                        .show((UserFeedback feedback) async {
                                      final picUrl = await saveScreenshot(
                                          feedback.screenshot);
                                      showToast("Start Sending");

                                      final Email email = Email(
                                        body: feedback
                                            .text, // Use feedback.text to get the text feedback
                                        subject: 'User Feedback on AURA',
                                        recipients: [
                                          'gaurav.moocs@gmail.com'
                                        ], // Replace with your email address
                                        attachmentPaths: [picUrl],
                                        isHTML: false,
                                      );

                                      try {
                                        await FlutterEmailSender.send(email);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Feedback sent successfully')),
                                        );
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to send feedback' +
                                                      error.toString())),
                                        );
                                      }
                                    });
                                  },
                                  child: _buildSettingsItem(
                                    context,
                                    'Feedback',
                                    trailing: const Icon(
                                      Icons.bug_report_rounded,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        'https://sites.google.com/view/aura3dnavigator/home?authuser=1');
                                  },
                                  child: _buildSettingsItem(
                                    context,
                                    'Privacy Policy',
                                    trailing: const Icon(
                                      Icons.privacy_tip_outlined,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        'https://sites.google.com/view/aura3dnavigator-t-and-c/home?authuser=1');
                                  },
                                  child: _buildSettingsItem(
                                    context,
                                    'Terms & Conditions',
                                    trailing: const Icon(
                                      Icons.layers,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      fromBottomRoute(DeveloperMessageWidget()),
                                    );
                                  },
                                  child: _buildSettingsItem(
                                    context,
                                    'About Us',
                                    trailing: const Icon(
                                      Icons.developer_mode_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                (userName != "None")
                                    ? GestureDetector(
                                        onTap: handleLogout,
                                        child: _buildSettingsItem(
                                          context,
                                          'Log Out',
                                          trailing: const Icon(
                                            Icons.logout_rounded,
                                            color: Color(0xFFFF5151),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: handleLogin,
                                        child: _buildSettingsItem(
                                          context,
                                          'Log In',
                                          trailing: const Icon(
                                            Icons.login,
                                            color: Color.fromARGB(
                                                255, 50, 255, 88),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 200,
          height: 150,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title,
      {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
