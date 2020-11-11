import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab2/models/card_information.dart';
import 'package:lab2/widgets/card.dart';
import 'package:lab2/widgets/form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  ThemeData theme = ThemeData(primarySwatch: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lab 2'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final ThemeData theme = ThemeData(primarySwatch: Colors.blue);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String cardHolder = '';
  String cardNr = '';
  String expDate = '';
  String cvv = '';
  bool isCardFlipped = false;

  int imgBg = Random().nextInt(25) + 1;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        backgroundColor: widget.theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: height * 0.4,
              backgroundColor: widget.theme.scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                background: CreditCard(
                  cardHolder: cardHolder,
                  cardNr: cardNr,
                  expDate: expDate,
                  cvv: cvv,
                  isCardFlipped: isCardFlipped,
                  backgroundImage: imgBg,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  margin: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: SingleChildScrollView(
                      child: CreditCardForm(
                        onChange: onChange,
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ));
  }

  void onChange(CardInformation cardInfo) {
    setState(() {
      cardHolder = cardInfo.cardHolder;
      cardNr = cardInfo.cardNr;
      expDate = cardInfo.expDate;
      cvv = cardInfo.cvv;
      isCardFlipped = cardInfo.isCardFlipped;
    });
  }
}
