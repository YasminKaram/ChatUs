import 'package:chat/BaseConnector.dart';
import 'package:chat/Login%20tab/Login.dart';

import 'package:chat/Models/UserModel.dart';
import 'package:chat/Register%20tab/RegisterConnector.dart';
import 'package:chat/Register%20tab/Register_ViewModel.dart';
import 'package:chat/Utils/ColorsApp.dart';
import 'package:chat/Utils/TextStyles.dart';
import 'package:chat/chat%20tab/ChatConnector.dart';
import 'package:chat/chat%20tab/ChatPage.dart';
import 'package:chat/chat%20tab/ChatViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  static const String routeName = "layout";

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends BaseView<Register_ViewModel, Layout>
    implements RegisterConnector {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.connector = this;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black12,
          appBar: AppBar(
              elevation: 15,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/icon.png", width: 35.w),
                  Text(
                    "ChatUs",
                    style: AppStyles.med,
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        viewModel.connector?.TOlogin();
                      },
                      child: Icon(Icons.logout))
                ],
              )),
          body: ChangeNotifierProvider(
            create: (context) => viewModel,
            child: Column(
              children: [
                StreamBuilder(
                  stream: viewModel.getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      viewModel.connector?.hideLoading();
                    } else if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    List<UserModel> users =
                        snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                    print(users);
                    if (users.isEmpty) {
                      return Center(child: Text("No users"));
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: ListTile(
                              onTap: () {
                                viewModel.connector?.Chat(users[index]);
                              },
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              users[index].name,
                                              style: AppStyles.med,
                                            ),
                                            Spacer(),
                                            Text(
                                              "12:44",
                                              style: AppStyles.med
                                                  .copyWith(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "last message.....",
                                          style: AppStyles.med.copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w200,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              leading: CircleAvatar(
                                foregroundImage:
                                    NetworkImage(users[index].image),
                                backgroundColor: Colors.white,
                                radius: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  side: BorderSide(color: ColorsApp.primary)),
                            ),
                          );
                        },
                        itemCount: users.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  @override
  Chat(UserModel userModel) {
    // TODO: implement Chat
    Navigator.pushNamed(context, ChatPage.routeName, arguments: userModel);
  }

  @override
  TOlogin() {
    // TODO: implement TOlogin
    Navigator.pushNamed(
      context,
      loginPage.routeName,
    );
  }

  @override
  ToHome() {
    // TODO: implement ToHome
    Navigator.pushNamed(context, Layout.routeName);
  }

  @override
  Register_ViewModel initMyViewModel() {
    // TODO: implement initMyViewModel
    return Register_ViewModel();
  }
}
