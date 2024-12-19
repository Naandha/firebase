import 'package:firebase_auth/firebase_auth.dart';

class FireHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get user => auth.currentUser;

  Future<String?> singUp({required String mail, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.message;
    } catch (e) {
      print(e);
      return 'An error occurred';
    }
    return null;
  }

  Future<String?> signIn({required String mail, required String pass}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: mail,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    } catch (e) {
      print(e);
      return 'An error occurred';
    }
    return null;
  }
}