import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition/services/image_to_text_services_impl.dart';

class CameraProvider with ChangeNotifier {
  List<CameraDescription> _availablesCameras = [];
  List<CameraDescription> get availableCamera => _availablesCameras;
  List<XFile> _pictures = [];
  List<XFile> get pictures => _pictures;
  Map<String, String> _treatResults = {};
  Map<String, String> get treatResult => _treatResults;
  Status _treamMentStatus = Status.initial;
  Status get treatmentResult => _treamMentStatus;
  String _err = "";
  String get err => _err;

  void setAvailablesCameras({required List<CameraDescription> cameras}) {
    _availablesCameras = cameras;
    notifyListeners();
  }

  void addPicture({required XFile capture}) {
    _pictures.add(capture);
    notifyListeners();
  }

  void removeCapturedPhotos() {
    _pictures = [];
    notifyListeners();
  }

  void setTreatRes() async {
    _treamMentStatus = Status.loading;
    notifyListeners();
    try {
      for (var element in _pictures) {
        _treatResults[element.path] = await ImageToTextServicesImpl()
            .textExtractedOnImage(
                image: element, imageIndex: _pictures.indexOf(element));
      }
      _treamMentStatus = Status.loaded;
      notifyListeners();
    } catch (e) {
      _treamMentStatus = Status.error;
      _err = e.toString();
      notifyListeners();
    } finally {
      _pictures = [];
      notifyListeners();
    }
  }
}

enum Status { initial, loading, loaded, error }
