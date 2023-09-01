import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:review_app/constants/color.dart';
import 'package:review_app/features/authentication/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:review_app/features/reviews/presentation/pages/home.dart';
import 'package:review_app/features/reviews/presentation/pages/landing.dart';
import 'package:review_app/features/reviews/presentation/pages/leaderboard.dart';
import 'package:review_app/features/reviews/presentation/provider/bottom_nav_bar.dart';
import 'package:review_app/routes/route_generator.dart';
import 'package:review_app/utils/methods.dart';

import 'features/authentication/presentation/bloc/signup_bloc/signup_bloc.dart';
import 'features/authentication/presentation/pages/login.dart';
import 'features/reviews/presentation/pages/liked.dart';
import 'features/reviews/presentation/pages/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: ((context) => BottomNavigationProvider()))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: ((context) => SignupBloc())),
          BlocProvider(create: ((context) => LoginBloc())),
        ], 
        child: MaterialApp(
          theme: ThemeData(primarySwatch: mainAppColor),
          debugShowCheckedModeBanner: false,
          title: 'Review Products',
          initialRoute: '/',
          onGenerateRoute: RouteGenerator().generateRoute,
        ),)
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
    _checkLogin() async {
    var isLoggedIn = await checkLoginStatus();
    if(!isLoggedIn){
      Navigator.of(context).pushReplacementNamed('login');
    } else{
      Navigator.of(context).pushReplacementNamed('landing');
    }
  }

  @override
  void initState() {
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor60,
    );
  }
}