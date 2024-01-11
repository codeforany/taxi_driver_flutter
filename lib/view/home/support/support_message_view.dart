import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';

class SupportMessageView extends StatefulWidget {
  const SupportMessageView({super.key});

  @override
  State<SupportMessageView> createState() => _SupportMessageViewState();
}

class _SupportMessageViewState extends State<SupportMessageView> {
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
              child: Image.asset(
                "assets/img/u1.png",
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                "User1",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemBuilder: (context, index) {
          var isSendMessage = index % 2 == 0;
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
                  "7:00 pm",
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
                    " Hello World ",
                    style: TextStyle(
                      fontSize: 17,
                      color: isSendMessage ? TColor.primaryTextW : TColor.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: isSendMessage ? TextAlign.right : TextAlign.left,
                  ),
                ),
              )
            ],
          );
        },
        itemCount: 10,
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
                      onPressed: () {},
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
}
