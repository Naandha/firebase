import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';


class phonefire extends StatefulWidget {
  const phonefire({super.key});

  @override
  State<phonefire> createState() => _phonefireState();
}

class _phonefireState extends State<phonefire> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: otpVisibility,
              child: TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: "OTP",
                  prefix: Padding(
                    padding: const EdgeInsets.all(4),
                    child: const Text(""),
                  ),
                ),
                maxLength: 6,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (otpVisibility) {
                  verifyOTP();
                } else {
                  loginWithPhone();
                }
              },
              child: Text(
                otpVisibility ? "Verify" : "Login",
                style: const TextStyle(color: Colors.green, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic login on verification completion
        await auth.signInWithCredential(credential).then((value) {
          print("Logged in successfully");
          navigateToHome();
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        Get.snackbar("Error", "Verification failed. Please try again.");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          otpVisibility = true;
          verificationID = verificationId;
        });
        Get.snackbar("OTP Sent", "Please check your phone for the OTP code.");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationID = verificationId;
      },
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: otpController.text,
    );

    await auth.signInWithCredential(credential).then((value) {
      navigateToHome();
    }).catchError((e) {
      print("Error: $e");
      Get.snackbar("Error", "Verification failed. Please try again.");
    });
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homes()),
    );
    Get.snackbar("Success", "Logged in successfully!");
  }
}
