import 'dart:math';
import 'dart:ui';

/// Represents the recognition output from the model
class Recognition {
  /// Index of the result
  int id;

  /// Label of the result
  String label;

  /// Confidence [0.0, 1.0]
  double score;

  /// Location of bounding box rect
  ///
  /// The rectangle corresponds to the raw input image
  /// passed for inference
  Rect location;

  Recognition({required this.id, required this.label, required this.score, required this.location});

  /// Returns bounding box rectangle corresponding to the
  /// displayed image on screen
  ///
  /// This is the actual location where rectangle is rendered on
  /// the screen
  // Rect get renderLocation {
  //   // ratioX = screenWidth / imageInputWidth
  //   // ratioY = ratioX if image fits screenWidth with aspectRatio = constant
  //
  //   double ratioX = CameraViewSingleton.ratio;
  //   double ratioY = ratioX;
  //
  //   double transLeft = max(0.1, location.left * ratioX);
  //   double transTop = max(0.1, location.top * ratioY);
  //   double transWidth = min(
  //       location.width * ratioX, CameraViewSingleton.actualPreviewSize.width);
  //   double transHeight = min(
  //       location.height * ratioY, CameraViewSingleton.actualPreviewSize.height);
  //
  //   Rect transformedRect =
  //   Rect.fromLTWH(transLeft, transTop, transWidth, transHeight);
  //   return transformedRect;
  // }

  @override
  String toString() {
    return 'Recognition(id: $id, label: $label, score: $score, location: $location)';
  }
}