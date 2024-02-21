import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/icon_title_cell.dart';
import 'package:taxi_driver/common_widget/menu_row.dart';
import 'package:taxi_driver/view/login/sign_in_view.dart';
import 'package:taxi_driver/view/login/welcome_view.dart';
import 'package:taxi_driver/view/menu/earning_view.dart';
import 'package:taxi_driver/view/menu/ratings_view.dart';
import 'package:taxi_driver/view/menu/service_type_view.dart';
import 'package:taxi_driver/view/menu/settings_view.dart';
import 'package:taxi_driver/view/menu/summary_view.dart';
import 'package:taxi_driver/view/menu/wallet_view.dart';
import 'package:taxi_driver/view/user/user_my_rides_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: TColor.primaryText),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Image.asset(
                            "assets/img/close.png",
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/img/question_mark.png",
                              width: 20,
                              height: 20,
                              color: Colors.white,
                            ),
                            Text(
                              "Help",
                              style: TextStyle(
                                color: TColor.primaryTextW,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconTitleCell(
                            title: "Earings",
                            icon: "assets/img/earnings.png",
                            onPressed: () {
                              context.push(
                                const EarningView(),
                              );
                            }),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      "assets/img/u1.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                 InkWell(
                                          onTap: (){
                                            context.push(const RatingsView() );
                                          },
                                          child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/img/rate_profile.png",
                                          width: 15,
                                          height: 15,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                         Text(
                                            "4.89",
                                            style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 13,
                                            ),
                                          ),
                                        
                                      ],
                                    ),
                                  ),),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "James Smith",
                                style: TextStyle(
                                  color: TColor.primaryTextW,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        IconTitleCell(
                            title: "Wallet",
                            icon: "assets/img/wallet.png",
                            onPressed: () {

                              context.push(const WalletView());

                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.push(const ServiceTypeView());
            },
            child: Container(
              color: TColor.lightWhite.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/service.png",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Switch Service Type",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Change your service type",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    "assets/img/next.png",
                    width: 25,
                    height: 25,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuRow(
                      title: "Home",
                      icon: "assets/img/home.png",
                      onPressed: () {}),
                  MenuRow(
                      title: "My Rides",
                      icon: "assets/img/summary.png",
                      onPressed: () {
                        if(ServiceCall.userType == 1) {
                          context.push(const UserMyRidesView());
                        }else{

                        }
                        
                      }),
                  MenuRow(
                      title: "Summary",
                      icon: "assets/img/summary.png",
                      onPressed: () {
                        context.push(const SummaryView());
                      }),
                  MenuRow(
                      title: "My Subscription",
                      icon: "assets/img/my_subscription.png",
                      onPressed: () {}),
                  MenuRow(
                      title: "Notifications",
                      icon: "assets/img/notification.png",
                      onPressed: () {}),
                  MenuRow(
                      title: "Settings",
                      icon: "assets/img/setting.png",
                      onPressed: () {
                        context.push(const SettingsView());
                      }),
                  MenuRow(
                      title: "Logout",
                      icon: "assets/img/logout.png",
                      onPressed: () {

                        Globs.udBoolSet(false, Globs.userLogin);
                        Globs.udSet({}, Globs.userPayload);

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeView() ) , (route) => false);

                      }),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
