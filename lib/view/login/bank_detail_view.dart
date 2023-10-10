import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/login/document_upload_view.dart';

class BankDetailView extends StatefulWidget {
  const BankDetailView({super.key});

  @override
  State<BankDetailView> createState() => _BankDetailViewState();
}

class _BankDetailViewState extends State<BankDetailView> {
  
  TextEditingController txtBankName = TextEditingController();
  TextEditingController txtAccountHolderName = TextEditingController();
  TextEditingController txtAccountNumber = TextEditingController();
  TextEditingController txtSwiftCode = TextEditingController();


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
                "Bank Details",
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
                title: "Bank Name",
                hintText: "Ex: SBI",
                controller: txtBankName,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Account Holder name",
                hintText: "Ex: A Patel",
                controller: txtAccountHolderName,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Account Number",
                hintText: "Ex: 12345678945245",
                controller: txtAccountNumber,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Swift/IFSC Code",
                hintText: "YT123C",
                controller: txtSwiftCode,
                
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By continuing, I confirm that i have read & agree to the",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Terms & conditions",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    " and ",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "Privacy policy",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RoundButton(
                onPressed: () {
                  context.push(const DocumentUploadView(title: "Personal Document" ),);
                },
                title: "NEXT",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
