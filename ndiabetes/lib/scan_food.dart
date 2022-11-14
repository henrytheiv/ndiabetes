import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ndiabetes/classifier.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'Recognition.dart';

class ScanFoodPage extends StatefulWidget {
  const ScanFoodPage({Key? key}) : super(key: key);

  @override
  State<ScanFoodPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScanFoodPage> {
  File _image = File("");
  List<Recognition> _recognitions = [];
  String? selectedFood;
  double? _imageHeight;
  double? _imageWidth;
  ImagePicker? imagePicker;
  Classifier? classifier;
  bool noImageScanned = true;

  @override
  void initState() {
    super.initState();
    initStateAsync();
    imagePicker = ImagePicker();
  }

  void initStateAsync() async {
    // Create an instance of classifier to load model and labels
    classifier = Classifier();
  }

  captureImage() async {
    final XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      img.Image? convertedImage = await convertFileToImage(image);
      List<Recognition> rec = classifier!.predict(convertedImage!);
      print('rec' + rec.toString());

      setState(() {
        _recognitions = rec;
        _image = image;
        noImageScanned = false;
      });
    }
  }

  //upload image from gallery
  uploadImage() async {
    final XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      img.Image? convertedImage = await convertFileToImage(image);
      List<Recognition> rec = classifier!.predict(convertedImage!);
      print('rec' + rec.toString());

      setState(() {
        _recognitions = rec;
        _image = image;
        noImageScanned = false;
      });
    }
  }

  Future<img.Image?> convertFileToImage(File picture) async {
    String path = picture.path;
    final bytes = await File(path).readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    _imageWidth = image?.width.toDouble();
    _imageHeight = image?.height.toDouble();

    print('img height ' +
        _imageHeight!.toString() +
        ' img width ' +
        _imageWidth.toString());
    return image;
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions.isEmpty) {
      return [];
    }

    // if (_imageHeight == null || _imageWidth == null) {print('img height and width null!!!!');return [];}

    double ratioX = screen.width / _imageWidth!;
    double ratioY = ratioX;

    print('at render box');

    // double factorX = screen.width;
    // double factorY = _imageHeight! / _imageWidth! * screen.width;

    return _recognitions.map((re) {
      return Positioned(
        // static Size get actualPreviewSize =>
        // Size(screenSize.width, screenSize.width * (screenSize.width / previewSize.height));
        // CameraViewSingleton.ratio = screenSize.width / previewSize.height;

        // CameraViewSingleton.actualPreviewSize.width ???
        left: max(0.1, re.location.left * ratioX),
        top: max(0.1, re.location.top * ratioY),
        width: min(re.location.width * ratioX, screen.width),
        height: min(re.location.height * ratioY,
            screen.height),
            // screen.width * (screen.width / _imageHeight!)),
        // left: re.location.left,
        // top: re.location.top,
        // width: re.location.width,
        // height: re.location.height,
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
          child: TextButton(
            onPressed: () async {
              final String? foodName =
                  await asyncSimpleDialog(context, re.label);

              if (foodName != null) {
                var index = _recognitions.indexOf(re);
                setState(() {
                  _recognitions[index].label = foodName;
                });
              }
              print("Selected Product is $foodName");
            },
            child: Text(
              "${re.label} ${(re.score * 100).toStringAsFixed(0)}%",
              textAlign: TextAlign.start,
              style: TextStyle(
                background: Paint()..color = Colors.yellow,
                fontSize: 15.0,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.black,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(0.0),
            ),
          ),
        ),
      );
    }).toList();

    print('at rendorBoxes');
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
                  margin: EdgeInsets.only(top: size.height / 2 - 200),
                  child: Icon(
                    Icons.image_rounded,
                    color: Colors.white,
                    size: 100,
                  )))
          : Image.file(_image),
    ));
    //draw rectangles around detected faces

    stackChildren.addAll(renderBoxes(size));

    if (_recognitions.isNotEmpty) {
      stackChildren.add(Align(
          alignment: Alignment.topCenter,
          child: Text("Tap on a food name to rename",
              style: TextStyle(color: Colors.white))));
    }

    //bottom tab bar
    stackChildren.add(
      Container(
          height: size.height,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_recognitions.isNotEmpty)
                Container(
                  width: 200,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[100], // background
                      onPrimary: Colors.black, // foreground
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/rating',
                          arguments: _recognitions);
                    },
                    child: Text('See Rating'),
                  ),
                ),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900],
                      ),
                      onPressed: captureImage,
                      child: Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900],
                      ),
                      onPressed: uploadImage,
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) => afterBuild(context));

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(
                child: Text("ndiabetes"),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 60),
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  void afterBuild(BuildContext context) {
    if (!noImageScanned && _recognitions.isEmpty) {
      const snackBar = SnackBar(
        content: Text('No foods detected'),
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

Future<String?> asyncSimpleDialog(
    BuildContext context, String currentLabel) async {
  List<String> foods = ['Apple', 'Cake', 'Egg', 'Orange', 'Tomato'];

  foods.remove(currentLabel);

  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Rename Food'),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, foods[index]),
                    child: Text(foods[index]),
                  );
                },
                itemCount: foods.length,
              ),
            )
          ],
        );
      });
}
