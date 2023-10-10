import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/my_car_row.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/menu/my_car_details_view.dart';

class MyVehicleView extends StatefulWidget {
  const MyVehicleView({super.key});

  @override
  State<MyVehicleView> createState() => _MyVehicleViewState();
}

class _MyVehicleViewState extends State<MyVehicleView> {
  List listArr = [
    {
      "name": "Toyota Prius",
      "no_plat": "AB 1234",
      "image": "assets/img/user_car.png"
    },
    {
      "name": "Toyota Prius",
      "no_plat": "AB 1234",
      "image": "assets/img/user_car.png"
    },
    {
      "name": "Toyota Prius",
      "no_plat": "AB 1234",
      "image": "assets/img/user_car.png"
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
          "My Vehicle",
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                itemBuilder: (context, index) {
                  return MyCarRow(
                    cObj: listArr[index] as Map? ?? {},
                    onPressed: () {
                      context.push( const MyCarDetailsView() );
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                      height: 0.5,
                    ),
                itemCount: listArr.length),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundButton(title: "ADD A VEHICLE", onPressed: () {}),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
