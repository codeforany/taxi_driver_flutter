import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/drop_down_button.dart';
import 'package:taxi_driver/common_widget/image_picker_view.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/popup_layout.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  TextEditingController txtSeat = TextEditingController();
  TextEditingController txtBrandName = TextEditingController();
  TextEditingController txtModelName = TextEditingController();
  TextEditingController txtNumberPlate = TextEditingController();
  TextEditingController txtSeries = TextEditingController();
  File? selectImage;

  List brandArr = [];
  List modelArr = [];
  List seriesArr = [];

  Map? selectBrandObj;
  Map? selectModelObj;
  Map? selectSeriesObj;

  int otherFlag = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBrandList();
  }

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
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
          "Add Vehicle",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 25,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              LineDropDownButton(
                  title: "Brand",
                  hintText: "Select Brand",
                  itemsArr: brandArr,
                  selectVal: selectBrandObj,
                  didChanged: (bObj) {
                    selectBrandObj = bObj;
                    selectModelObj = null;
                    selectSeriesObj = null;
                    if (bObj["brand_id"] == 0) {
                      otherFlag = 1;
                      //Display New Enter Brand
                    } else {
                      getModelList({"brand_id": bObj["brand_id"].toString()});
                    }

                    setState(() {});
                  },
                  displayKey: "brand_name"),
              const SizedBox(
                height: 8,
              ),
              if ((selectBrandObj?["brand_id"] as int? ?? -1) == 0)
                LineTextField(
                  title: "Enter Brand",
                  hintText: "Ex: BMW",
                  controller: txtBrandName,
                ),
              const SizedBox(
                height: 8,
              ),

              if ( !((selectBrandObj?["brand_id"] as int? ?? -1) == 0))
              LineDropDownButton(
                  title: "Model",
                  hintText: "Select Model",
                  itemsArr: modelArr,
                  selectVal: selectModelObj,
                  didChanged: (mObj) {
                    selectModelObj = mObj;
                    selectSeriesObj = null;

                    if (mObj["model_id"] == 0) {
                      otherFlag = 2;
                      //Display New Enter Model
                    } else {
                      getSeriesList({"model_id": mObj["model_id"].toString()});
                    }

                    setState(() {});
                  },
                  displayKey: "model_name"),
              const SizedBox(
                height: 8,
              ),
              if ((selectBrandObj?["brand_id"] as int? ?? -1) == 0 ||
                  (selectModelObj?["model_id"] as int? ?? -1) == 0)
              LineTextField(
                title: "Enter Model",
                hintText: "Ex: ABC",
                controller: txtModelName,
              ),
              const SizedBox(
                height: 8,
              ),
              
              if (!((selectBrandObj?["brand_id"] as int? ?? -1) == 0 || (selectModelObj?["model_id"] as int? ?? -1) == 0))
              LineDropDownButton(
                  title: "Series",
                  hintText: "Select Series",
                  itemsArr: seriesArr,
                  selectVal: selectSeriesObj,
                  didChanged: (sObj) {
                    selectSeriesObj = sObj;
                    if (sObj["series_id"] == 0) {
                      otherFlag = 3;
                    }
                    setState(() {});
                  },
                  displayKey: "series_name"),
              const SizedBox(
                height: 8,
              ),
              if ((selectBrandObj?["brand_id"] as int? ?? -1) == 0 ||
                  (selectModelObj?["model_id"] as int? ?? -1) == 0 ||
                  (selectSeriesObj?["series_id"] as int? ?? -1) == 0)
                LineTextField(
                  title: "Enter Series",
                  hintText: "X1",
                  controller: txtSeries,
                ),
              
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Seat",
                hintText: "Ex: No of Seat available",
                controller: txtSeat,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Number Plate",
                hintText: "YT12345",
                controller: txtNumberPlate,
              ),

               const SizedBox(
                height: 25,
              ),


              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    PopupLayout(
                      child: ImagePickerView(
                        didSelect: (imagePath) {
                          selectImage = File(imagePath);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: media.width - 120,
                  height: media.width - 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: selectImage != null
                        ? Image.file(
                            selectImage!,
                            width: media.width-120,
                            height: media.width - 120,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.directions_car,
                            size: 150,
                            color: TColor.secondaryText,
                          ),
                  ),
                ),
              ),



              
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                onPressed: submitCarAction,
                title: "REGISTER",
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Action
  void submitCarAction() {
    if(selectBrandObj == null) {
      mdShowAlert("Error", "Please select your car brand", () { });
      return;
    }

    if (otherFlag == 1 && txtBrandName.text.isEmpty) {
      mdShowAlert("Error", "Please enter your car brand name", () {});
      return;
    }

    if ( otherFlag > 1 &&  selectModelObj == null) {
      mdShowAlert("Error", "Please select your car model", () {});
      return;
    }

    if (otherFlag > 0 && otherFlag <=2 && txtModelName.text.isEmpty) {
      mdShowAlert("Error", "Please enter your car model name", () {});
      return;
    }

    if (otherFlag > 2 &&  selectSeriesObj == null) {
      mdShowAlert("Error", "Please select your car series", () {});
      return;
    }

    if(txtSeat.text.isEmpty) {
      mdShowAlert("Error", "Please enter your car seat", () {});
      return;
    }

    if (txtNumberPlate.text.isEmpty) {
      mdShowAlert("Error", "Please enter your car number plate", () {});
      return;
    }

    if (selectImage == null) {
      mdShowAlert("Error", "Please select your car image", () {});
      return;
    }

    endEditing();

    submitCarApi({
      "other_status":otherFlag.toString(),
      "brand": otherFlag == 1 ? txtBrandName.text : selectBrandObj!["brand_id"].toString(),
      "model": otherFlag > 0 && otherFlag <= 2 ? txtModelName.text : selectModelObj!["model_id"].toString(),
      "series": otherFlag > 0 ? txtSeries.text : selectSeriesObj!["series_id"].toString() ,
      "seat": txtSeat.text.toString(),
      "car_number": txtNumberPlate.text
    });

  }

  //TODO: ServiceCall

  void getBrandList() {
    Globs.showHUD();
    ServiceCall.post({}, SVKey.svBrandList, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if ((responseObj[KKey.status] as String? ?? "") == "1") {
        brandArr = responseObj[KKey.payload] as List? ?? [];
      } else {
        brandArr = [];
      }

      setState(() {});
    }, failure: (err) async {
      mdShowAlert("Error", err, () {});
    });
  }

  void getModelList(Map<String, dynamic> parameter) {
    Globs.showHUD();
    ServiceCall.post(parameter, SVKey.svModelList, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if ((responseObj[KKey.status] as String? ?? "") == "1") {
        modelArr = responseObj[KKey.payload] as List? ?? [];
      } else {
        modelArr = [];
      }

      setState(() {});
    }, failure: (err) async {
      mdShowAlert("Error", err, () {});
    });
  }

  void getSeriesList(Map<String, dynamic> parameter) {
    Globs.showHUD();
    ServiceCall.post(parameter, SVKey.svSeriesList, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if ((responseObj[KKey.status] as String? ?? "") == "1") {
        seriesArr = responseObj[KKey.payload] as List? ?? [];
      } else {
        seriesArr = [];
      }

      setState(() {});
    }, failure: (err) async {
      mdShowAlert("Error", err, () {});
    });
  }

  void submitCarApi(Map<String, String> parameter) {
    Globs.showHUD();
    ServiceCall.multipart(parameter, SVKey.svAddCar,
        isTokenApi: true, imgObj: {"image": selectImage! }, withSuccess: (responseObj) async {
      Globs.hideHUD();
      if ((responseObj[KKey.status] ?? "") == "1") {
  
        mdShowAlert("Success", responseObj[KKey.message] ?? MSG.success, () {
          Navigator.pop(context);
        });
      } else {
        mdShowAlert("Error", responseObj[KKey.message] ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err, () {});
    });
  }
}
