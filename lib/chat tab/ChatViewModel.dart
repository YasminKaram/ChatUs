import 'package:chat/Models/UserModel.dart';
import 'package:chat/Register%20tab/Register_ViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../BaseConnector.dart';
import 'ChatConnector.dart';

class ChatViewModel extends BaseViewModel<ChatConnector>{
  Register_ViewModel ? register_viewModel;


}