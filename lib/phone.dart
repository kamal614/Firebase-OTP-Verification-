import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String? otP;
  bool otpField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("App to Demonstrate OTP from Firebase"),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Enter Phone No."),
              controller: phoneController,
            ),
            Visibility(
              visible: otpField,
              child: TextField(
                decoration: InputDecoration(labelText: "Enter OTP"),
                controller: otpController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  requestOTP();
                },
                child: Text(otpField ? "Verify OTP" : "Request OTP"))
          ],
        ),
      ),
    );
  }

  void requestOTP() {
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth
              .signInWithCredential(credential)
              .then((value) => print("You are logged it"));
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          otP = verificationID;

          otpField = true;
          setState(() {});
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("OTP Sent Successfully")));
        },
        codeAutoRetrievalTimeout: (String verificationID) {});

    // PhoneAuthOptions options =
    //         PhoneAuthOptions.newBuilder(mAuth)
    //                 .setPhoneNumber(phoneNumber)       // Phone number to verify
    //                 .setTimeout(60L, TimeUnit.SECONDS) // Timeout and unit
    //                 .setActivity(this)                 // Activity (for callback binding)
    //                 .setCallbacks(mCallBack)          // OnVerificationStateChangedCallbacks
    //                 .build();
    // PhoneAuthProvider.verifyPhoneNumber(options);
  }
}
