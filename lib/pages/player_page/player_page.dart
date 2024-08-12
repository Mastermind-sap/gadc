import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:gadc/functions/gemini/ai_navigator/ai_navigator.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PlayerPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const PlayerPage({super.key, required this.data});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  UnityWidgetController? _unityWidgetController;
  bool _showControls = false;
  bool _isAiJson = false;
  List _aiJsonResponses = [];
  List<String> _aiResponses = [];
  Offset _draggablePosition = Offset(0, 0); // Store the draggable position
  Size _draggableSize = Size.zero; // Initialize size to zero
  List<int> curr_pos = [14, 0];
  late String curr_floor;
  final ScrollController _scrollController = ScrollController();
  int scrollIndex = 0;
  final TextEditingController _textController = TextEditingController();
  bool _isGeminiLoading = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        _draggableSize = Size(
          screenSize.width * 0.8, // 80% of screen width
          screenSize.height * 0.3, // 30% of screen height
        );
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
      _textController.text = _lastWords;
      _speechStreamController
          .add(_lastWords); // Add recognized words to the stream
    });
  }

  Future<void> _speakBot(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.5);
    await _flutterTts.setSpeechRate(0.55);

    await _flutterTts.speak(text);
  }

  Future<void> _pauseAiVoice() async {
    await _flutterTts.pause();
  }

  List<int> getCurrPos(String inp) {
    List inputL = convertUnityStringToList(inp);
    curr_floor = inputL[1];
    return inputL[0];
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
    _unityWidgetController!.postMessage(
      'UnityMessageHandler',
      'OnUnityMessage',
      widget.data['unityData'],
    );
  }

  Future<void> getAIResponse(String query) async {
    setState(() {
      _isGeminiLoading = true;
    });

    try {
      String res1 = await aiNavigator(widget.data['unityData'], query);
      String j = filterJsonResponse(res1);
      bool jsonNotPresent = true;

      try {
        jsonDecode(j);
        jsonNotPresent = false;
      } catch (e) {
        jsonNotPresent = true;
      }

      if (jsonNotPresent) {
        setState(() {
          _isAiJson = false;
          _aiResponses.insert(0, res1);
        });
        _speakBot(res1);
      } else {
        setState(() {
          _isAiJson = true;
          _aiJsonResponses = getAiResponseList(j);
        });
      }
    } finally {
      setState(() {
        _isGeminiLoading = false;
      });
    }
  }

  String filterJsonResponse(String output) {
    try {
      int startIndex = output.indexOf("```json") + 7;
      int endIndex = output.lastIndexOf("```");
      if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
        return "Error: JSON markers not found";
      }
      String jsonContent = output.substring(startIndex, endIndex).trim();
      return jsonContent;
    } catch (e) {
      return "Error: $e";
    }
  }

  List<List<dynamic>> getAiResponseList(String data) {
    var instructions = jsonDecode(data);
    // var instructions = op['instructions'];
    List<List<dynamic>> result = [];
    curr_floor = instructions[0]['floor'];
    for (var instruction in instructions) {
      var floor = instruction['floor'];
      var cell = instruction['cell'];
      var inst = instruction['instruction'];
      result.add([cell, floor, inst]);
    }
    return result;
  }

  Widget oneCell(String instruction) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(instruction),
              ),
            ),
          ),
        ),
        Icon(
          Icons.navigate_next,
          size: 24,
        ),
      ],
    );
  }

  List<int> convertStringToList(String input) {
    // Remove any parentheses or square brackets
    String cleanedInput = input.replaceAll(RegExp(r'[\[\]()\s]'), '');

    // Split by comma to get the individual number parts
    List<String> parts = cleanedInput.split(',');

    // Convert each part to an integer and collect them into a list
    List<int> result = parts.map((part) => int.parse(part)).toList();

    return result;
  }

  List<dynamic> convertUnityStringToList(String input) {
    // Remove the square brackets
    input = input.substring(1, input.length - 1);

    // Split the string by the comma after the tuple
    List<String> elements = input.split('), ');

    // The first element will be the tuple, so split it further
    String tupleString = elements[0];
    tupleString = tupleString.substring(1); // Remove the '('
    List<String> tupleElements = tupleString.split(', ');

    // Parse the numbers as integers
    int num1 = int.parse(tupleElements[0].split('.')[0]);
    int num2 = int.parse(tupleElements[1].split('.')[0]);

    // The second element is the string
    String floor = elements[1];

    // Create the final list
    List<dynamic> result = [
      [num1, num2],
      floor
    ];

    return result;
  }

  bool areListsEqual(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  Future<void> _scrollToNextItem() async {
    final double itemWidth = 124.0; // Adjust based on your item width
    double currentScrollPosition = _scrollController.offset;
    double nextScrollPosition = currentScrollPosition + itemWidth;

    await _scrollController.animateTo(
      nextScrollPosition,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _scrollToPreviousItem() async {
    final double itemWidth = 124.0; // Adjust based on your item width
    double currentScrollPosition = _scrollController.offset;
    double previousScrollPosition = currentScrollPosition - itemWidth;

    await _scrollController.animateTo(
      previousScrollPosition,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget aiControls() {
    return Container(
      width: _draggableSize.width,
      height: _draggableSize.height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 40, 8, 0),
        child: Align(
          alignment: AlignmentDirectional(0, -1),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _draggablePosition += details.delta;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.drag_indicator_rounded),
                            SizedBox(width: 4),
                            Expanded(
                              child: TextFormField(
                                controller: _textController,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      if (_textController.text.isNotEmpty) {
                                        getAIResponse(_textController.text);
                                        setState(() {
                                          _isGeminiLoading = true;
                                        });
                                      }
                                      _textController.clear();
                                    },
                                    child: const Icon(Icons.search),
                                  ),
                                  isDense: true,
                                  labelText: "Aura's here!",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0,
                                    ),
                                validator: (value) {
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  if (_textController.text.isNotEmpty) {
                                    getAIResponse(_textController.text);
                                    setState(() {
                                      _isGeminiLoading = true;
                                    });
                                  }
                                  _textController.clear();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                // add voice support
                              },
                              child: _speechToText.isListening
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
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: [
                            if (_isGeminiLoading == false)
                              Container(
                                  height: _draggableSize.height,
                                  decoration: const BoxDecoration(),
                                  child: (_aiResponses.isEmpty &&
                                          _aiJsonResponses.isEmpty)
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 0),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                bottom: 0,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: LottieBuilder.asset(
                                                    "assets/aura_nav_lottie.json",
                                                    frameRate:
                                                        const FrameRate(120),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 24,
                                                top: 0,
                                                bottom: 0,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                      fontSize: 30.0,
                                                    ),
                                                    child: AnimatedTextKit(
                                                      isRepeatingAnimation:
                                                          false,
                                                      pause: const Duration(
                                                          milliseconds: 750),
                                                      animatedTexts: [
                                                        TypewriterAnimatedText(
                                                            'Need Help?'),
                                                        TypewriterAnimatedText(
                                                            'Ask Me?'),
                                                      ],
                                                      onTap: () {
                                                        print("Tap Event");
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : _isAiJson
                                          ? ListView.builder(
                                              controller: _scrollController,
                                              padding: EdgeInsets.fromLTRB(
                                                  4, 0, 0, 0),
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  _aiJsonResponses.length,
                                              itemBuilder: (context, index) {
                                                // showToast(_aiJsonResponses[index]
                                                //     .toString());
                                                convertStringToList(
                                                    _aiJsonResponses[index][0]
                                                        .toString());
                                                if (areListsEqual(
                                                        convertStringToList(
                                                            _aiJsonResponses[
                                                                    index][0]
                                                                .toString()),
                                                        curr_pos) &&
                                                    curr_floor ==
                                                        _aiJsonResponses[index]
                                                                [1]
                                                            .toString()) {
                                                  // Scroll
                                                  Future<void> scrollToIndex(
                                                      int index) async {
                                                    if (index - scrollIndex >
                                                        0) {
                                                      for (int i = 0;
                                                          i <
                                                              index -
                                                                  scrollIndex;
                                                          i++) {
                                                        await _scrollToNextItem();
                                                      }
                                                    }
                                                    if (index - scrollIndex <
                                                        0) {
                                                      for (int i = 0;
                                                          i <
                                                              (index -
                                                                      scrollIndex)
                                                                  .abs();
                                                          i++) {
                                                        await _scrollToPreviousItem();
                                                      }
                                                    }
                                                    scrollIndex = index;
                                                  }

                                                  scrollToIndex(index);

                                                  return oneCell(
                                                      _aiJsonResponses[index]
                                                          [2]);
                                                }
                                                return Opacity(
                                                  opacity: 0.4,
                                                  child: oneCell(
                                                      _aiJsonResponses[index]
                                                          [2]),
                                                );
                                              },
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.fromLTRB(
                                                  4, 8, 0, 0),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _aiResponses.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 200,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            blurRadius: 4,
                                                          ),
                                                        ],
                                                      ),
                                                      child: (index == 0)
                                                          ? SingleChildScrollView(
                                                              child:
                                                                  DefaultTextStyle(
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                ),
                                                                child:
                                                                    AnimatedTextKit(
                                                                  isRepeatingAnimation:
                                                                      false,
                                                                  pause: const Duration(
                                                                      milliseconds:
                                                                          750),
                                                                  animatedTexts: [
                                                                    TypewriterAnimatedText(
                                                                        _aiResponses[
                                                                            index]),
                                                                  ],
                                                                  onTap: () {
                                                                    print(
                                                                        "Tap Event");
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : SingleChildScrollView(
                                                              child: Text(
                                                                  _aiResponses[
                                                                      index]),
                                                            ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            )),
                            if (_isGeminiLoading)
                              Center(
                                  child: Opacity(
                                opacity: 1, // Adjust the radius as needed
                                child: LottieBuilder.asset(
                                  "assets/geminiAiLoading.json",
                                  // height: 100,
                                  // width: 200,
                                ),
                              ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _draggableSize = Size(
                          (_draggableSize.width + details.delta.dx)
                              .clamp(200.00, MediaQuery.of(context).size.width),
                          (_draggableSize.height + details.delta.dy).clamp(
                              200.00, MediaQuery.of(context).size.height * 0.8),
                        );
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                      child: Transform.rotate(
                        angle: 45 * (3.1415926535897932 / 180),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 24,
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
    );
  }

  void onUnityMessageHandler(message) {
    setState(() {
      curr_pos = getCurrPos(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          UnityWidget(
            fullscreen: true,
            onUnityMessage: onUnityMessageHandler,
            onUnityCreated: onUnityCreated,
          ),
          if (_showControls)
            Positioned(
              left: _draggablePosition.dx,
              top: _draggablePosition.dy,
              child: SizedBox(
                width: _draggableSize.width,
                height: _draggableSize.height,
                child: aiControls(),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: !_showControls
                      ? SvgPicture.asset(
                          'assets/google-gemini-icon.svg',
                          height: 40,
                          width: 40,
                        )
                      : const Icon(
                          Icons.close,
                          size: 40,
                          color: Colors.orange,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
