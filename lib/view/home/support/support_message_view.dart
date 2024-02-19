import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';

class SupportMessageView extends StatefulWidget {
  final Map uObj;
  const SupportMessageView({super.key, required this.uObj});

  @override
  State<SupportMessageView> createState() => _SupportMessageViewState();
}

class _SupportMessageViewState extends State<SupportMessageView> {
  TextEditingController txtMessage = TextEditingController();
  List listArr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessageList();

    // Received Message In Socket On Event
    SocketManager.shared.socket?.on("support_message", (data) {
      print("support_message socket get :${data.toString()} ");
      if (data[KKey.status] == "1") {
        var mObj = data[KKey.payload] as List? ?? [];
        if (mObj[0]["sender_id"] == widget.uObj["user_id"]) {
          listArr.add(mObj[0]);
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.lightWhite,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: widget.uObj["image"] as String? ?? "",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                widget.uObj["name"] as String? ?? "",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearMessageAction();
            },
            child: Text(
              "Clear All",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemBuilder: (context, index) {
          var mObj = listArr[index] as Map? ?? {};

          var isSendMessage =
              ServiceCall.userObj["user_id"] == mObj["sender_id"];
          return Column(
            children: [
              Bubble(
                margin: const BubbleEdges.only(top: 3),
                padding: const BubbleEdges.all(0),
                alignment:
                    isSendMessage ? Alignment.topRight : Alignment.topLeft,
                elevation: 0,
                color: Colors.transparent,
                child: Text(
                  (mObj["created_date"] as String? ?? "").timeAgo(),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: TColor.secondaryText,
                  ),
                  textAlign: isSendMessage ? TextAlign.right : TextAlign.left,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Bubble(
                  margin: const BubbleEdges.only(bottom: 5),
                  padding:
                      const BubbleEdges.symmetric(horizontal: 15, vertical: 10),
                  alignment:
                      isSendMessage ? Alignment.topRight : Alignment.topLeft,
                  elevation: 0.5,
                  radius: const Radius.circular(20.0),
                  color:
                      isSendMessage ? TColor.primary : const Color(0xffF6F6F6),
                  child: Text(
                    mObj[KKey.message] as String? ?? "",
                    style: TextStyle(
                      fontSize: 17,
                      color: isSendMessage
                          ? TColor.primaryTextW
                          : TColor.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: isSendMessage ? TextAlign.right : TextAlign.left,
                  ),
                ),
              )
            ],
          );
        },
        itemCount: listArr.length,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 1.5,
            color: Colors.black26,
            offset: Offset(0, -1),
          ),
        ]),
        padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
            top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xfff0f0f0),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 100.0,
                        ),
                        child: TextField(
                          controller: txtMessage,
                          maxLines: null,
                          autocorrect: false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Type Here",
                            hintStyle: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: TColor.primaryText,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        sendMessageAction();
                      },
                      child: Icon(
                        Icons.send,
                        size: 25,
                        color: TColor.primary,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //TODO: Action
  void sendMessageAction() {
    if (txtMessage.text.isEmpty) {
      return;
    }

    sendMessageApi({
      "receiver_id": widget.uObj["user_id"].toString(),
      "message": txtMessage.text,
      "socket_id": SocketManager.shared.socket?.id ?? ""
    });
  }

  void clearMessageAction(){
    clearMessageApi({"receiver_id" : widget.uObj["user_id"].toString() });
  }

  //TODO: ApiCalling

  void getMessageList() {
    Globs.showHUD();
    ServiceCall.post({
      "user_id": widget.uObj["user_id"].toString(),
      "socket_id": SocketManager.shared.socket?.id ?? ""
    }, SVKey.svSupportConnect, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        var payloadObj = responseObj[KKey.payload] as Map? ?? {};
        listArr = payloadObj["messages"] as List? ?? [];
        if (mounted) {
          setState(() {});
        }
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (error) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, error as String? ?? MSG.fail, () {});
    });
  }

  void sendMessageApi(Map<String, String> parameter) {
    ServiceCall.post(parameter, SVKey.svSupportSendMessage, isTokenApi: true,
        withSuccess: (responseObj) async {
      if (responseObj[KKey.status] == "1") {
        listArr.add(responseObj[KKey.payload] as Map? ?? {});
        txtMessage.text = "";
        if (mounted) {
          setState(() {});
        }
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (error) async {
      mdShowAlert(Globs.appName, error as String? ?? MSG.fail, () {});
    });
  }

  void clearMessageApi(Map<String, String> parameter) {
    ServiceCall.post(parameter, SVKey.svSupportClear, isTokenApi: true,
        withSuccess: (responseObj) async {
      if (responseObj[KKey.status] == "1") {
        listArr = [];
        if (mounted) {
          setState(() {});
        }
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (error) async {
      mdShowAlert(Globs.appName, error as String? ?? MSG.fail, () {});
    });
  }
}
