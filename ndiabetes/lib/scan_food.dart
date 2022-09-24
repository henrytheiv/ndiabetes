import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'Recognition.dart';


class ScanFoodPage extends StatefulWidget {
  const ScanFoodPage({Key? key}) : super(key: key);

  @override
  State<ScanFoodPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScanFoodPage> {
  File _image = File("");
  List? _recognitions;
  bool selection = false;
  double? _imageHeight;
  double? _imageWidth;
  ImagePicker? imagePicker;
  List? _foodItems = [];
  bool hasFood = false;

  /// Labels file loaded as list
  List<String> _labels = [];



  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  captureImage() async {
    _foodItems!.clear();
    hasFood = false;
    final XFile? pickedFile =
    await imagePicker!.pickImage(source: ImageSource.camera);
    File image = File(pickedFile!.path);
    predictImage(image);
  }

  //upload image from gallery
  uploadImage() async {
    _foodItems!.clear();
    hasFood = false;
    final XFile? pickedFile =
    await imagePicker!.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    predictImage(image);
  }

  // Future loadModel() async {
  //   Tflite.close();
  //   try {
  //     String? res = await Tflite.loadModel(
  //       model: "assets/ssd_mobilenet.tflite",
  //       labels: "assets/ssd_mobilenet.txt",
  //     );
  //     print(res);
  //   } on PlatformException {
  //     print('Failed to load model.');
  //   }
  // }

  Future<Interpreter> loadModel() async {
    final interpreter = await Interpreter.fromAsset('model.tflite');
    return interpreter;
  }

  /// Loads labels from assets
  void loadLabels() async {
    try {
      _labels = await FileUtil.loadLabels("assets/labels.txt");
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }

  Future<img.Image?> convertFileToImage(File picture) async {
    final path = picture.path;
    final bytes = await File(path).readAsBytes();
    final img.Image? image = img.decodeImage(bytes);
    return image;
  }

  Future<List> resizeImage(File image) async {

    ///Make image File -> TensorImage
    // Create a TensorImage object from a File
    TensorImage tensorImage = TensorImage(TfLiteType.float32);
    img.Image? tempFile1 = await convertFileToImage(image);
    tensorImage.loadImage(tempFile1!);

    ///Process TensorImage to 320*320
    // Initialization code
    // Create an ImageProcessor
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(320, 320, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();

    // Preprocess the image.
    // The image for imageFile will be resized to (320, 320)
    tensorImage = imageProcessor.process(tensorImage);

    ///Get image bytes as Uint8List
    Uint8List imgRgb = tensorImage.image.getBytes(format: img.Format.rgb);

    Float32List imageDataBuffer = Float32List(1 * 320 * 320 * 3);

    // RGB range is 0-255. Scale it to 0-1.
    for(int i = 0; i < imgRgb.lengthInBytes; i++){
      imageDataBuffer[i] = imgRgb[i] / 255.0;
    }

    List list = imageDataBuffer.reshape([1, 320, 320, 3]);








    // tensorImage = TensorImage.fromFile(image);



    // img.Image? imageTemp = img.decodeImage(image.readAsBytesSync());
    // img.Image imageNew = imageTemp;

    ///JUST NOW CODE
    // List<int> shape = [1, 320, 320, 3];

    // TensorBuffer tensorBuffer = TensorBuffer.createFixedSize(shape, TfLiteType.float32);
    // print(tensorBuffer.shape);
    // tensorBuffer.loadBuffer(tensorImage.buffer);
    // //ImageConversions.convertImageToTensorBuffer(tensorImage.image, tensorBuffer);
    // print(tensorBuffer.shape);

    // Fetch RGB data from the decoded JPEG image input file.
    // Uint8List imageRgb = tensorImage.image.getBytes(format: img.Format.rgb);

    // Float32List imageFloat32 = Float32List.fromList(elements)
    
    // The array that will collect the JPEG RGB values.


    // imageDataBuffer.reshape(shape);

    // print(tensorBuffer.getDoubleList());

    //img.Image resizedImg = img.copyResize(imageTemp!, height: 320, width: 320);

    // List imageData = resizedImg.data;
    //
    // List reshapedImageData = imageData.reshape([1,320,320,3]);

    return list;

    // ///numberOfChannels → int
    // // The number of channels used by this Image.
    // // While all images are stored internally with 4 bytes,
    // // some images, such as those loaded from a Jpeg, don't use the 4th (alpha) channel.
    // Uint8List imgBytes = resizedImg.getBytes();
    // print('8888888 ' +imgBytes.toString());
    //
    // ByteData byteData = imgBytes.buffer.asByteData();
    // List<double> floatList = [
    //   for (var offset = 0; offset < imgBytes.length; offset += 4)
    //     byteData.getFloat32(offset, Endian.big),
    // ];
    //
    // print('ffffff '+floatList.toString());
    //
    // List resultBytes = [];
    //
    // //int index = 0;
    //
    // for (int i = 0; i < floatList.length; i += 4) {
    //   final r = floatList[i];
    //   final g = floatList[i+1];
    //   final b = floatList[i+2];
    //
    //   resultBytes.add([r,g,b]);
    //   // index++;
    // }
    //
    // print('Result bytes shape = '+ resultBytes.shape.toString());
    //
    // var resultAfterReshape = resultBytes.reshape([1, 320, 320, 3]);
    //
    // print('Result bytes after reshape = '+ resultAfterReshape.shape.toString());
    //
    // // Uint8List intBytes = Uint8List.fromList(resultBytes);
    //
    //
    //
    // // var imgAsList = imgBytes.buffer.asFloat32List();



    // return resultAfterReshape;

    // var x = List.generate(3, (i) => List.generate(3, (j) => i + j));
    // print(x);
    // var y = List.generate(
    //     3, (i) => List.generate(3, (j) => List.generate(3, (k) => List.generate(3, (l) => i + j + k + l))));
    // print(y);
    //
    //     TensorBuffer inputFeature0 =
    //     TensorBuffer.createFixedSize(new int[]{1, 320, 320, 3}, TfLiteType.float32);
    //     inputFeature0.loadBuffer(byteBuffer);



    // int startTime = new DateTime.now().millisecondsSinceEpoch;

    // For ex: if input tensor shape [1,5] and type is float32
    // var input = [[1, 320, 320, 3]];

    // if output tensor shape [1,2] and type is float32
    // var output = [];

    // inference
    // interpreter.run(input, output);

    // print the output
    // print(output);
    //   var recognitions = await Tflite.detectObjectOnImage(
    //       path: image.path,
    //       // required
    //       model: "SSDMobileNet",
    //       imageMean: 127.5,
    //       imageStd: 127.5,
    //       threshold: 0.4,
    //       // defaults to 0.1
    //       numResultsPerClass: 2,
    //       // defaults to 5
    //       asynch: true // defaults to true
    //       );
    //   setState(() {
    //     _recognitions = recognitions;
    //
    //     _recognitions!.whereType<Map>().forEach((re) {
    //       _foodItems!.add(re['detectedClass']);
    //     });

    // print(_recognitions);
    // });
    // int endTime = new DateTime.now().millisecondsSinceEpoch;
    // print("Inference took ${endTime - startTime}ms");
  }

  Future predictImage(File image) async {
    if (image == null) return;
    // TensorBuffer buffer = await resizeImage(image);
    List imgAsList = await resizeImage(image);

    print("ImgAsList");
    print(imgAsList.shape);
    print(imgAsList.computeNumElements);

    List<Object> inputs = [imgAsList];
    // inputs.add(buffer.byteData);

    // print('Buffer shape ' + buffer.shape.toString());
    print('Shape: ' + inputs.shape.toString());
    print('Num elem: ' + inputs.computeNumElements.toString());
    inputs.forEach((e) {print(e);});

    // TensorBuffer inputBuffer = TensorBuffer.createFixedSize(<int>[1, 320, 320, 3], TfLiteType.float32);
    // inputBuffer.loadBuffer(tensorImage.buffer);

    // Create a container for the result and specify that this is a quantized model.
    // Hence, the 'DataType' is defined as UINT8 (8-bit unsigned integer)
    // TensorBuffer probabilityBuffer =
    // TensorBuffer.createDynamic(TfLiteType.float32);

    /// Shapes of output tensors
    List<List<int>> _outputShapes = [[1,10], [1,10,4], [1], [1,10]];

    /// Types of output tensors
    List<TfLiteType> _outputTypes;

    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[3]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer numLocations = TensorBufferFloat(_outputShapes[2]);

    // Outputs map
    Map<int, Object> outputs = {
      1: outputLocations.buffer,
      3: outputClasses.buffer,
      0: outputScores.buffer,
      2: numLocations.buffer,
    };



    // try {
    Interpreter interpreter = await loadModel();
    loadLabels();

    var inputTensors = interpreter.getInputTensors();
    var outputTensors = interpreter.getOutputTensors();

    print(inputTensors);
    print(' ');
    print(outputTensors);

    _outputTypes = [];
    outputTensors.forEach((tensor) {
      _outputShapes.add(tensor.shape);
      _outputTypes.add(tensor.type);
    });

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;


    // run inference
    interpreter.runForMultipleInputs(inputs , outputs);

    var inferenceTimeElapsed =
        DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Maximum number of results to show
    int resultsCount = min(10, numLocations.getIntValue(0));

    // Using labelOffset = 1 as ??? at index 0
    int labelOffset = 0;

    // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [0, 1, 2, 3],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: 320,
      width: 320,
    );

    print('LOC ' + locations.toString());

      List<Recognition> recognitions = [];

      print('count ' + resultsCount.toString());
      for (int i = 0; i < resultsCount; i++) {
        // Prediction score
        var score = outputScores.getDoubleValue(i);

        // Label string
        var labelIndex = outputClasses.getIntValue(i) + labelOffset;
        print('labelIndex ' + labelIndex.toString());
        print(_labels.computeNumElements);
        var label = _labels.elementAt(labelIndex);

        if (score > 0.5) {
          ImageProcessor imageProcessor = ImageProcessorBuilder()
              .add(ResizeOp(320, 320, ResizeMethod.NEAREST_NEIGHBOUR))
              .build();
          // inverse of rect
          // [locations] corresponds to the image size 300 X 300
          // inverseTransformRect transforms it our [inputImage]
          Rect transformedRect = imageProcessor.inverseTransformRect(
              locations[i], 320, 320);

          recognitions.add(
            Recognition( id: labelIndex, label: label, score: score, location: transformedRect),
          );

          setState(() {
            _recognitions = recognitions;
          });

          print('Recognition ' + recognitions[i].toString());
        }
      }


    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
    });
  }

  //perform inference using ssdNet model
  // Future ssdMobileNet(File image) async {
  //   int startTime = new DateTime.now().millisecondsSinceEpoch;
  //   var recognitions = await Tflite.detectObjectOnImage(
  //       path: image.path,
  //       // required
  //       model: "SSDMobileNet",
  //       imageMean: 127.5,
  //       imageStd: 127.5,
  //       threshold: 0.4,
  //       // defaults to 0.1
  //       numResultsPerClass: 2,
  //       // defaults to 5
  //       asynch: true // defaults to true
  //       );
  //   setState(() {
  //     _recognitions = recognitions;
  //
  //     _recognitions!.whereType<Map>().forEach((re) {
  //       _foodItems!.add(re['detectedClass']);
  //     });
  //
  //     print(_recognitions);
  //   });
  //   int endTime = new DateTime.now().millisecondsSinceEpoch;
  //   print("Inference took ${endTime - startTime}ms");
  // }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    print('screen width: ' + screen.width.toString() + " " + 'sccreen height: ' + screen.height.toString());
    print('width: ' + (screen.width / _imageWidth!).toString());
    print('height: ' + (_imageHeight! / _imageWidth! * screen.width).toString());
    double factorX = screen.width / _imageWidth!;
    double factorY =  screen.height / _imageHeight!;
    // double factorY = _imageHeight! / _imageWidth! * screen.width;

    return _recognitions!.map((re) {
      return Positioned(
        left: max(0.1, re.location.left * factorX),
        top: max(0.1, re.location.top * factorY),
        width: min(re.location.width * factorX, _imageWidth!),
        height: min(re.location.height * factorY, _imageHeight!),
        // width: re["location"]["w"] * factorX,
        // height: re["location"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: Colors.yellow,
              width: 2,
            ),
          ),
          child: Text(
            "${re.label} ${(re.score * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = Colors.yellow,
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _image.path == ""
          ? Center(
              child: Container(
                  margin: EdgeInsets.only(top: size.height / 2 - 140),
                  child: Icon(
                    Icons.image_rounded,
                    color: Colors.white,
                    size: 100,
                  )))
          : Image.file(_image),
    ));
    //draw rectangles around detected faces


      // if (_foodItems!.contains('banana') ||
      //     _foodItems!.contains('apple') ||
      //     _foodItems!.contains('sandwich') ||
      //     _foodItems!.contains('orange') ||
      //     _foodItems!.contains('broccoli') ||
      //     _foodItems!.contains('carrot') ||
      //     _foodItems!.contains('hot dog') ||
      //     _foodItems!.contains('pizza') ||
      //     _foodItems!.contains('donut') ||
      //     _foodItems!.contains('cake')) {
        hasFood = true;
        stackChildren.addAll(renderBoxes(size));
      // } else {
      //   stackChildren.add(const Expanded(
      //     child: Align(
      //       alignment: FractionalOffset.centerLeft,
      //       child: Text("Image doesn't contain food items.",
      //           style:
      //           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //           textAlign: TextAlign.center),
      //     ),
      //   ));
      // }





    //bottom tab bar
    stackChildren.add(
      Container(
        height: size.height,
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: captureImage,
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: uploadImage,
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (hasFood = true) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          ),
        ),
      );
    }
  }
}
