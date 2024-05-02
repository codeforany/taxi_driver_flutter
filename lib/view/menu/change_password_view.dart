import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  TextEditingController txtCurrentPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool showCurrentPassword = true;
  bool showNewPassword = true;
  bool showConfirmPassword = true;

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
          "Change Password",
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
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            children: [
              LineTextField(
                title: "Password",
                hintText: "******",
                controller: txtCurrentPassword,
                obscureText: showCurrentPassword,
                right: IconButton(
                    onPressed: () {
                      setState(() {
                        showCurrentPassword = !showCurrentPassword;
                      });
                    },
                    icon: Image.asset(
                      "assets/img/password_show.png",
                      width: 25,
                      height: 25,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              LineTextField(
                title: "New Password",
                hintText: "******",
                controller: txtNewPassword,
                obscureText: showNewPassword,
                right: IconButton(
                    onPressed: () {
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                    icon: Image.asset(
                      "assets/img/password_show.png",
                      width: 25,
                      height: 25,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              LineTextField(
                title: "Confirm Password",
                hintText: "******",
                controller: txtConfirmPassword,
                obscureText: showConfirmPassword,
                right: IconButton(
                    onPressed: () {
                      setState(() {
                        showConfirmPassword = !showConfirmPassword;
                      });
                    },
                    icon: Image.asset(
                      "assets/img/password_show.png",
                      width: 25,
                      height: 25,
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              RoundButton(
                  title: "Change",
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
    if (txtCurrentPassword.text.isEmpty) {
      mdShowAlert("error", "Please enter current password", () {});
      return;
    }
    if (txtNewPassword.text.isEmpty) {
      mdShowAlert("error", "Please enter new password", () {});
      return;
    }

    if (txtNewPassword.text != txtConfirmPassword.text) {
      mdShowAlert("error", "Password not match", () {});
      return;
    }

    endEditing();

    apiChangePassword({
      "old_password": txtCurrentPassword.text,
      "new_password": txtNewPassword.text
    });
  }

  //TODO: ApiCalling

  void apiChangePassword(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svChangePassword, isTokenApi: true,
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
            "error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("error", err.toString(), () {});
    });
  }
}
