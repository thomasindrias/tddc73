import 'package:flutter/material.dart';
import 'package:shopping_cart/shopping_cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  generateShoppingItems() {
    List<ShoppingModel> items = new List<ShoppingModel>();
    const String imgUrl =
        "https://www.pngjoy.com/pngl/53/1199732_nike-shoe-men-s-nike-zoom-fly-flyknit.png";
    items.add(new ShoppingModel("Nike Air Max 200", imgUrl, 240.0, 1));
    items.add(
        new ShoppingModel("Excee Sneakers", imgUrl, 260.0, 1, Colors.green));
    items.add(new ShoppingModel("Air Max Motion 2", imgUrl, 290.0, 1));
    items.add(new ShoppingModel("Leather Sneakers", imgUrl, 270.0, 2));
    items.add(new ShoppingModel("Leather Sneakers", imgUrl, 270.0, 2));
    items.add(new ShoppingModel("Leather Sneakers", imgUrl, 270.0, 2));
    items.add(new ShoppingModel("Leather Sneakers", imgUrl, 270.0, 2));

    return items;
  }

  generateCost() {
    List<ExtraCostModel> costs = new List<ExtraCostModel>();
    costs.add(ExtraCostModel(40.0, "Tax"));
    costs.add(ExtraCostModel(60.0, "Shipping"));
    return costs;
  }

  List<ShoppingModel> items;
  List<ExtraCostModel> extraCost;

  @override
  void initState() {
    items = generateShoppingItems();
    extraCost = generateCost();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
            color: Colors.grey[200],
            child: ShoppingCartWidget(
              shoppingItems: items, // Send in your list of items
              locale: "sv_SE", // Currency based on localization
              extraCost: extraCost, //Send in custom total price calculator
            )));
  }
}
