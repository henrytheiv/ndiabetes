import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ndiabetes')),
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
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    controller: emailController,
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
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password";
                      }
                    }),
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString());

                      createSnackBar('Logged in.');
                      Navigator.pushNamed(context, '/scan_food');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        createSnackBar('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        createSnackBar(
                            'Wrong password provided for that user.');
                      }
                    }
                  },
                  child: const Text("Log In")),
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
