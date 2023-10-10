import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/login/document_upload_view.dart';
import 'package:taxi_driver/view/login/vehicle_document_view.dart';

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  TextEditingController txtServiceType = TextEditingController();
  TextEditingController txtBrandName = TextEditingController();
  TextEditingController txtModelName = TextEditingController();
  TextEditingController txtManufacturer = TextEditingController();
  TextEditingController txtNumberPlate = TextEditingController();
  TextEditingController txtColor = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              LineTextField(
                title: "Service Type",
                hintText: "Ex: Micro",
                controller: txtServiceType,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Brand (Auto Suggestion)",
                hintText: "Ex: BMW",
                controller: txtBrandName,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Model (Auto Suggestion)",
                hintText: "Ex: ABC",
                controller: txtModelName,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Manufacturer (Auto Suggestion)",
                hintText: "BMW",
                controller: txtManufacturer,
               
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
                height: 8,
              ),
              LineTextField(
                title: "Color",
                hintText: "Red",
                controller: txtColor,
              ),
              
              const SizedBox(
                height: 15,
              ),
              RoundButton(
                onPressed: () {
                  context.push( const VehicleDocumentUploadView() );
                },
                title: "REGISTER",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
