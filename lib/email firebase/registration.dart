import 'package:firebase/email%20firebase/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Authentication.dart';


void main() {
  runApp(MaterialApp(
    home: registration(),
  ));
}

class registration extends StatefulWidget {
  const registration({Key? key}) : super(key: key);

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool showPass = true;

  String? name;
  String? password;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60, top: 80),
                child: Text(
                  "Register Page",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Name",
                    labelText: "Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter some value";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                child: TextFormField(
                  obscureText: showPass,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      icon: Icon(showPass ? Icons.visibility_off : Icons.visibility),
                    ),
                    hintText: "Password",
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value;
                  },
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (email != null && password != null) {
                      FireHelper().singUp(mail: email!, password: password!).then((value) {
                        if (value == null) {
                          Get.to(() => login());
                        } else {
                          Get.snackbar('Error', value);
                        }
                      });
                    }
                  }
                },
                child: Text("Submit"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}