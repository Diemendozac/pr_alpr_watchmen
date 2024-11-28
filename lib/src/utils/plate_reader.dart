
import 'dart:convert';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PlateReader {

  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RegExp _plateRegex = RegExp('[A-Z]{3}([0-9]){2}([A-Z0-9]{1})');

  Future<String> getCameraImageData (InputImage image) async {
    final RecognizedText recognizedText = await _textRecognizer.processImage(image);
    return recognizedText.text;
  }

  Future<String> getPlateData (InputImage inputImage) async {

    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    if(text == '') return '';
    String? recognizedPLate;
    LineSplitter ls = const LineSplitter();
    List<String> allData = ls.convert(text);

    RegExp plateRegex = RegExp('[A-Z]{3}([0-9]){2}([A-Z0-9]{1})');

    for(String element in allData) {
      String firstWordFilter = element.replaceAll(' ', '');
      String secondWordFilter = firstWordFilter.replaceAll('-', '').toUpperCase();
      recognizedPLate = plateRegex.stringMatch(secondWordFilter);
      if(recognizedPLate != null ) break;
    }
    _textRecognizer.close();

    recognizedPLate ??= '';
    return recognizedPLate;

  }

  String getPlateDataInText (String recognizedText) {
    if(recognizedText.isEmpty) return '';
    String? recognizedPLate;
    LineSplitter ls = const LineSplitter();
    List<String> allData = ls.convert(recognizedText);


    for(String element in allData) {
      String firstWordFilter = element.replaceAll(' ', '');
      String secondWordFilter = firstWordFilter.replaceAll('-', '').toUpperCase();
      recognizedPLate = _plateRegex.stringMatch(secondWordFilter);
      if(recognizedPLate != null ) break;
    }
    _textRecognizer.close();

    recognizedPLate ??= '';
    return recognizedPLate;

  }


}