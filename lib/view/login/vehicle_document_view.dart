import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/document_row.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/login/subscription_plan_view.dart';

class VehicleDocumentUploadView extends StatefulWidget {
  const VehicleDocumentUploadView({super.key});

  @override
  State<VehicleDocumentUploadView> createState() =>
      _VehicleDocumentUploadViewState();
}

class _VehicleDocumentUploadViewState extends State<VehicleDocumentUploadView> {
  List documentList = [
    {
      "name": "RC Book",
      "detail": "Vehicle Registration",
      "info": "",
    },
    {
      "name": "Insurance policy",
      "detail": "A driving license is an official do...",
      "info": "",
    },
    {
      "name": "Owner certificate",
      "detail": "A passport is a travel document...",
      "info": "",
    },
    {
      "name": "PUC",
      "detail": "Incorrect document type",
      "info": "",
    }
  ];

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
          "Vehicle Document",
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
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var dObj = documentList[index] as Map? ?? {};
                    return DocumentRow(
                      dObj: dObj,
                      onPressed: () {},
                      onInfo: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                width: context.width,
                                height: context.height - 100,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 46, horizontal: 20),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 3),
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "RC Book",
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.leap into electronic typesetting, remaining essentially unchanged.\n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                          style: TextStyle(
                                            color: TColor.secondaryText,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: Text(
                                            "OKAY",
                                            style: TextStyle(
                                                color: TColor.primary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      onUpload: () {},
                      onAction: () {},
                    );
                  },
                  itemCount: documentList.length),
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
                  context.push(const SubscriptionPlanView());
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
