import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:gadc/functions/toast/show_toast.dart';

Future<void> downloadGemma() async {
  // URL of the file to be downloaded
  final url =
      "https://www.dropbox.com/scl/fi/durummzq8myuudplnixdg/model.bin?rlkey=nf7oz8dkpt8zdwn2v7iada82w&st=u7vkrhwh&dl=1";

  // Use the flutter_file_downloader package to download the file
  FileDownloader.downloadFile(
    url: url,
    name: 'model.bin',
    downloadDestination: DownloadDestinations.appFiles,
    onDownloadCompleted: (String path) {
      showToast(path);
      print('File downloaded and saved at $path');
    },
  );
}
