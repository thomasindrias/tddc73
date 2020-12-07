# Getting started
**Author: Thomas Indrias**

Welcome! Feel like getting started with flutter? Great!

In this following tutorial you will learn how to create a simple app like this:

First Page         |  Second Page
:-------------------------:|:-------------------------:
![First page](https://i.imgur.com/v1BIZQ3.png)  |  ![Second page](https://i.imgur.com/sp0L44z.png)

This tutorial will cover how to use these widgets:
 - ***PageView***
 - ***Text***
 - ***FlatButton***
 - ***Column***
 - ***Row***
 - ***Container***
 - ***ListView***

## Create the app
Before creating a flutter app, make sure flutter is installed. Follow [this](https://flutter.dev/docs/get-started/install) guide for installation.

Now let's create a our app
```
flutter create getting_started
```

Then start up the app by
```
cd getting_started && flutter run
```

In `lib/main.dart`, is where implementation will be done and should look something like this at the beginning

```dart
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
```
This is a template that is provided by flutter at creation of the app. However, we will remove the `floationActionButton` to create our own buttons.

## Page View
Let's begin by creating a page view. A page view widget allows for multiple pages to be used in an app. What's handy with the Page View in flutter is that it has many customizable option such as custom transitions at page change, however that is out of scope of this tutorial.

First we insert a widget `PageView` inside the widget `body` of AppBar

```dart
PageView(
  controller: _controller,
  children: [
    firstPage(),
    secondPage(colors),
  ],
)
```

As you can see, we can insert multiple views inside the children list, however to controll what page to view, a `Page Controller` is used.

```dart
class _MyHomePageState extends State<MyHomePage> {
  ...

  PageController _controller = PageController(
    initialPage: 0,
  );

  ...

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  ...
}
```

The page controller `_controller` is initiliazed under `_MyHomePageState` and we set the inital page as the first page in our page view widget. However when dealing with multiple pages, it is recommended to dispose the controller when not in use for memory effiency.

We will take a close look on the two pages `firstPage` and `secondPage`.

## First page
Our first page contains a screen with a number and two buttons. By pressing the buttons, the number changes.

![Widget structure of firstPage](https://i.imgur.com/iUhvm0u.png)

The figure above shows an overview of the widgets in `firstPage`.

Column is used to align multiple widgets in a column. Column widget expands throughout the avaliable vertical space. Options such as `mainAxisAlignment`, `crossAxisAlignment` and more allows the items to be aligned in a specifc way. 

Note that `Row` widgets work the same way as `Column`!

```dart
Widget firstPage() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Swipe to the right! 👉',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
              child: Icon(Icons.remove, color: Colors.white),
              color: Colors.red,
              onPressed: _reduceCounter,
            ),
            FlatButton(
              child: Icon(Icons.add, color: Colors.white),
              color: Colors.blue,
              onPressed: _incrementCounter,
            )
          ],
        )
      ],
    ),
  );
}
```

In this case, the property `mainAxisAlignment` is used to align the widgets of the columns and rows to space evenly.

In this page we also have two buttons. There are many ways to implement buttons in flutter, one way is to create a `FlatButton`. FlatButton allows more customization by wrapping around widget `child`. A button also has a onPressed property that takes in a `VoidCallback` function.

In this case, we create a function for each button to change the number on the page.

```dart
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  ...

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _reduceCounter() {
    setState(() {
      _counter--;
    });
  }
  
  ...
}
```
## Second Page
Thanks to our `PageView`, we can now scroll to the second page!

This page contains a `ListView` widget. `Listview` and `Column` works in a similar manner. The difference is that `ListView` is used when the widgets in the view exceeds the viewport size. ListView then allows the user to scroll instead. So if you want the option of scrolling through items, use `ListView`.

For this example, we'll create a List of colors under `MyHomePageState`

```dart
class _MyHomePageState extends State<MyHomePage> {
  ...

  List<Color> colors = [Colors.red, Colors.green, Colors.blue];

  ...
}
```

Luckily `ListView` allows us to build a list of items with a few lines of code by writing

```dart
Widget secondPage(List<Color> colors) {
    return ListView.builder(
        itemCount: colors.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: colors[index],
            ),
          );
        });
  }
```

where `itemCount` is how many items we want to add to our list, and `itemBuilder` takes in a function that is iterated as many times as `itemCount` and returns a widget for every iteration.

This page should then show three colored and scrollable containers!

## Final code
The final code should then look something like this

```dart
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter: Getting Started'),
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

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  PageController _controller = PageController(
    initialPage: 0,
  );

  List<Color> colors = [Colors.red, Colors.green, Colors.blue];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _reduceCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: PageView(
          controller: _controller,
          children: [
            firstPage(),
            secondPage(colors),
          ],
        ));
  }

  Widget firstPage() {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Swipe to the right! 👉',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: Icon(Icons.remove, color: Colors.white),
                color: Colors.red,
                onPressed: _reduceCounter,
              ),
              FlatButton(
                child: Icon(Icons.add, color: Colors.white),
                color: Colors.blue,
                onPressed: _incrementCounter,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget secondPage(List<Color> colors) {
    return ListView.builder(
        itemCount: colors.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: colors[index],
            ),
          );
        });
  }
}
```

## Final Words
**Good job!** 👏 

I hope you enjoyed this tutorial, and feel free to clone this and try out yourself! 