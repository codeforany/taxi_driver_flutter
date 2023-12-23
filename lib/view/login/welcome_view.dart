import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/login/mobile_number_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/welcome_bg.png",
            width: context.width,
            height: context.height,
            fit: BoxFit.cover,
          ),
          Container(
            width: context.width,
            height: context.height,
            color: Colors.black.withOpacity(0.8),
          ),
          SafeArea(
            child: Column(
              children: [
                Image.asset(
                  "assets/img/app_logo.png",
                  width: context.width * 0.25,
                ),
                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RoundButton(title: "Get Start", onPressed: (){
                    context.push( const MobileNumberView() );
                  }, ),
                ),


                // TextButton(
                //   onPressed: () {
                //      context.push(const SignUpView());
                //   },
                //   child: Text(
                //     "SIGN UP",
                //     style: TextStyle(
                //       color: TColor.primaryTextW,
                //       fontSize: 16,
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
