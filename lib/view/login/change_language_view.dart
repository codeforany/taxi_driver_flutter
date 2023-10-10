import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/view/login/welcome_view.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  List listArr = ["Arabic", "Chinese", "English", "Korean", "Hindi"];

  int selectChange = 2;

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
              "Choose language",
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 25,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listArr.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      setState(() {
                        selectChange = index;
                      });
                      context.push( const WelcomeView() );
                    },
                    title: Text(
                      listArr[index],
                      style: TextStyle(
                          color: index == selectChange
                              ? TColor.primary
                              : TColor.primaryText,
                          fontSize: 16),
                    ),
                    trailing: index == selectChange
                        ? Image.asset("assets/img/check_tick.png", width: 25)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
