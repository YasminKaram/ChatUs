import 'package:chat/Login%20tab/BottomSheet.dart';
import 'package:chat/Models/UserModel.dart';
import 'package:chat/Utils/ColorsApp.dart';
import 'package:chat/Register%20tab/register.dart';
import 'package:chat/chat%20tab/Layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../BaseConnector.dart';

import '../Register tab/RegisterConnector.dart';
import '../Register tab/Register_ViewModel.dart';
import '../Utils/TextStyles.dart';

class loginPage extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends BaseView<Register_ViewModel, loginPage>
    implements RegisterConnector {
  GlobalKey<FormState> formKey = GlobalKey();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  var emailReset = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.connector = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(top: 120.h),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/icon.png",
                  height: 200.h,
                  width: 150.w,
                ),
                Text(
                  "Login to your account",
                  style: AppStyles.med,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  cursorColor: Colors.white,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hoverColor: Colors.white,
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon:
                          Icon(Icons.person_outline, color: ColorsApp.primary),
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
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Email.";
                    }
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  cursorColor: Colors.white,
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    suffixIcon: Icon(CupertinoIcons.eye_slash,color: ColorsApp.primary),
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.password_outlined,
                          color: ColorsApp.primary),
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
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password.";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: ColorsApp.primary),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      viewModel.SignIn(
                          emailController.text, passwordController.text);
                    }
                  },
                  child: const Text("Login"),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " don't have account?",
                      style: AppStyles.med.copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Register.routeName);
                      },
                      child: Text(
                        " Register",
                        style: AppStyles.med.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorsApp.primary),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showSheet();
                  },
                  child: Text(
                    " ForgetPassword",
                    style: AppStyles.med.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsApp.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  TOlogin() {
    // TODO: implement TOlogin
    throw UnimplementedError();
  }

  @override
  ToHome() {
    // TODO: implement ToHome
    Navigator.pushNamedAndRemoveUntil(
        context, Layout.routeName, (route) => false);
  }

  @override
  Register_ViewModel initMyViewModel() {
    // TODO: implement initMyViewModel
    return Register_ViewModel();
  }

  @override
  Chat(UserModel userModel) {
    // TODO: implement Chat
    throw UnimplementedError();
  }

  showSheet() {
    return showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomSheetReset(),
        );
      },
    );
  }
}
