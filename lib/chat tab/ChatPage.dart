import 'package:chat/Models/UserModel.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../BaseConnector.dart';
import '../Models/MessageModel.dart';
import '../Register tab/RegisterConnector.dart';
import '../Register tab/Register_ViewModel.dart';
import '../Utils/ColorsApp.dart';
import '../Utils/TextStyles.dart';
import 'Layout.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = "chat";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends BaseView<Register_ViewModel, ChatPage>
    implements RegisterConnector {
  var text = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.connector = this;
    print(Register_ViewModel.current!.id);
  }

  final ChatUser _currentUser = ChatUser(
      id: Register_ViewModel.current!.id,
      firstName: Register_ViewModel.current!.name,
      profileImage: Register_ViewModel.current!.image);

  List<ChatMessage> _messages = [];
  List<ChatUser> _typingUsers = [];

  get response => null;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as UserModel;

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              _messages.clear();
              //Navigator.pushNamedAndRemoveUntil(context, Layout.routeName, (route) => false);
            },
            child: Icon(Icons.keyboard_backspace, color: ColorsApp.primary),
          ),
          elevation: 1,
          leadingWidth: 25.w,
          backgroundColor: Colors.black,
          toolbarHeight: 85.h,
          actions: [Icon(Icons.more_vert)],
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      foregroundImage: NetworkImage(args.image),
                      backgroundColor: Colors.white,
                      radius: 20,
                    ),
                    SizedBox(width: 10.w),
                    Text(args.name),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                  width: 5.w,
                ),

              ],
            ),
          ),
        ),
        body: StreamBuilder(
          stream: viewModel.getMessageOwn(userId: args.id),
          builder: (context, snapshot) {
            List<ChatMessage> OwnUser =
                snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
            print(OwnUser.length);
            for (int i = 0; i < OwnUser.length; i++) {
              int count = 0;
              for (int j = 0; j < _messages.length; j++) {
                if (OwnUser[i].id != _messages[j].id) {
                  count++;
                }
              }
              if (count == _messages.length) {
                _messages.add(OwnUser[i]);
              }
            }
            //_messages.addAll(OwnUser);
            print(OwnUser.length);
            return StreamBuilder(
              stream: viewModel.getMessageUsers(userId: args.id),
              builder: (context, snapshot2) {
                List<ChatMessage> OtherUser =
                    snapshot2.data?.docs.map((e) => e.data()).toList() ?? [];
                for (int k = 0; k < OtherUser.length; k++) {
                  int conter = 0;
                  for (int l = 0; l < _messages.length; l++) {
                    if (OtherUser[k].id != _messages[l].id) {
                      conter++;
                    }
                  }
                  if (conter == _messages.length) {
                    _messages.add(OtherUser[k]);
                  }
                }
                //_messages.addAll(OtherUser);
                return DashChat(
                    inputOptions: InputOptions(
                        inputToolbarStyle: BoxDecoration(
                          color: Colors.white,
                        ),
                        //inputToolbarPadding: EdgeInsets.all(8),
                        autocorrect: true,
                        inputMaxLines: 25,
                        leading: [
                          InkWell(
                            onTap: () {
                              _handleFileSelection();
                            },
                            child: Icon(Icons.attach_file,
                                color: ColorsApp.primary),
                          ),
                          InkWell(
                            onTap: () {
                              _handleImageSelection();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.camera_alt_outlined,
                                  color: ColorsApp.primary),
                            ),
                          )
                        ]),
                    currentUser: _currentUser,

                    //typingUsers: [ChatUser(id: args.id,firstName: args.name,profileImage: args.image)],
                    messageOptions: const MessageOptions(
                      showTime: true,
                      timeTextColor: Colors.white,
                      showCurrentUserAvatar: false,
                      showOtherUsersName: true,
                      showOtherUsersAvatar: false,
                      spaceWhenAvatarIsHidden: 10,
                      currentUserContainerColor: Color(0xff8967B3),
                      containerColor: Color.fromRGBO(
                        42,
                        39,
                        39,
                        1.0,
                      ),
                      textColor: Colors.white,
                    ),
                    onSend: (ChatMessage m) {
                      m.user.id = Register_ViewModel.current!.id;
                      m.user.firstName = Register_ViewModel.current!.name;
                      m.user.profileImage = Register_ViewModel.current!.image;
                      m.sendto = args.id;
                      m.sendfrom = Register_ViewModel.current!.id;
                      _messages.insert(0, m);
                      //_messages.reversed;

                      //_typingUsers.add( ChatUser(id: args.id, firstName: args.name,profileImage: args.image));
                      viewModel.addMessageToFirestore(m);
                      //setState(() {});
                    },
                    quickReplyOptions: QuickReplyOptions(),
                    messages: _messages);
              },
            );
          },
        ),
      )),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {});
  }

// Padding(
//   padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.w),
//   child: Column(
//     children: [
//       Expanded(
//         child: ListView.builder(
//           scrollDirection: Axis.vertical,
//           physics: PageScrollPhysics(),
//           itemCount: chat?.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r)),
//               tileColor: Colors.grey.withOpacity(0.2),
//               title: Text(chat![index], style: AppStyles.med),
//             );
//           },
//         ),
//       ),
//       Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               textInputAction: TextInputAction.done,
//               style: TextStyle(color: Colors.white),
//               autocorrect: true,
//               cursorColor: Colors.white,
//               controller: text,
//               keyboardType: TextInputType.multiline,
//               decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey.withOpacity(0.2),
//                   hintText: "Message",
//                   hintStyle: TextStyle(color: Colors.white),
//                   prefixIcon: Icon(Icons.emoji_emotions_outlined,
//                       color: ColorsApp.primary),
//                   suffixIcon: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             _handleFileSelection();
//                           },
//                           child: Icon(Icons.attach_file,
//                               color: ColorsApp.primary),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             _handleImageSelection();
//                           },
//                           child: Icon(Icons.camera_alt_outlined,
//                               color: ColorsApp.primary),
//                         )
//                       ],
//                     ),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   )),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return "Please enter message.";
//                 }
//                 return null;
//               },
//             ),
//           ),
//           SizedBox(
//             width: 2.w,
//           ),
//           CircleAvatar(
//               radius: 21.r,
//               backgroundColor: ColorsApp.primary,
//               child: IconButton(
//                 onPressed: () {
//                   Message = text.text;
//                   chat?.add(text.text);
//
//                   setState(() {
//                     text.clear();
//                   });
//                 },
//                 icon: Icon(Icons.send, color: Colors.white, size: 20.r),
//               ))
//         ],
//       )
//     ],
//   ),
// ),

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      // final message = types.ImageMessage(
      //   author: _user,
      //   createdAt: DateTime.now().millisecondsSinceEpoch,
      //   height: image.height.toDouble(),
      //   id: const Uuid().v4(),
      //   name: result.name,
      //   size: bytes.length,
      //   uri: result.path,
      //   width: image.width.toDouble(),
      // );

      //_addMessage(message);
    }
  }

  void _onSendTap(String message) {
    MessageModel current = MessageModel(
      id: DateTime.now().toString(),
      createdAt: DateTime.now(),
      message: message,
      sendBy: Register_ViewModel.current!.id,
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      // final message = types.FileMessage(
      //   author: _user,
      //   createdAt: DateTime.now().millisecondsSinceEpoch,
      //   id: const Uuid().v4(),
      //   mimeType: lookupMimeType(result.files.single.path!),
      //   name: result.files.single.name,
      //   size: result.files.single.size,
      //   uri: result.files.single.path!,
      // );

      //_addMessage(message);
    }
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
      Layout.routeName,
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
