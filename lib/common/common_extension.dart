

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MDExtensionState on State {
    void mdShowAlert(String title, String message, VoidCallback onPressed, {
      String buttonTitle = "Ok", TextAlign mainAxisAlignment = TextAlign.center
    } ) {
      showDialog(context: context, builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
              CupertinoDialogAction(child: Text(buttonTitle), isDefaultAction: true , onPressed: (){
                Navigator.pop(context);
                onPressed();
              }, )
        ],
      )  );
    }

    void endEditing(){
      FocusScope.of(context).requestFocus(FocusNode());
    }
}

extension StringExtension on String {

  bool get isEmail {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }
  

}