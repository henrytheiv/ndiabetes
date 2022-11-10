import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'Recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';


class Classifier {
  /// Instance of Interpreter
  Interpreter? _interpreter;

  /// Labels file loaded as list
  List<String> _labels = [];

  static const String MODEL_FILE_NAME = "defaultModel5CMoreSteps.tflite";
  static const String LABEL_FILE_NAME = "labelmap.txt";

  /// Input size of image ( width and height = 320)
  static const int INPUT_SIZE = 300;

  /// Result score threshold
  static const double THRESHOLD = 0.5;

  /// [ImageProcessor] used to pre-process the image
  ImageProcessor? imageProcessor;

  /// Padding the image to transform into square
  int? padSize;

  /// Shapes of output tensors
  List<List<int>> _outputShapes = [];

  /// Types of output tensors
  List<TfLiteType> _outputTypes = [];

  /// Number of results to show
  static const int NUM_RESULTS = 5;

  Classifier() {
    loadModel();
    loadLabels();
  }

  /// Loads interpreter from asset
  void loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(MODEL_FILE_NAME);

      var outputTensors = _interpreter!.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
      print(outputTensors);
      print(_outputShapes);
      print(_outputTypes);

    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  /// Loads labels from assets
  void loadLabels() async {
    try {
      if(_labels.isEmpty) {
        _labels =  await FileUtil.loadLabels("assets/" + LABEL_FILE_NAME);
      }
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  /// Pre-process the image
  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    // if (imageProcessor == null) {
      imageProcessor = ImageProcessorBuilder()
          .add(ResizeWithCropOrPadOp(padSize!, padSize!))
          .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.NEAREST_NEIGHBOUR))
          .add(NormalizeOp(127.5, 127.5))
          .build();
    // }
    inputImage = imageProcessor!.process(inputImage);
    return inputImage;
  }

  /// Runs object detection on the input image
  List<Recognition> predict(img.Image image) {
    var predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (_interpreter == null) {
      print("Interpreter not initialized");
      return [];
    }

    var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Create TensorImage from image
    TensorImage inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(image);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    
    // var processedImage = inputImage.image;
    // var convertedBytes = Float32List(1 * 300 * 300 * 3);
    // var buffer = Float32List.view(convertedBytes.buffer);
    // int pixelIndex = 0;
    // for (var i = 0; i < 300; i++) {
    //   for (var j = 0; j < 300; j++) {
    //     var pixel = processedImage. getPixel(j, i);
    //     buffer[pixelIndex++] = (img.getRed(pixel) - 127.5) / 255.0;
    //     buffer[pixelIndex++] = (img.getGreen(pixel) - 127.5) / 255.0;
    //     buffer[pixelIndex++] = (img.getBlue(pixel) - 127.5) / 255.0;
    //   }
    // }

      List f32Reshaped = inputImage.buffer.asFloat32List().reshape([1, 300, 300, 3]);

    print(f32Reshaped.toString());

    var preProcessElapsedTime =
        DateTime.now().millisecondsSinceEpoch - preProcessStart;

    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[3]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer numLocations = TensorBufferFloat(_outputShapes[2]);

    ///Reshape input image buffer
    // //Get image bytes as Float32List
    // List f32 = inputImage.getBuffer().asFloat32List();
    // List f32Normalized = [];
    //
    // //Normalize the values in Float32List and store in new list
    // for(int i=0; i < f32.computeNumElements; i++) {
    //   // RGB range is 0-255. Scale it to between -1 to 1.
    //   f32Normalized.add(f32[i] / 127.5-1);
    // }
    // //Reshape new list
    // List f32Reshaped = f32Normalized.reshape([1,300,300,3]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    List<Object> inputs = [f32Reshaped];

    // Outputs map
    Map<int, Object> outputs = {
      1: outputLocations.buffer,
      3: outputClasses.buffer,
      0: outputScores.buffer,
      2: numLocations.buffer,
    };

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    // run inference
    _interpreter!.runForMultipleInputs(inputs, outputs);

    print('Outputs - ' + outputs.toString());

    var inferenceTimeElapsed =
        DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Maximum number of results to show
    int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));

    // Using labelOffset = 1 as ??? at index 0
    int labelOffset = 1;

    // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    List<Recognition> recognitions = [];

    for (int i = 0; i < resultsCount; i++) {
      // Prediction score
      var score = outputScores.getDoubleValue(i);

      // Label string
      var labelIndex = outputClasses.getIntValue(i) + labelOffset;
      var label = _labels.elementAt(labelIndex);

      if (score > THRESHOLD) {
        // inverse of rect
        // [locations] corresponds to the image size 300 X 300
        // inverseTransformRect transforms it our [inputImage]
        print(imageProcessor!.operatorIndex);
        Rect transformedRect = imageProcessor!.inverseTransformRect(
            locations[i], image.height, image.width);

        recognitions.add(
          Recognition(id: i, label: label, score: score, location: transformedRect),
        );
      }
    }

    var predictElapsedTime =
        DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return
    recognitions;
    print(recognitions);
    print("totalPredictTime: " + predictElapsedTime.toString() +
        "inferenceTime: " + inferenceTimeElapsed.toString() +
        "preProcessingTime: " + preProcessElapsedTime.toString());
    // "recognitions": recognitions,
    // "stats": Stats(
    //     totalPredictTime: predictElapsedTime,
    //     inferenceTime: inferenceTimeElapsed,
    //     preProcessingTime: preProcessElapsedTime)

  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter!;

  /// Gets the loaded labels
  List<String> get labels => _labels;
}