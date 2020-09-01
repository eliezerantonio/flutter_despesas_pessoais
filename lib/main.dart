
import 'package:despesas/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


main() => runApp(ExpensesAPP());

class ExpensesAPP extends StatefulWidget {
  const ExpensesAPP({Key key}) : super(key: key);

  @override
  _ExpensesAPPState createState() => _ExpensesAPPState();
}

class _ExpensesAPPState extends State<ExpensesAPP> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            button:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

