import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // '/profile': (context) {
    //   return ProfileScreen(
    //     providerConfigs: providerConfigs,
    //     actions: [
    //       SignedOutAction((context) {
    //         Navigator.pushReplacementNamed(context, '/sign-in');
    //       }),
    //     ],
    //   );
    // },

    return Scaffold(
        appBar: AppBar(title: const Text('ndiabetes'),
        automaticallyImplyLeading: false),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 30),
                  )),
              Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Form(
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
                                  hintText: "Username",
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
                                controller: emailController,
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
                        //       decoration: const InputDecoration(
                        //           border: OutlineInputBorder(), labelText: "Email"),
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return "Please enter email";
                        //         }
                        //         if (!RegExp(
                        //                 r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        //             .hasMatch(value)) {
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
                        //       controller: passwordController,
                        //       obscureText: true,
                        //       decoration: const InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           labelText: "Password"),
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return "Please enter password";
                        //         }
                        //       }),
                        // ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email:
                                              emailController.text.toString(),
                                          password: passwordController.text
                                              .toString());

                                  createSnackBar('Logged in.');
                                  Navigator.pushNamed(context, '/scan_food');
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    createSnackBar(
                                        'No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    createSnackBar(
                                        'Wrong password provided for that user.');
                                  }
                                }
                              }
                            },
                            child: const Text("Log In"))
                      ],
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Doesn't have an account?")),
                Container(
                    child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_up');
                  },
                  child: const Text('Sign up here'),
                ))
              ]),
              Container(
                  child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/scan_food');
                },
                child: const Text('Use without account'),
              ))
            ],
          ),
        ));
  }

  void createSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
