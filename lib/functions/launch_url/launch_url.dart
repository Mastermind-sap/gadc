import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final Uri urlToGo = Uri.parse(url);
  if (!await launchUrl(urlToGo)) {
    throw Exception('Could not launch $urlToGo');
  }
}
