import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/support_user_row.dart';
import 'package:taxi_driver/view/home/support/support_message_view.dart';

class SupportListView extends StatefulWidget {
  const SupportListView({super.key});

  @override
  State<SupportListView> createState() => _SupportListViewState();
}

class _SupportListViewState extends State<SupportListView> {
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
        centerTitle: true,
        title: Text(
          "Supports",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemBuilder: (context, index) {
          return SupportUserRow(
            onPressed: () {
              context.push(const SupportMessageView());
            },
          );
        },
        separatorBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Divider(),
        ),
        itemCount: 10,
      ),
    );
  }
}
