import 'package:chat/BaseConnector.dart';
import 'package:chat/Models/UserModel.dart';
import 'package:chat/Register%20tab/RegisterConnector.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/MessageModel.dart';

class Register_ViewModel extends BaseViewModel<RegisterConnector> {
  static String? message;
  static UserModel? current;

  Future<void> createUser(String email, String password, String name,
      String phone, String image) async {
    try {
      connector!.showLoading();
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user?.sendEmailVerification();
      if (credential.user?.uid != null) {
        UserModel userModel = UserModel(
            id: credential.user!.uid,
            name: name,
            email: email,
            phone: phone,
            image: image);
        addUserToFirestore(userModel);
        connector!.hideLoading();
        connector!.TOlogin();
        connector!.showMessage("Please verify your email");
        //check verify before login
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        connector!.hideLoading();
        connector!.showMessage("The password provided is too weak.");
        //print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        connector!.hideLoading();
        connector!.showMessage("The account already exists for that email.");
        //print('The account already exists for that email.');
      }
    } catch (e) {
      connector!.hideLoading();
      connector!.showMessage(e.toString());
      print(e);
    }
  }

  Future<void> SignIn(String email, String password) async {
    try {
      connector!.showLoading();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //email verify
      if (credential.user?.uid != null) {
        current = await readUserFromFirestore(credential.user!.uid);
        print(current!.name);
//check verify before login
        if (credential.user!.emailVerified) {
          connector!.hideLoading();
          connector!.ToHome();
        } else {
          connector!.hideLoading();
          connector!.showMessage("Please verify your email");
        }
      }
    } on FirebaseAuthException catch (e) {
      connector!.hideLoading();
      connector!.showMessage("${e.message}");
    }
  }

  CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance.collection("User").withConverter(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  Future<void> addUserToFirestore(UserModel userModel) {
    var collection = getUserCollection();
    var docref = collection.doc(userModel.id);
    return docref.set(userModel);
  }

  Future<UserModel?> readUserFromFirestore(String id) async {
    DocumentSnapshot<UserModel> doc = await getUserCollection().doc(id).get();
    return doc.data();
  }

  Stream<QuerySnapshot<UserModel>>? getUsers() {
    try {
      //connector!.hideLoading();
      // connector!.showLoading();
      return getUserCollection()
          .where("id", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
      // .where("date",
      // isEqualTo: DateUtils.dateOnly(dateTime).millisecondsSinceEpoch)
      //     .snapshots();
      //
    } on FirebaseAuthException catch (e) {
      connector!.hideLoading();
      connector!.showMessage("Error");
    }
  }

  CollectionReference<ChatMessage> getMessageCollection() {
    return FirebaseFirestore.instance.collection("Messages").withConverter(
      fromFirestore: (snapshot, options) {
        print(snapshot.data());
        return ChatMessage.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  Future<void> addMessageToFirestore(ChatMessage message) {
    var collection = getMessageCollection();
    var documentRef = collection.doc();
    message.id = documentRef.id;
    return documentRef.set(message);
  }

  Stream<QuerySnapshot<ChatMessage>>? getMessageUsers(
      { required String userId}) {
    try {
      // connector!.showLoading();
      return getMessageCollection()
          .where("sendto", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("sendfrom", isEqualTo: userId)
          .snapshots();

      connector!.hideLoading();
    } on FirebaseAuthException catch (e) {
      connector!.hideLoading();
      connector!.showMessage("Error");
    }
  }


  Stream<QuerySnapshot<ChatMessage>>? getMessageOwn(
      { required String userId}) {
    try {
       //connector!.showLoading();
      return getMessageCollection()
          .where("sendto", isEqualTo:userId )
          .where("sendfrom", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
      connector!.hideLoading();
    } on FirebaseAuthException catch (e) {
      connector!.hideLoading();
      connector!.showMessage("Error");
    }
  }
}
