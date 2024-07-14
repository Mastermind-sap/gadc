import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/functions/firebase/authentication/google_auth/google_auth.dart';
import 'package:gadc/functions/gemini/api_keys/apiKeys.dart';
import 'package:gadc/functions/location/geocoding.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:gadc/pages/map_page/map_page.dart';
import 'package:gadc/pages/navigation_page/navigation_page.dart';
import 'package:gadc/widgets/custom_chat_bot.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ExplorePage extends StatefulWidget {
  final VoidCallback drawerKey;
  const ExplorePage({super.key, required this.drawerKey});

  @override
  State createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<MapPageState> _mapPageKey = GlobalKey<MapPageState>();
  List<Map<String, dynamic>> _searchResults = [];
  String imageUrl = getUserImageUrl();
  bool ai = false;
  bool talk = false;
  List<bool> isSelected = [true, false];

  final GeocodingService _geocodingService = GeocodingService();

  @override
  void initState() {
    super.initState();
    focusAuraSearch.addListener(onFocusChange);
    startListeningToProfilePictureChanges();
    _initSpeech();
  }

  FocusNode focusAuraSearch = FocusNode();
  bool isOnAuraSearch = false;

  void onFocusChange() {
    setState(() {
      isOnAuraSearch = focusAuraSearch.hasFocus;
    });
  }

  void _performSearchOnChange(String searchQueryInitials) async {
    if (searchQueryInitials.isNotEmpty) {
      _searchResults = await _geocodingService
          .getCoordinatesFromAddress(searchQueryInitials);
    } else {
      _searchResults.clear();
    }
    setState(() {});
  }

  void startListeningToProfilePictureChanges() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        imageUrl = getUserImageUrl();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      });
    });
  }

  void _showTextModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const CustomChatBot();
      },
    ).then((value) {
      // This code executes after the bottom sheet is closed
      setState(() {
        ai = false; // Set ai to false when the bottom sheet is closed
        isSelected = [true, false];
      });
    });
  }

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  StreamController<String> _speechStreamController =
      StreamController<String>.broadcast();

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _speechStreamController
          .add(_lastWords); // Add recognized words to the stream
    });
  }

  Future<String> _getGenerativeAIResponse(String userInput) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: GEMINI_API_KEY,
    );

    final content = [Content.text(userInput)];
    final response = await model.generateContent(content);

    return response.text!;
  }

  void _showSpeechToTextModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<String>(
          stream: _speechStreamController.stream,
          initialData: '',
          builder: (context, snapshot) {
            if (_speechToText.isListening == false && _lastWords != '') {
              // _getGenerativeAIResponse(_lastWords);
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _speechToText.isListening
                      ? GestureDetector(
                          onTap: () {
                            _stopListening();
                          },
                          child: LottieBuilder.asset(
                            "assets/ai_speaking.json",
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _startListening();
                          },
                          child: LottieBuilder.asset(
                            "assets/ai_speaking.json",
                            repeat: false,
                          ),
                        ),
                  Text(
                    // If listening is active show the recognized words
                    _speechToText.isListening
                        ? '${snapshot.data}'
                        // If listening isn't active but could be tell the user
                        // how to start it, otherwise indicate that speech
                        // recognition is not yet ready or not supported on
                        // the target device
                        : _speechEnabled
                            ? 'Tap to Ask Query'
                            : 'Speech not available',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      // This code executes after the bottom sheet is closed
      setState(() {
        _stopListening();

        _lastWords = '';
        ai = false; // Set ai to false when the bottom sheet is closed
        isSelected = [true, false];
      });
    });
  }

  void _showSpeechToTextModalSheetForSearchTextField() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        _startListening();

        return StreamBuilder<String>(
          stream: _speechStreamController.stream,
          initialData: '',
          builder: (context, snapshot) {
            return Container(
              width: MediaQuery.of(context).size.width, // Take entire width
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _speechToText.isListening
                      ? GestureDetector(
                          onTap: () {
                            _stopListening();
                          },
                          child: Icon(Icons.mic))
                      : GestureDetector(
                          onTap: () {
                            _startListening();
                          },
                          child: const Opacity(
                            opacity: 0.3,
                            child: Icon(Icons.mic),
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  Text(
                    _speechToText.isListening
                        ? '${snapshot.data}'
                        : _lastWords.isNotEmpty
                            ? _lastWords
                            : (_speechEnabled
                                ? 'Tap to Ask Query'
                                : 'Speech not available'),
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _stopListening();
                            _searchController.text = _lastWords;
                            _performSearchOnChange(_lastWords);
                            Navigator.of(context).pop(); // Close bottom sheet
                          });
                        },
                        child: Text("Search"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      // This code executes after the bottom sheet is closed
      setState(() {
        _stopListening();
        _lastWords = '';
      });
    });
  }

  @override
  void dispose() {
    _speechStreamController.close(); // Dispose the stream controller
    _searchController.dispose();
    focusAuraSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          MapPage(key: _mapPageKey),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 48, 8, 0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: (ai == false)
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ai = true;
                                              talk = true;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/google-gemini-icon.svg',
                                            height: 30,
                                            width: 30,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  talk = false;
                                                  ai = false;
                                                  isSelected = [true, false];
                                                  _stopListening();
                                                  _lastWords = '';
                                                });
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            SizedBox(
                                              height: 30,
                                              child: ToggleButtons(
                                                borderColor: Colors.transparent,
                                                selectedBorderColor:
                                                    Colors.transparent,
                                                fillColor: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? const Color.fromARGB(
                                                        255, 29, 36, 40)
                                                    : Colors.white,
                                                isSelected: isSelected,
                                                onPressed: (int index) {
                                                  setState(() {
                                                    for (int i = 0;
                                                        i < isSelected.length;
                                                        i++) {
                                                      isSelected[i] =
                                                          i == index;
                                                    }
                                                  });

                                                  if (index == 0) {
                                                    talk = true;

                                                    // voice
                                                    _startListening();
                                                    _showSpeechToTextModalSheet();
                                                  }

                                                  if (index == 1) {
                                                    // Show text input modal sheet
                                                    talk = false;
                                                    _showTextModalSheet();
                                                  }
                                                },
                                                children: const [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Text("Voice"),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Text("Text"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    focusNode: focusAuraSearch,
                                    onChanged: (value) {
                                      _performSearchOnChange(value);
                                    },
                                    autofocus: false,
                                    obscureText: false,
                                    style: const TextStyle(),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Search Aura',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      filled: true,
                                      fillColor:
                                          (Theme.of(context).brightness ==
                                                  Brightness.dark)
                                              ? const Color.fromARGB(
                                                  255, 29, 36, 40)
                                              : Colors.white,
                                      prefixIcon: const Icon(
                                        Icons.search,
                                      ),
                                      suffixIcon:
                                          (isOnAuraSearch || _lastWords != "")
                                              ? GestureDetector(
                                                  onTap: () {
                                                    _lastWords = '';
                                                    _searchResults.clear();
                                                    _searchController.clear();
                                                    focusAuraSearch.unfocus();
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 24,
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    _showSpeechToTextModalSheetForSearchTextField();
                                                  },
                                                  child: const Icon(
                                                    Icons.keyboard_voice,
                                                    size: 24,
                                                  ),
                                                ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      fromBottomRoute(const NavigationPage(
                                        initialIndex: 2,
                                      )),
                                    );
                                  },
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? const Color.fromARGB(255, 29, 36, 40)
                                        : Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: (imageUrl != "None")
                                            ? CachedNetworkImage(
                                                imageUrl: getUserImageUrl(),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "assets/anonymous_profile.png",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_searchResults.isNotEmpty)
                            Positioned(
                              top: 100,
                              left: 16,
                              right: 16,
                              height: min(_searchResults.length * 90, 250),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _searchResults.length,
                                    itemBuilder: (context, index) {
                                      final location = _searchResults[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(location['displayName']),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (location['address']
                                                    ["country"] !=
                                                null)
                                              Text(
                                                  "Country: ${location['address']["country"]}"),
                                            if (location['address']
                                                    ["postcode"] !=
                                                null)
                                              Text(
                                                  "Postcode: ${location['address']["postcode"]}"),
                                          ],
                                        ),
                                        onTap: () {
                                          _mapPageKey.currentState
                                              ?.animateMapView(
                                            location['latLng'].latitude,
                                            location['latLng'].longitude,
                                            10,
                                          );
                                          _searchController.clear();
                                          setState(() {
                                            _searchResults.clear();
                                            focusAuraSearch.unfocus();
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: const AlignmentDirectional(-1, 1),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                              child: GestureDetector(
                                onTap: () {
                                  TextToSpeech tts = TextToSpeech();
                                  tts.speak("Hello");
                                  Navigator.of(context).push(
                                    fromBottomRoute(const NavigationPage()),
                                  );
                                },
                                child: Card(
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? const Color.fromARGB(255, 29, 36, 40)
                                      : Colors.white,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.arrow_drop_up,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (talk == true)
        //   Center(
        //     child: LottieBuilder.asset("assets/ai_speaking.json"),
        //   ),
      ],
    );
  }
}
