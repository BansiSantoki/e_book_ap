import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;
  final bool isLocalFile;

  const PDFViewerScreen(
      {Key? key, required this.pdfPath, required this.isLocalFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Book',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Color(0xFFAF0606),
      ),
      body: isLocalFile
          ? SfPdfViewer.file(
              File(pdfPath),
              enableTextSelection: false,
            )
          : SfPdfViewer.network(
              pdfPath,
              enableTextSelection: false,
            ),
    );
  }
}
