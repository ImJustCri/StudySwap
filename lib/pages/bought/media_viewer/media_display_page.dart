import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:studyswap/services/traslation_manager.dart';
class MediaDisplayPage extends StatefulWidget {
  final String url;

  const MediaDisplayPage({super.key, required this.url});

  @override
  State<MediaDisplayPage> createState() => _MediaDisplayPageState();
}

class _MediaDisplayPageState extends State<MediaDisplayPage> {
  late PdfViewerController c;

  @override
  void initState() {
    super.initState();
    c = PdfViewerController();
    ScreenProtector.preventScreenshotOn();
  }

  @override
  void dispose() {
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translation.of(context)!.translate("mediaDispayPage")),
      ),
      body: SfPdfViewer.network(
        widget.url,
        controller: c,
      ),
    );
  }
}
