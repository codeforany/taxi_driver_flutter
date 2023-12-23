import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/drop_down_button.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class DriverEditProfileView extends StatefulWidget {
  const DriverEditProfileView({super.key});

  @override
  State<DriverEditProfileView> createState() => _DriverEditProfileViewState();
}

class _DriverEditProfileViewState extends State<DriverEditProfileView> {
  FlCountryCodePicker countryCodePicker = const FlCountryCodePicker();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  late CountryCode countryCode;

  bool isMale = true;

  List zoneList = [];
  List serviceList = [];

  Map? selectZone;

  List<int> serviceOnIndex = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    txtName.text = "${ServiceCall.userObj["name"]}";
    txtEmail.text = "${ServiceCall.userObj["email"]}";
    txtMobile.text = "${ServiceCall.userObj["mobile"]}";
    isMale = "${ServiceCall.userObj["gender"]}" == "f";
    countryCode = countryCodePicker.countryCodes.firstWhere((element) =>
        element.dialCode == "${ServiceCall.userObj["mobile_code"]}");

    serviceOnIndex = "${ServiceCall.userObj["select_service_id"]}".split(",").map((id) => int.tryParse(id) ??  0 ).toList();
    
    getServiceZoneList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit profile",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 25,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 30,
              ),
              LineTextField(
                title: "Name",
                hintText: "Ex: Jon Amit",
                controller: txtName,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isMale
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: TColor.primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Male",
                              style: TextStyle(
                                  color: TColor.placeholder, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            !isMale
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: TColor.primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Female",
                              style: TextStyle(
                                  color: TColor.placeholder, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Email",
                hintText: "Ex: 123@mail.com",
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Mobile Number",
                style: TextStyle(color: TColor.placeholder, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      final code =
                          await countryCodePicker.showPicker(context: context);
                      if (code != null) {
                        countryCode = code;
                        setState(() {});
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 20,
                          child: countryCode.flagImage(),
                        ),
                        Text(
                          "  ${countryCode.dialCode}",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: txtMobile,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "9876543210",
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              LineDropDownButton(
                  title: "Zone",
                  hintText: "Select Zone",
                  itemsArr: zoneList,
                  selectVal: selectZone,
                  didChanged: (newObj) {
                    setState(() {
                      selectZone = newObj;
                    });
                  },
                  displayKey: "zone_name"),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Service List",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 25,
                    fontWeight: FontWeight.w800),
              ),
              ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var sObj = serviceList[index] as Map? ?? {};

                    return Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            sObj["service_name"] as String? ?? "",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        CupertinoSwitch(
                            value: serviceOnIndex.contains(sObj["service_id"]),
                            onChanged: (isTrue) {
                              if (isTrue) {
                                serviceOnIndex.add(sObj["service_id"]);
                              } else {
                                serviceOnIndex.remove(sObj["service_id"]);
                              }

                              setState(() {});
                            })
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                  itemCount: serviceList.length),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                onPressed: btnUpdateAction,
                title: "UPDATE",
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Button Action
  void btnUpdateAction() {
    if (txtName.text.isEmpty) {
      mdShowAlert("Error", "Please enter name", () {});
      return;
    }

    if (!txtEmail.text.isEmail) {
      mdShowAlert("Error", "Please enter email address", () {});
      return;
    }

    if (txtMobile.text.isEmpty) {
      mdShowAlert("Error", "Please enter mobile number", () {});
      return;
    }

    if (selectZone == null) {
      mdShowAlert("Error", "Please select zone", () {});
      return;
    }

    endEditing();

    serviceUpdateProfile({
      "name": txtName.text,
      "email": txtEmail.text,
      "mobile": txtMobile.text,
      "gender": isMale ? "m" : "f",
      "mobile_code": countryCode.dialCode,
      "zone_id": "${ selectZone?["zone_id"] }",
      "select_service_id": serviceOnIndex.join(","),
    });
  }

  //ServiceCall
  void getServiceZoneList() {
    ServiceCall.post(
      {},
      SVKey.svServiceAndZoneList,
      isTokenApi: true,
      withSuccess: (responseObj) async {
        if ((responseObj[KKey.status] as String? ?? "") == "1") {
          var payloadObj = responseObj[KKey.payload] as Map? ?? {};

          zoneList = payloadObj["zone_list"] as List? ?? [];
          serviceList = payloadObj["service_list"] as List? ?? [];

          zoneList.forEach((zObj) {
            if(zObj["zone_id"] ==  ServiceCall.userObj["zone_id"] ) {
              selectZone = zObj;
            }
          });

          if (mounted) {
            setState(() {});
          }
        } else {
          mdShowAlert("Error", responseObj[KKey.message] ?? MSG.fail, () {});
        }
      },
      failure: (err) async {
        mdShowAlert("Error", err.toString(), () {});
      },
    );
  }

  void serviceUpdateProfile(Map<String, dynamic> parameter) {
    Globs.showHUD();
    ServiceCall.post(
      parameter,
      SVKey.svProfileUpdate,
      isTokenApi: true,
      withSuccess: (responseObj) async {
        Globs.hideHUD();
        if ((responseObj[KKey.status] as String? ?? "") == "1") {
          ServiceCall.userObj = responseObj[KKey.payload] as Map? ?? {};
          ServiceCall.userType = ServiceCall.userObj["user_type"] as int? ?? 1;

          Globs.udSet(ServiceCall.userObj, Globs.userPayload);
          Globs.udBoolSet(true, Globs.userLogin);

          mdShowAlert("", responseObj[KKey.message] ?? MSG.success, () {});

          if (mounted) {
            setState(() {});
          }
        } else {
          mdShowAlert("Error", responseObj[KKey.message] ?? MSG.fail, () {});
        }
      },
      failure: (err) async {
         Globs.hideHUD();
        mdShowAlert("Error", err.toString(), () {});
      },
    );
  }
}
