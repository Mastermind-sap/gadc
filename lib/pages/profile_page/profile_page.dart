import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadc/functions/firebase/authentication/google_auth/google_auth.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        top: true,
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
                            child: const Text(
                              '..LOG IN?',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 36,
                                letterSpacing: 0,
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
                        "assets/empty_dark.json",
                        repeat: true,
                        frameRate: const FrameRate(120),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
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
                          _buildSettingsItem(context, 'Feedback'),
                          _buildSettingsItem(context, 'Report Bug'),
                          _buildSettingsItem(context, 'About'),
                          _buildSettingsItem(
                            context,
                            'Log Out',
                            trailing: GestureDetector(
                              onTap: handleLogout,
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFFF5151),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
