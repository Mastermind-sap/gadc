import 'dart:async'; // Import to use Future.any
import 'package:gadc/functions/gemini/api_keys/apiKeys.dart';
import 'package:gadc/functions/toast/show_toast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> aiNavigator(String jsonData, String query) async {
  try {
    // Load your API key from environment variables or directly if it's hardcoded
    final String apiKey = GEMINI_API_KEY;

    // Initialize the GoogleGenerativeAi client
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
    );

    // Define the prompt for generating tourism places
    final prompt = '''
You are a navigation assistant AURA,

you are given a 30 * 30 grid with starting position of each grid is (14, 0):

$jsonData

You need to answer the question of your users, the question is: 
$query

If the question involve path finding that give this:

Generate a JSON containing navigation instructions to reach destination tag, give instructions in the format, 
{floor: "floorname", cell: [x, z], instruction: "instruction"}

or don't generate a json if it's just a general question and answer according to this:
Generate a text according to the json data given and the question asked, and don't say this just answer!
    ''';

    final content = [Content.text(prompt)];

    // Create a future for the API call
    final apiCall = model.generateContent(content).then((response) {
      // Debugging outputs
      print('Response: ${response.text.toString()}');
      return response.text.toString();
    });

    // Create a future for the timeout
    final timeout = Future.delayed(Duration(seconds: 20), () {
      throw TimeoutException('The operation has timed out');
    });

    // Wait for either the API call or the timeout
    final result = await Future.any([apiCall, timeout]);

    // showToast(result);
    print(result);

    return result;
  } catch (e) {
    // Handle errors
    print('Error: $e');
    showToast("Failed to generate response");
    return e is TimeoutException
        ? "Retry, it's taking too long"
        : "We are out of money to afford Gemini API, please consider donating!";
  }
}
