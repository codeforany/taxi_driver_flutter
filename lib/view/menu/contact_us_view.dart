import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtMessage = TextEditingController();

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
          "Contact Us",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: [
              LineTextField(
                title: "Name",
                hintText: "Enter Name",
                controller: txtName,
              ),
              const SizedBox(
                height: 15,
              ),
              LineTextField(
                title: "Email",
                hintText: "Enter Email Address",
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
              ),
              const SizedBox(
                height: 15,
              ),
              LineTextField(
                title: "Subject",
                hintText: "Enter Subject",
                controller: txtSubject,
              ),
              const SizedBox(
                height: 15,
              ),
              LineTextField(
                title: "Message",
                hintText: "Enter Message",
                minLines: 5,
                maxLines: 10,
                controller: txtMessage,
              ),
              const SizedBox(
                height: 35,
              ),
              RoundButton(
                  title: "Submit",
                  onPressed: () {
                    actionSubmit();
                  })
            ],
          ),
        ),
      ),
    );
  }
  //TODO: Action

  void actionSubmit() {
    if (txtName.text.isEmpty) {
      mdShowAlert("Error", "Please enter number", () {});
      return;
    }

    if (!txtEmail.text.isEmail) {
      mdShowAlert("Error", "Please enter valid email address", () {});
      return;
    }

    if (txtSubject.text.isEmpty) {
      mdShowAlert("Error", "Please enter subject", () {});
      return;
    }

    if (txtMessage.text.isEmpty) {
      mdShowAlert("Error", "Please enter message", () {});
      return;
    }

    endEditing();

    apiContactSubmit({
      "name": txtName.text,
      "email": txtEmail.text,
      "subject": txtSubject.text,
      "message": txtMessage.text
    });
  }

  //TODO: ApiCalling

  void apiContactSubmit(Map<String, String> parameter) {
    Globs.showHUD();
    ServiceCall.post(parameter, SVKey.svContactUs,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        mdShowAlert(
            Globs.appName, responseObj[KKey.message] as String? ?? MSG.success,
            () {
          context.pop();
        });
      } else {
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }
}
