import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/ColorsApp.dart';

class BottomSheetReset extends StatefulWidget {
  @override
  State<BottomSheetReset> createState() => _BottomSheetResetState();
}

class _BottomSheetResetState extends State<BottomSheetReset> {
  var emailReset = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Enter your email",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.primary)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white),
            autocorrect: true,
            cursorColor: Colors.white,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon:
                    Icon(Icons.password_outlined, color: ColorsApp.primary),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsApp.primary),
                  borderRadius: BorderRadius.circular(10),
                )),
            controller: emailReset,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(170, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: ColorsApp.primary),
            onPressed: () {
              if (emailReset != null) {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailReset.text);
              }
              emailReset.clear();
              Navigator.pop(context);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                        title: Text("Message"),
                        content: Text("Check your email"),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      ColorsApp.primary)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"))
                        ],
                      ));
            },
            child: const Text("Send"),
          ),
        ),
      ],
    );
  }
}
