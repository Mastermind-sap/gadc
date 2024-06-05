import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadc/functions/gemma/download_gemma.dart';
import 'package:gadc/functions/gemma/gemma_exits.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:lottie/lottie.dart';

class CustomAppDrawer extends StatefulWidget {
  final String pageName;
  const CustomAppDrawer({super.key, required this.pageName});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0.0;
    });
  }

  var channel = const MethodChannel("gadc/gemma-integration");
  var result = "";
  List<String> resultList = [];

  Widget showResultList() {
    return Column(
      children: List.generate(resultList.length,
          (index) => Text(resultList[resultList.length - 1 - index])),
    );
  }

  void fetchDataFromNative(String prompt) async {
    try {
      final String response =
          await channel.invokeMethod('getResultFromGemma', {"prompt": prompt});

      setState(() {
        result = response;
        resultList.add(response);
      });
    } on PlatformException catch (e) {
      showToast('Error: ${e.message}');
    }
  }

  final TextEditingController promptController = TextEditingController();
  String prompt = "";

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(150, 29, 36, 40) // Dark mode drawer color
          : const Color.fromARGB(
              150, 255, 255, 255), // Light mode drawer color,
      child: Padding(
        // Adjust the padding of the drawer to move it up when the keyboard is visible
        padding: EdgeInsets.only(
            bottom: _isKeyboardVisible
                ? MediaQuery.of(context).viewInsets.bottom
                : 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Align(
                                    alignment: AlignmentDirectional(1, 1),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 36, 8, 0),
                                      child: Text(
                                        'A\nU\nR\nA',
                                        style: TextStyle(
                                            fontSize: 32, fontFamily: "aura"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 175,
                                    child: VerticalDivider(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      thickness: 1,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 36,
                                          color: isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 4),
                                        child: Text(
                                          widget.pageName,
                                          style: const TextStyle(
                                            fontSize: 36,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '26.1158, 91.7086',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      const Text(
                                        'Guwahati',
                                        style: TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // later add other things here
                        const SizedBox(
                          height: 16 * 2,
                        ),
                        (_isKeyboardVisible)
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: (result.isNotEmpty)
                                    ? showResultList()
                                    : Align(
                                        alignment: Alignment.topCenter,
                                        child: Lottie.asset(
                                          "assets/ai_lottie.json",
                                          frameRate: const FrameRate(120),
                                          repeat: true,
                                          height: 150,
                                        ),
                                      ),
                              )
                            : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Text(
                                            'Gaurav',
                                            style: TextStyle(
                                              fontSize: 36,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'assets/icon.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Text(
                                        '• Favs',
                                        style: TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Text(
                                        '• Recent',
                                        style: TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Text(
                                        '• FeedBack',
                                        style: TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.home_rounded,
                                          size: 36,
                                        ),
                                        Icon(
                                          Icons.location_city,
                                          size: 36,
                                        ),
                                        Icon(
                                          Icons.info_outline_rounded,
                                          size: 36,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still Queries ?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: promptController,
                    autofocus: false,
                    obscureText: false,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Ask Gemini',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.notes,
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          result = "";
                          setState(() {});
                          prompt = promptController.text;
                          if (prompt.isNotEmpty) {
                            fetchDataFromNative(prompt);
                            promptController.clear();
                          }
                        },
                        child: (gemmaExists)
                            ? const Icon(
                                Icons.send,
                                color: Colors.black,
                              )
                            : GestureDetector(
                                onTap: () {
                                  downloadGemma();
                                  showToast(
                                      "Restart The Application after Download gets Completed");
                                },
                                child: const Icon(
                                  Icons.download,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // for AI Animation, bottom and top if required
          ],
        ),
      ),
    );
  }
}
