import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/wallet_row.dart';
import 'package:taxi_driver/view/menu/add_momey_view.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  List walletArr = [
    {
      "icon": "assets/img/wallet_add.png",
      "name": "Added to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/trips_cut.png",
      "name": "Trip Deducted",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/withdraw.png",
      "name": "Withdraw to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
        {
      "icon": "assets/img/wallet_add.png",
      "name": "Added to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/trips_cut.png",
      "name": "Trip Deducted",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/withdraw.png",
      "name": "Withdraw to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
        {
      "icon": "assets/img/wallet_add.png",
      "name": "Added to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/trips_cut.png",
      "name": "Trip Deducted",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
    {
      "icon": "assets/img/withdraw.png",
      "name": "Withdraw to Wallet",
      "time": "1 Feb'19 • #123467",
      "price": "\$40"
    },
  ];

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
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Wallet",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 12,
              color: TColor.lightWhite,
              width: double.maxFinite,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Total balance",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 16,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "\$",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "54.57",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 0.5,
              color: TColor.lightGray,
              width: double.maxFinite,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "WITHDRAW",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.5,
                  color: TColor.lightGray,
                  height: 55,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.push(const AddMoneyView());
                    },
                    child: Text(
                      "ADD MONEY",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 12,
              color: TColor.lightWhite,
              width: double.maxFinite,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: TColor.lightWhite,
              width: double.maxFinite,
              child: Text(
                "APRIL 2023",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemBuilder:(context, index) {
                var wObj = walletArr[index] as Map? ?? {};
              return WalletRow(wObj: wObj);
            } , separatorBuilder: (context, index) => const Divider(indent: 50,) , itemCount: walletArr.length)
          ],
        ),
      ),
    );
  }
}
