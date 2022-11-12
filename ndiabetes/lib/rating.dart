import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ndiabetes/Recognition.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  Map<String, int> foods = {
    'Apple': 0,
    'Cake': 0,
    'Egg': 0,
    'Orange': 0,
    'Tomato': 0
  };

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute
        .of(context)!
        .settings
        .arguments as List<Recognition>;

    print(arg);
    //update the number of each food
    arg.forEach((element) {
      foods.update(element.label, (v) => v = v + 1);
    });

    print(foods);

    return Scaffold(
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
        automaticallyImplyLeading: false, //remove back button in app bar
      ),
      body: CarbDetails(
        foods: foods,
      ),
    );
  }
}

class FoodBox extends StatelessWidget {
  const FoodBox({Key? key, required this.name, required this.carb})
      : super(key: key);
  final String name;
  final int carb;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 50,
        child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(this.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(this.carb.toString()),
                            ],
                          )))
                ])));
  }
}

class CarbDetails extends StatefulWidget {
  final Map<String, int> foods;

  const CarbDetails({Key? key, required this.foods}) : super(key: key);

  @override
  State<CarbDetails> createState() => _CarbDetailsState();
}

class _CarbDetailsState extends State<CarbDetails> {
  Future<QuerySnapshot> _getEventsFromFirestore(List<String> foodNames) async {
    return await FirebaseFirestore.instance
        .collection('foods')
        .where("name", whereIn: foodNames)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodToSearch = [];
    widget.foods.forEach((key, value) {
      if (value > 0) {
        foodToSearch.add(key);
      }
    });

    int totalCarb = 0;

    return FutureBuilder<QuerySnapshot>(
      //Fetching data from the documentId specified of the student
        future: _getEventsFromFirestore(foodToSearch),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final querySnaphost = snapshot.data; // Get query snapshot
            if (querySnaphost!.docs.isNotEmpty) {
              print(querySnaphost.docs[0].data());
              print('snapshot not empty');

              // Document exists
              final documentSnapshot = querySnaphost.docs;

              List<FoodBox> foodBox = [];
              documentSnapshot.forEach((data) {
                //totalCarb = carb per food from database MULTIPLY number of food detected
                totalCarb += data["carb"] * widget.foods[data["name"]] as int;
                foodBox.add(FoodBox(
                    name: data["name"],
                    carb: data["carb"] * widget.foods[data["name"]]));
              });
              // var data = Map<String,dynamic>.from(querySnaphost.docs[0].data() as Map);
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Card(
                    //   margin: EdgeInsets.fromLTRB(10, 20, 10, 30),
                    //   elevation: 6.0,
                    //   shape: RoundedRectangleBorder(
                    //     side: BorderSide(color: Colors.white70, width: 1),
                    //     borderRadius: BorderRadius.circular(100),
                    //   ),
                    //   child: Container(
                    //       child: SizedBox(
                    //           width: 200,
                    //           height: 200,
                    //           child: Center(
                    //               child: Text(
                    //             '${totalCarb} carbs',
                    //             style: TextStyle(fontSize: 30),
                    //           )))),
                    // ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: CircularPercentIndicator(
                        radius: 80.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: totalCarb > 53 ? 1.0 : totalCarb / 53,
                        center: Text(
                          totalCarb.toString() + ' carbs',
                          style:
                          const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: totalCarb > 53 ? Colors.red : Colors
                            .green,
                      ),
                    ),
                    Text("Carbohydrate Summary"),
                    SizedBox(
                      height: 200,
                      child: ListView(children: foodBox),
                    ),
                    Card(
                      color: totalCarb > 53 ? Colors.red : Colors.green,
                      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                          child: SizedBox(
                              width: 400,
                              height: 80,
                              child: Center(
                                  child: Text(
                                    totalCarb > 53
                                        ? 'Exceeded carb limit'
                                        : 'Safe to eat',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )))),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[900]
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/scan_food');
                          },
                          child: Text('Back')),
                    )
                  ]);
            }
          }
          return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              alignment: Alignment.center,
              child: CircularProgressIndicator());
        });
  }
}
