import 'package:flutter/material.dart';
import 'package:flutterwebviewdemo/webview_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('baidu.com'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WebviewPage(url: 'https://baidu.com');
                }));
              },
            ),
          ],
        ),
      ),
    );
  }

}