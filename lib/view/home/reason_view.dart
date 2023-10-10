import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class ReasonView extends StatefulWidget {
  const ReasonView({super.key});

  @override
  State<ReasonView> createState() => _ReasonViewState();
}

class _ReasonViewState extends State<ReasonView> {
  List reasonArr = [
    "Rider isn't here",
    "Wrong address shown",
    "Don't charge rider"
  ];

  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/close.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Cancel Trip",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: reasonArr.length,
              separatorBuilder: (context, index) => Divider(
                color: TColor.placeholder,
                indent: 80,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        selectIndex = index;
                      });
                    },
                    icon: Image.asset(
                      selectIndex == index
                          ? "assets/img/check_list.png"
                          : "assets/img/uncheck_list.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  title: Text(
                    reasonArr[index] as String? ?? "",
                    style: TextStyle(
                      color: selectIndex == index
                          ? TColor.primaryText
                          : TColor.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: "DONE",
                onPressed: () {
                  context.pop();
                }),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
