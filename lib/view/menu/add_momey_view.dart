import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/bank_row.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/common_widget/tag_button.dart';

class AddMoneyView extends StatefulWidget {
  const AddMoneyView({super.key});

  @override
  State<AddMoneyView> createState() => _AddMoneyViewState();
}

class _AddMoneyViewState extends State<AddMoneyView> {
  TextEditingController txtAdd = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtAdd.text = "48";
  }

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
          "Add money to wallet",
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
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available balance",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "\$54.57",
                    style: TextStyle(color: TColor.primaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Image.asset(
                    "assets/img/doller.png",
                    width: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      controller: txtAdd,
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Enter Add Wallet Amount",
                        hintStyle: TextStyle(
                          color: TColor.placeholder,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TagButton(title: "+10", onPressed: () {}),
                  TagButton(title: "+20", onPressed: () {}),
                  TagButton(title: "+50", onPressed: () {}),
                  TagButton(title: "+100", onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 12,
              color: TColor.lightWhite,
              width: double.maxFinite,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "From Bank Account",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                    ),
                  ),
                  Image.asset(
                    "assets/img/next.png",
                    width: 15,
                    height: 15,
                    color: TColor.primaryText,
                  )
                ],
              ),
            ),
          


          
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemBuilder: (context, index) {
              return const BankRow(bObj:{
                "icon":"assets/img/bank_logo.png",
                "name":"Standard Chartered Bank",
                "number":"**** 3315"
              } );
            }, separatorBuilder: (context, index) => const Divider(), itemCount: 1),


            Container(
              height: 12,
              color: TColor.lightWhite,
              width: double.maxFinite,
            ),
            const SizedBox(
              height: 15,
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundButton(title: "SUBMIT REQUEST", onPressed: (){
            
              }),
            ),

            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
