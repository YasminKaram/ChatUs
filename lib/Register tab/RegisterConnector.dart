import 'package:chat/Models/UserModel.dart';

import '../BaseConnector.dart';

abstract class RegisterConnector extends BaseConnector{

  // بجمع فيه كل الfunctions  اللي انا محتاجها اللي هستخدمها في ال ui

  TOlogin();
  ToHome();
  Chat(UserModel userModel);

}