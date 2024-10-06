import 'dart:io';
import 'dart:typed_data';

import 'package:chat/BaseConnector.dart';

import 'package:chat/Login%20tab/Login.dart';
import 'package:chat/Models/UserModel.dart';
import 'package:chat/Register%20tab/RegisterConnector.dart';
import 'package:chat/Register%20tab/Register_ViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/ColorsApp.dart';
import '../Utils/TextStyles.dart';
import '../chat tab/Layout.dart';

class Register extends StatefulWidget {
  static const String routeName = "register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends BaseView<Register_ViewModel, Register>
    implements RegisterConnector {
  GlobalKey<FormState> formKey = GlobalKey();

  var emailController = TextEditingController();

  var nameController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.connector = this;
  }

  var _images = [];
  String ?image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(top: 60.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    uploadImageToFirestore();
                  setState(() {

                  });
                  },
                  child: image==null ?Image.asset("assets/images/img_1.png",
                    height: 100.h,
                    width: 100.w,
                  ):Image.network(image!, height: 100.h,
                    width: 100.w,),
                ),
                Text(
                  "Create account",
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
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hoverColor: Colors.white,
                      labelText: "Name",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white),
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
                      return "Please enter Name.";
                    }
                    return null;
                  },
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
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon:
                          Icon(Icons.email_outlined, color: ColorsApp.primary),
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
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  cursorColor: Colors.white,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hoverColor: Colors.white,
                      labelText: "phone number",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.phone, color: ColorsApp.primary),
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
                      return "Please enter phone number.";
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
                  height: 30.h,
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
                      viewModel.createUser(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          phoneController.text,image!);
                    }
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Register_ViewModel initMyViewModel() {
    // TODO: implement initMyViewModel
    return Register_ViewModel();
  }

  @override
  TOlogin() {
    // TODO: implement TOlogin
    Navigator.pushNamed(context, loginPage.routeName);
  }

  @override
  ToHome() {
    // TODO: implement ToHome
    Navigator.pushNamedAndRemoveUntil(
        context, Layout.routeName, (route) => false);
  }

  @override
  Chat(UserModel userModel) {
    // TODO: implement Chat
    throw UnimplementedError();
  }
  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }

  Future<void> uploadImageToFirestore() async {
    XFile? pickedImage = await pickImage();
    if (pickedImage != null) {
      String fileName = pickedImage.name;
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(File(pickedImage.path,),SettableMetadata(contentType:"image/jpg"));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      image=imageUrl;
      print(image);

      // await FirebaseFirestore.instance
      //     .collection('User')
      //     .add({'image': imageUrl});

      print('Image uploaded successfully!');
      setState(() {

      });
    } else {
      print('No image picked!');
    }
  }
}
