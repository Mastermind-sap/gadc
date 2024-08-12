import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gadc/custom_routes/from_bottom_route.dart';
import 'package:gadc/functions/debouncer/debouncer.dart';
import 'package:gadc/functions/firebase/authentication/google_auth/google_auth.dart';
import 'package:gadc/functions/gemini/ai_context/ai_context.dart';
import 'package:gadc/functions/gemini/api_keys/apiKeys.dart';
import 'package:gadc/functions/location/geocoding.dart';
import 'package:gadc/pages/map_page/map_page.dart';
import 'package:gadc/pages/navigation_page/navigation_page.dart';
import 'package:gadc/widgets/custom_chat_bot.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ExplorePage extends StatefulWidget {
  final VoidCallback drawerKey;
  const ExplorePage({super.key, required this.drawerKey});

  @override
  State createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<MapPageState> _mapPageKey = GlobalKey<MapPageState>();
  List<Map<String, dynamic>> _searchResults = [];
  String imageUrl = getUserImageUrl();
  bool ai = false;
  bool talk = false;
  List<bool> isSelected = [true, false];

  final GeocodingService _geocodingService = GeocodingService();
  final FlutterTts _flutterTts = FlutterTts();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();

    CreateTut();

    focusAuraSearch.addListener(onFocusChange);
    startListeningToProfilePictureChanges();
    _initSpeech();
  }

  FocusNode focusAuraSearch = FocusNode();
  bool isOnAuraSearch = false;

  // Tut
  final GlobalKey _auraSearchBarSection = GlobalKey();
  final GlobalKey _dropButtonKey = GlobalKey();
  final GlobalKey _profileSection = GlobalKey();

  bool mapTutBool = false;

  void CreateTut() async {
    final prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('tutorialShown') ?? false;

    if (tutorialShown) return;
    AnimationController _controller;
    Animation<Offset> _offsetAnimation;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    List<TargetFocus> targets = [
      // Aura Search Bar section
      TargetFocus(
        identify: "Aura Search Bar",
        keyTarget: _auraSearchBarSection,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: SlideTransition(
                position: _offsetAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: LottieBuilder.asset(
                        "assets/up.json",
                        frameRate: const FrameRate(120),
                        repeat: false,
                      ),
                    ),
                    const Text(
                      "Welcome,",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 48.0),
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        pause: Duration(seconds: 2, milliseconds: 500),
                        animatedTexts: [
                          TypewriterAnimatedText('AURA'),
                          TypewriterAnimatedText(
                              'A Three Dimensional Mapping Platform'),
                          TypewriterAnimatedText(
                              'Create, Visualize and Explore the World'),
                          TypewriterAnimatedText(
                              'Making Finding Workplaces Easier!'),
                          TypewriterAnimatedText(
                              'So let\'s begin with the Tutorial'),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Profile Section
      TargetFocus(
        identify: "Profile Section",
        keyTarget: _profileSection,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.only(top: 50, right: 150),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: 7.0),
                      duration: Duration(seconds: 1),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: 0.4,
                            child: LottieBuilder.asset(
                                "assets/tut_background.json"),
                          ),
                        );
                      },
                    ),
                  ),
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "PROFILE SECTION",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16.0,
                            top: 8,
                          ),
                          child: Text(
                            "GOOGLE SIGN-IN\nTo contribute into\n\nAURA's ECOSYSTEM!",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Drop Button Section
      TargetFocus(
        identify: "Drop Button Key",
        keyTarget: _dropButtonKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "EXCESS\nNEAR-BY\nBUILD",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.0,
                      top: 8,
                    ),
                    child: Text(
                      "Maybe slow at first,\nBecomes fast after loaded once,\nSupport Us\nTo make AURA's Ecosystem,\n Faster!",
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ];

    final tutorial = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.lightBlue,
      onFinish: () {
        prefs.setBool('tutorialShown', true);
        mapTutBool = true;
      },
      hideSkip: true,
      opacityShadow: 0.1,
      onClickTarget: (target) {
        // _speakBot(target.identify);
      },
    );

    // _speakBot("Welcome to AURA, your Three Dimensonal Apartment Guide!");

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
  }

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

        if (MediaQuery.of(context).orientation != Orientation.landscape) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
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

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  final StreamController<String> _speechStreamController =
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

    final content = [Content.text("$GEMINI_AI_CONTEXT $userInput")];
    final response = await model.generateContent(content);

    return response.text!;
  }

  Future<void> _speakAI(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.5);
    await _flutterTts.setSpeechRate(0.6);

    String toSpeak = await _getGenerativeAIResponse(text);

    await _flutterTts.speak(toSpeak);
  }

  Future<void> _speakBot(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.5);
    await _flutterTts.setSpeechRate(0.6);

    await _flutterTts.speak(text);
  }

  Future<void> _pauseAiVoice() async {
    await _flutterTts.pause();
  }

  void _showSpeechToTextModalSheet() {
    bool ai_thinking = false;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StreamBuilder<String>(
            stream: _speechStreamController.stream,
            initialData: '',
            builder: (context, snapshot) {
              if (_speechToText.isListening == false && _lastWords != '') {
                // _getGenerativeAIResponse(_lastWords);
                ai_thinking = true;
                _speakAI(_lastWords);
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                              ai_thinking = false;
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
                    if (ai_thinking)
                      LottieBuilder.asset("assets/ai_lottie.json")
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((value) {
      // This code executes after the bottom sheet is closed
      setState(() {
        _stopListening();
        _pauseAiVoice();

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

  final _debouncer = Debouncer(milliseconds: 500);

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
                          MapPage(
                            key: _mapPageKey,
                            mapTutBool: mapTutBool,
                          ),
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
                                            key: _auraSearchBarSection,
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
                                      _debouncer.run(() {
                                        _performSearchOnChange(value);
                                      });
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
                                    key: _profileSection,
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
                                  Navigator.of(context).push(
                                    fromBottomRoute(const NavigationPage()),
                                  );
                                },
                                child: Card(
                                  key: _dropButtonKey,
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
