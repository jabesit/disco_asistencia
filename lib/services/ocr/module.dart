/*import 'package:flutter/material.dart';
import 'package:ocr_scan_text/ocr_scan/model/recognizer_text/text_block.dart';
import 'package:ocr_scan_text/ocr_scan/model/scan_result.dart';
import 'package:ocr_scan_text/ocr_scan/module/scan_module.dart';

class ScanAllModule extends ScanModule {
  ScanAllModule()
      : super(
          label: 'All',
          color: Colors.redAccent.withOpacity(0.3),
          validateCountCorrelation: 1,
        );

  @override
  Future<List<ScanResult>> matchedResult(
    List<TextBlock> textBlock,
    String text,
  ) async {
    List<ScanResult> list = [];
    print("---> has response");

    list.add(ScanResult(
      cleanedText: text,
      scannedElementList: [],
    ));

    return list;
  }
}
*/