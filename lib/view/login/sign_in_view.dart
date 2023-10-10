import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  FlCountryCodePicker countryCodePicker = const FlCountryCodePicker();
  TextEditingController txtMobile = TextEditingController();
  late CountryCode countryCode;
  TextEditingController txtPassword = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign In",
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 25,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 30,
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
                        style:
                            TextStyle(color: TColor.primaryText, fontSize: 16),
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
              title: "Password",
              hintText: "******",
              controller: txtPassword,
              obscureText: true,
              right: IconButton(onPressed: (){}, icon: Image.asset("assets/img/password_show.png", width: 25, height: 25, ) ),
            ),
            const SizedBox(
              height: 15,
            ),
            RoundButton(
              onPressed: () {},
              title: "SIGN IN",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "FORGOT PASSWORD",
                    style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
