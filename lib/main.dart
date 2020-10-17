import 'package:flutter/material.dart';
import 'package:testproject/restaurants.dart';
import 'package:testproject/rotateImage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luncher',
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
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Luncher - Lounastaja'),
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
  bool _clicked = false;
  bool _rerolled = false;

  final int _initialRollAmount = 3;
  final int _finalRollAmount = 1;

  List<Restaurant> _restaurants;

  @override
  void initState() {
    super.initState();
    fetchRestaurants().then((List<Restaurant> result) {
      setState(() {
        _restaurants = result;
      });
    });
  }

  void _handleReset() {
    fetchRestaurants().then((List<Restaurant> result) {
      setState(() {
        _clicked = false;
        _rerolled = false;
        _restaurants = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Column initialView = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Arvo lounaspaikka',
        ),
        Padding(
            padding: EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _restaurants =
                      drawRestaurants(_restaurants, _initialRollAmount);
                  _clicked = true;
                });
              },
              tooltip: 'Increment',
              child: ImageRotate(),
            ))
      ],
    );

    var renderResult = _restaurants
        .map((restaurant) => new Text("${restaurant.name}"))
        .toList();

    Column resultsView = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ...renderResult,
        Padding(
            padding: EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _restaurants =
                      drawRestaurants(_restaurants, _finalRollAmount);
                  _rerolled = true;
                });
              },
              tooltip: 'Increment',
              child: ImageRotate(),
            ))
      ],
    );

    var bodyColumn;

    if (!_clicked) {
      bodyColumn = initialView;
    } else {
      bodyColumn = resultsView;
    }

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: bodyColumn,
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: _handleReset,
            tooltip: 'Handle reset',
            child: Icon(Icons.reset_tv),
          ),
        ));
  }
}
