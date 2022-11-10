import 'package:flutter/material.dart';
import 'package:ndiabetes/Recognition.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  Map<String, int> foods = {'Apple': 0, 'Cake': 0, 'Egg': 0, 'Orange': 0, 'Tomato': 0, 'Others': 0};

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as List<Recognition>;

    print(arg);
    //update the number of each food
    arg.forEach((element) {
      foods.update(element.label, (v) => v = v++);
    });

    print(foods);

    return Scaffold(
      body: Column(

      ),
    );
  }
}
