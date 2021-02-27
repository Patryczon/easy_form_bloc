import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/debug_bloc_observer.dart';
import 'package:flutter_app/multi_page_form.dart';

import 'single_step_form.dart';

void main() {
  Bloc.observer = DebugBlocObserver();
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
      home: Scaffold(backgroundColor: Colors.white, body: MainScreen()),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SingleStepForm())),
                child: Text("Single step form",
                    style: TextStyle(color: Colors.white))),
            FlatButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MultiPageForm())),
                child: Text("Multi steps form",
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      );
}
