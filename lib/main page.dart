import 'package:firebase/phone%20firebase/phone.dart';
import 'package:firebase/todo%20eg/logins.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
 import 'ToDo firebase/todo.dart';
import 'email firebase/login.dart';
import 'email firebase/registration.dart';
import 'google firebase/signin.dart';


Future<void>main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

      options:const FirebaseOptions(
          apiKey:"AIzaSyDxkBDcU0Q0qHIjflBFzMHW7ghGLzAh4xY",
          appId:"1:743143724319:android",
          storageBucket: 'fir-project-c66eb.firebasestorage.app',
          messagingSenderId:"",
          projectId:"fir-project-c66eb")

  );
  runApp(GetMaterialApp(
    home:GoogleSignInScreen(),
  ));//

}