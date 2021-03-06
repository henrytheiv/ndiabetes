import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? _image;
  List? _recognitions;
  String _model = ssd;
  bool selection = false;
  double? _imageHeight;
  double? _imageWidth;
  ImagePicker? imagePicker;



  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  _imgFromCamera() async {
    final XFile? pickedFile = await imagePicker!.pickImage(source: ImageSource.camera);
    File image = File(pickedFile!.path);
    predictImage(image);


  }

  //TODO chose image gallery
  _imgFromGallery() async {
    final XFile? pickedFile = await imagePicker!.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    predictImage(image);

  }

  Future loadModel() async {
    Tflite.close();
    try {
      String? res;
      switch (_model) {
        case yolo:
          res = await Tflite.loadModel(
            model: "assets/yolov2_tiny.tflite",
            labels: "assets/yolov2_tiny.txt",
          );
          break;
        case ssd:
          res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt",
          );
          break;
      }
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future predictImage(File image) async {

    if (image == null) return;
    loadModel();
    switch (_model) {
      case yolo:
        await yolov2Tiny(image);
        break;
      case ssd:
        await ssdMobileNet(image);
        break;
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

  Future yolov2Tiny(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,       // required
        model: "YOLO",
        imageMean: 0.0,
        imageStd: 255.0,
        threshold: 0.3,       // defaults to 0.1
        numResultsPerClass: 2,// defaults to 5
        blockSize: 32,        // defaults to 32
        numBoxesPerBlock: 5,  // defaults to 5
        asynch: true          // defaults to true
    );
    setState(() {
      _recognitions = recognitions;
    });
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  //TODO perform inference using ssdNet model
  Future ssdMobileNet(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,       // required
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,       // defaults to 0.1
        numResultsPerClass: 2,// defaults to 5
        asynch: true          // defaults to true
    );
    setState(() {
      _recognitions = recognitions;
    });
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight! / _imageWidth! * screen.width;
    return _recognitions!.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: Colors.yellow,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
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
      child: _image == null ? Center(child: Container(margin:EdgeInsets.only(top:size.height/2-140),child: Icon(Icons.image_rounded,color: Colors.white,size: 100,))) : Image.file(_image!),
    ));
    //TODO draw rectangles around detected faces
    stackChildren.addAll(renderBoxes(size));
    //TODO bottom bar code
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
                onPressed: _imgFromCamera,
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
              ),
              Text('SSD'),
              Switch(
                value: selection,
                onChanged: (value) {
                  setState(() {
                  });
                },
              ),
              Text('Yolo'),
              ElevatedButton(
                onPressed: _imgFromGallery,
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
