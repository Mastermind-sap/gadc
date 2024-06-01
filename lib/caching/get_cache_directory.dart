import 'package:path_provider/path_provider.dart';

Future<String> getCacheDirectory() async {
  final cacheDirectory = await getTemporaryDirectory();
  return cacheDirectory.path;
}
