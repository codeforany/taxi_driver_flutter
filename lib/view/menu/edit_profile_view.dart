import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  FlCountryCodePicker countryCodePicker = const FlCountryCodePicker();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  late CountryCode countryCode;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countryCode = countryCodePicker.countryCodes
        .firstWhere((element) => element.name == "India");
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
          "Edit Profile",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
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
                title: "First name",
                hintText: "Ex: Amit",
                controller: txtFirstName,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Last name",
                hintText: "Ex: Patel",
                controller: txtLastName,
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
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Email Address",
                hintText: "Ex: 123@gmail.com,",
                controller: txtEmail,
              ),
             
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                onPressed: () {
                  
                },
                title: "SAVE",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
