import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/common_widget/support_user_row.dart';
import 'package:taxi_driver/view/home/support/support_message_view.dart';

class SupportListView extends StatefulWidget {
  const SupportListView({super.key});

  @override
  State<SupportListView> createState() => _SupportListViewState();
}

class _SupportListViewState extends State<SupportListView> {
  List listArr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
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
          var uObj = listArr[index] as Map? ?? {};

          return SupportUserRow(
            uObj: uObj,
            onPressed: () async {
              await context.push(SupportMessageView(
                uObj: uObj,
              ));
              getList();
            },
          );
        },
        separatorBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Divider(),
        ),
        itemCount: listArr.length,
      ),
    );
  }

  //TODO: ApiCalling

  void getList() {
    Globs.showHUD();
    ServiceCall.post({
      "socket_id": SocketManager.shared.socket?.id ?? ""
    }, SVKey.svSupportList, isTokenApi: true, withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        listArr = responseObj[KKey.payload] as List? ?? [];
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
}
