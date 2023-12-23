import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/my_http_overrides.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/cubit/login_cubit.dart';
import 'package:taxi_driver/view/login/splash_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

SharedPreferences? prefs;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  if (Globs.udValueBool(Globs.userLogin)) {
    ServiceCall.userObj = Globs.udValue(Globs.userPayload) as Map? ?? {};
    ServiceCall.userType = ServiceCall.userObj["user_type"] as int? ?? 1;
  }

  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.white
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoginCubit())],
      child: MaterialApp(
        title: 'Taxi Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "NunitoSans",
          scaffoldBackgroundColor: TColor.bg,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
          useMaterial3: false,
        ),
        home: const SplashView(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
