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
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Gender _genderChoice = Gender.male;

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Diabetes';

    return Scaffold(
        appBar: AppBar(title: Text("ndiabetes")),
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
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "First name"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter first name";
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Last name"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter last name";
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        }
                      }),
                ),
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
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Weight (kg)"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter weight";
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Height (cm)"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter height";
                        }
                      }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),

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
                    )
                  ],
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString());

                        final User? user = auth.currentUser;
                        final uid = user?.uid;

                        var firstName = firstNameController.text.toString();
                        var lastName = lastNameController.text.toString();
                        var email = emailController.text.toString();
                        var password = passwordController.text.toString();
                        var weight = double.parse(weightController.text);
                        var height = double.parse(heightController.text);

                        Database.addUser(
                            uid!,
                            firstName,
                            lastName,
                            email,
                            password,
                            _genderChoice.name,
                            weight,
                            height,
                            'diabetes');

                        createSnackBar('Signed up successfully.');
                        Navigator.pushNamed(context, '/');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          createSnackBar('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          createSnackBar(
                              'The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                )
              ],
            )));
  }

  void createSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
