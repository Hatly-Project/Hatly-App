import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/data/api/shipmentDeal.dart';
import 'package:hatly/data/firebase/firebase_manger.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/message_model.dart';
import 'package:hatly/presentation/components/reciever_message_card.dart';
import 'package:hatly/presentation/components/sender_message_card.dart';
import 'package:hatly/presentation/home/tabs/chat/chat_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/chat/chat_screen_viewmodel.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'ChatScreen';
  ChatScreenArguments chatScreenArguments;
  ChatScreen({required this.chatScreenArguments});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatScreenViewModel viewModel;
  late LoggedInState loggedInState;
  TextEditingController messageController = TextEditingController(text: '');
  bool isLoading = false;
  Future<void> createDealsCollection() async {
    return viewModel.createDealCollection(widget.chatScreenArguments.dealDto);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = ChatScreenViewModel();
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    // accessTokenProvider =
    //     Provider.of<AccessTokenProvider>(context, listen: false);
    // viewModel = MyShipmentsScreenViewModel(accessTokenProvider);
// Check if the current state is LoggedInState and then access the token
    print('deal id ${widget.chatScreenArguments.dealDto.id}');
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      // token = loggedInState.accessToken;
      // // Now you can use the 'token' variable as needed in your code.
      // print('User token: $token');
      // createDealsCollection();
      print('user id ${loggedInState.user.id}');
      // getAccessToken(accessTokenProvider)
      //     .then((accessToken) => token = accessToken);
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            automaticallyImplyLeading: true,
            title: Text(
              'Chat',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SenderMessageCard(message: 'hello there'),
              // RecieverMessageCard(message: 'hello how are you ?'),
              // SenderMessageCard(message: 'hello there'),

              Expanded(
                child: StreamBuilder<QuerySnapshot<MessageModel>>(
                  stream: FirebaseManger.getMessagesCollection(
                          widget.chatScreenArguments.dealDto.id.toString())
                      .orderBy('datetime', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      if (Platform.isIOS) {
                        DialogUtils.showDialogIos(
                            context: context,
                            alertMsg: 'Fail',
                            alertContent: snapshot.error.toString());
                      } else {
                        DialogUtils.showDialogAndroid(
                            alertMsg: 'Fail',
                            alertContent: snapshot.error.toString(),
                            context: context);
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      print('waitttt');
                      return Center(child: CircularProgressIndicator());
                    }
                    // print(
                    //     'dataaaa ${snapshot.data!.docs.first.data().content}');
                    isLoading = false;
                    var data =
                        snapshot.data?.docs.map((doc) => doc.data()).toList();
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return data![index].senderId ==
                                loggedInState.user.id.toString()
                            ? SenderMessageCard(message: data[index].content!)
                            : RecieverMessageCard(
                                message: data[index].content!);
                      },
                      itemCount: data?.length,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15, left: 15),
                    width: MediaQuery.sizeOf(context).width * .81,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: 'Enter Your Message',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: IconButton(
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          viewModel.sendMessage(
                              messageController.text,
                              loggedInState.user,
                              widget.chatScreenArguments.dealDto);
                          messageController.text = '';
                          setState(() {});
                        } else {
                          return;
                        }
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator(
                        radius: 25,
                        color: Colors.black,
                      )
                    : const CircularProgressIndicator(
                        color: Colors.black,
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
