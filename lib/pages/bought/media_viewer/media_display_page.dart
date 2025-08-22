import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:studyswap/providers/traslation_provider.dart';
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
