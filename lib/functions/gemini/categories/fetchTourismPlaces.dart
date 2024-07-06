import 'dart:convert';
import 'package:gadc/functions/gemini/api_keys/apiKeys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<List<dynamic>> fetchTourismPlaces() async {
  // Load your API key from environment variables or directly if it's hardcoded
  final String apiKey = GEMINI_API_KEY;

  // Initialize the GoogleGenerativeAi client
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  // Define the prompt for generating tourism places
  final prompt = '''
    input: give me 25 tourism places nearby to lat: 28.7041, lang: 77.1025, in json format with the latitude, longitude, name of the place
    output: 
  ''';

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  try {
    String output = response.text ?? "";
    int startIndex = output.indexOf('{');
    int endIndex = output.lastIndexOf('}');

    String jsonContent = output.substring(startIndex, endIndex + 1);

    jsonContent = "[$jsonContent]";

    final data = jsonDecode(jsonContent);

    return data;
  } catch (e) {
    throw Exception('Error fetching tourism places: $e');
  }
}
