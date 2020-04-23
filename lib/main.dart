import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwebviewdemo/webview_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  int _stackIndex = 0;
  String _currentUrl;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.amber,
        child: Center(child: Text('bottomNavigationBar')),
      ),
      body: IndexedStack(
        index: _stackIndex,
        children: <Widget>[
          Column(
            children: <Widget>[
              RaisedButton(
                child: Text('baidu.com'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WebviewPage(url: 'https://baidu.com');
                  }));
                },
              ),
              RaisedButton(
                child: Text('flutter.dev'),
                onPressed: () async {
                  if(_controller.isCompleted) {
                    await _controller.future.then((controller) async {
                      String currentUrl = await controller.currentUrl();
                      if(currentUrl != 'https://flutter.dev') {
                        controller.loadUrl('https://flutter.dev');
                      }
                    });
                    setState(() {
                      _stackIndex=1;
                    });
                  }
                },
              ),
              RaisedButton(
                child: Text('youtube.com'),
                onPressed: () async {
                  if(_controller.isCompleted) {
                    await _controller.future.then((controller) async {
                      String currentUrl = await controller.currentUrl();
                      if(currentUrl != 'https://youtube.com') {
                        controller.loadUrl('https://youtube.com');
                      }
                    });
                    setState(() {
                      _stackIndex=1;
                    });
                  }
                },
              ),
            ],
          ),
          WillPopScope(
            onWillPop: () async {
              if(_stackIndex == 1) {
                _stackIndex = 0;
                setState(() {

                });
                return false;
              }
              else return true;
            },
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },

            ),
          ),
        ],
      ),
    );
  }
}