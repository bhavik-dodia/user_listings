import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/users_data.dart';
import 'screens/auth_page.dart';
import 'screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UsersData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Users Listings',
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
          accentColor: Colors.blueAccent,
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            centerTitle: true,
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.blueAccent, size: 25.0),
            actionsIconTheme: IconThemeData(
              color: Colors.blueAccent,
              size: 30.0,
            ),
            textTheme: TextTheme(
              headline6: GoogleFonts.laila(
                color: Colors.blueAccent,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueAccent,
          accentColor: Colors.blueAccent,
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            centerTitle: true,
            color: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.blueAccent, size: 25.0),
            actionsIconTheme: IconThemeData(
              color: Colors.blueAccent,
              size: 30.0,
            ),
            textTheme: TextTheme(
              headline6: GoogleFonts.laila(
                color: Colors.blueAccent,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthPage(),
        routes: {
          AuthPage.routeName: (context) => AuthPage(),
          HomePage.routeName: (context) => HomePage(),
        },
      ),
    );
  }
}
