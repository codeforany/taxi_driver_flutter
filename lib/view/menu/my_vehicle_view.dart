import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/my_car_row.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/login/add_vehicle_view.dart';
import 'package:taxi_driver/view/login/vehicle_document_view.dart';
import 'package:taxi_driver/view/menu/my_car_details_view.dart';

class MyVehicleView extends StatefulWidget {
  const MyVehicleView({super.key});

  @override
  State<MyVehicleView> createState() => _MyVehicleViewState();
}

class _MyVehicleViewState extends State<MyVehicleView> {
  List listArr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCarsListApi();
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
                  var cObj = listArr[index] as Map? ?? {};

                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey("${cObj["user_car_id"]}"),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setCarRunningApi(
                                {"user_car_id": "${cObj["user_car_id"]}"});
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.directions_car,
                          label: 'Set',
                        ),
                        SlidableAction(
                          // An action can be bigger than the others.

                          onPressed: (context) {
                            carsDeleteApi(
                                {"user_car_id": "${cObj["user_car_id"]}"},
                                index);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: MyCarRow(
                      cObj: cObj,
                      onPressed: () {
                        context.push(VehicleDocumentUploadView(
                          obj: cObj,
                        ));
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                      height: 0.5,
                    ),
                itemCount: listArr.length),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundButton(
                title: "ADD A VEHICLE",
                onPressed: () async {
                  await context.push(const AddVehicleView());
                  getCarsListApi();
                }),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  //TODO: Action

  //TODO: ServiceCall
  void getCarsListApi() {
    Globs.showHUD();

    ServiceCall.post({}, SVKey.svCarList, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        listArr = responseObj[KKey.payload] as List? ?? [];
      } else {
        listArr = [];
      }

      if (mounted) {
        setState(() {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }

  void carsDeleteApi(Map<String, dynamic> parameter, int deleteIndex) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svDeleteCar, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        listArr.removeAt(deleteIndex);
      } else {
        listArr = [];
      }
      if (mounted) {
        setState(() {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }

  void setCarRunningApi(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svSetRunningCar, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        listArr = responseObj[KKey.payload] as List? ?? [];
      } else {
        mdShowAlert("Error", responseObj[KKey.message].toString(), () {});
      }
      if (mounted) {
        setState(() {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }
}
