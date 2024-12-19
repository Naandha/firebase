import 'package:firebase/email%20firebase/registration.dart';
import 'package:firebase/phone%20firebase/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Authentication.dart';


void main(){
  runApp(MaterialApp(home: login(),

  ),);
}
class login extends StatefulWidget {
  const login({super.key});
  @override
  State<login> createState() => _loginState();


}

class _loginState extends State<login> {
  GlobalKey<FormState>formkey=GlobalKey();
  bool showpass=true;
  String ?email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:    SingleChildScrollView(
        child: Container(
          child:
          Form(
            key: formkey,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60, top: 80),
                    child: Text("Loginpage", style: TextStyle(
                        fontSize: 30, color: Colors.deepOrange,
                        fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70, right: 70, top: 80),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "email",
                          labelText: "email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))
                      ),
                      validator: (username) {
                        if (username!.isEmpty || !username.contains('@') ||
                            !username.contains('.')) {
                          return "enter valid Email";
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (value){
                        email = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 70, left: 70, top: 80),
                    child: TextFormField(
                      obscureText: showpass,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              if (showpass) {
                                showpass == false;
                              }
                              else {
                                showpass == true;
                              }
                            });
                          },
                            icon: Icon(
                                showpass == true ? Icons.visibility_off : Icons
                                    .visibility),),
                          hintText: "password",
                          labelText: "password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))

                      ),
                      validator: (password) {
                        if (password!.isEmpty || password.length < 6) {
                          return "Enter valid password";
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (value){
                        password= value;
                      },
                    ),
                  ),


                  SizedBox(height: 50,),
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                  ),
                      onPressed: () {
                        if( formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                          FireHelper().signIn(
                              mail: email !, pass: password !).then((value){
                            if(value == null){

                              Get.to(()=>homes());
                            }else{
                              Get.snackbar("error", "User not found $value");
                            }
                          }
                          );
                        }
                      }, child: Text("Login")),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>registration()));
                  },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text("not a user ? create an account"),
                    ),
                  ),
                ]),
          ),

        ),
      ),);
  }
}