import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

enum Gender { male, female }

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Gender _genderChoice = Gender.male;

  final _formKey = GlobalKey<FormState>();

  bool _isNumber(String s) {
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Diabetes';

    return Scaffold(
        appBar:
            AppBar(title: Text("ndiabetes"), automaticallyImplyLeading: false),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 30),
                    )),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "First name",
                                // prefixIcon: Icon(
                                //   Icons.search,
                                //   color: Colors.black,
                                // ),
                                // suffixIcon: Icon(
                                //   Icons.filter_list,
                                //   color: Colors.black,
                                // ),
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: firstNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter first name";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       controller: firstNameController,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "First name"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter first name";
                      //         }
                      //       }),
                      // ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Last name",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: lastNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter last name";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       controller: lastNameController,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Last name"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter last name";
                      //         }
                      //       }),
                      // ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
                                }
                                if (!RegExp(
                                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                    .hasMatch(value)) {
                                  return "Please enter valid email";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       controller: emailController,
                      //       keyboardType: TextInputType.emailAddress,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Email"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter email";
                      //         }
                      //         if(!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)){
                      //           return "Please enter valid email";
                      //         }
                      //       }),
                      // ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       obscureText: true,
                      //       controller: passwordController,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Password"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter password";
                      //         }
                      //       }),
                      // ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Age",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter age";
                                }
                                if (!_isNumber(value.toString())) {
                                  return "Please enter valid number";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       controller: ageController,
                      //       keyboardType: TextInputType.number,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(), labelText: "Age"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter age";
                      //         }
                      //         if(!_isNumber(value.toString())){
                      //           return "Please enter valid number";
                      //         }
                      //       }),
                      // ),
                      const Text('Gender:', textAlign: TextAlign.center),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: Gender.male,
                            groupValue: _genderChoice,
                            onChanged: (value) {
                              setState(() {
                                _genderChoice = value as Gender;
                              });
                            },
                          ),
                          const Text('Male'),
                          Radio(
                            value: Gender.female,
                            groupValue: _genderChoice,
                            onChanged: (value) {
                              setState(() {
                                _genderChoice = value as Gender;
                              });
                            },
                          ),
                          const Text('Female'),
                        ],
                      ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Weight (kg)",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter weight";
                                }
                                if (!_isNumber(value.toString())) {
                                  return "Please enter valid number";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       controller: weightController,
                      //       keyboardType: TextInputType.number,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Weight (kg)"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter weight";
                      //         }
                      //         if(!_isNumber(value.toString())){
                      //           return "Please enter valid number";
                      //         }
                      //       }),
                      // ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Height (cm)",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                              maxLines: 1,
                              controller: heightController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter height";
                                }
                                if (!_isNumber(value.toString())) {
                                  return "Please enter valid number";
                                }
                              }),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: TextFormField(
                      //       controller: heightController,
                      //       keyboardType: TextInputType.number,
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Height (cm)"),
                      //       validator: (value) {
                      //         if (value!.isEmpty) {
                      //           return "Please enter height";
                      //         }
                      //         if(!_isNumber(value.toString())){
                      //           return "Please enter valid number";
                      //         }
                      //       }),
                      // ),
                      Card(
                        elevation: 6.0,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(119, 0, 119, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            // Array list of items
                            items: <String>['Diabetes', 'Heart Disease']
                                .map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),

                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     DropdownButton<String>(
                      //       value: dropdownValue,
                      //       icon: const Icon(Icons.keyboard_arrow_down),
                      //
                      //       // Array list of items
                      //       items: <String>['Diabetes', 'Heart Disease']
                      //           .map((String items) {
                      //         return DropdownMenuItem(
                      //           value: items,
                      //           child: Text(items),
                      //         );
                      //       }).toList(),
                      //       // After selecting the desired option,it will
                      //       // change button value to selected value
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           dropdownValue = newValue!;
                      //         });
                      //       },
                      //     )
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/homepage');
                              },
                              child: Text("Back"),
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: ElevatedButton(
                              child: Text("Sign Up"),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email:
                                                emailController.text.toString(),
                                            password: passwordController.text
                                                .toString());

                                    final User? user = auth.currentUser;
                                    final uid = user?.uid;

                                    var firstName =
                                        firstNameController.text.toString();
                                    var lastName =
                                        lastNameController.text.toString();
                                    var email = emailController.text.toString();
                                    var password =
                                        passwordController.text.toString();
                                    var age = int.parse(ageController.text);
                                    var weight =
                                        double.parse(weightController.text);
                                    var height =
                                        double.parse(heightController.text);

                                    Database.addUser(
                                        uid!,
                                        firstName,
                                        lastName,
                                        email,
                                        password,
                                        age,
                                        _genderChoice.name,
                                        weight,
                                        height,
                                        'diabetes');

                                    createSnackBar('Signed up successfully.');
                                    Navigator.pushNamed(context, '/homepage');
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      createSnackBar(
                                          'The password provided is too weak.');
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      createSnackBar(
                                          'The account already exists for that email.');
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  void createSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
