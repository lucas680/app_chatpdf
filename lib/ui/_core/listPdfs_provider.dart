import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ListpdfsProvider extends ChangeNotifier {
  List<PlatformFile> listPdfFiles = [];

  void addAllPdfs(List<PlatformFile> pdfs) {
    listPdfFiles.addAll(pdfs);
    notifyListeners();
  }

  void removePdf(int index){
    listPdfFiles.removeAt(index);
    notifyListeners();
  }
}
