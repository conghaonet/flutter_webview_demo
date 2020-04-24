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
    return IndexedStack(
      index: _stackIndex,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(this.widget.title),
          ),
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.amber,
            child: Center(child: Text('bottomNavigationBar')),
          ),
          body: Column(
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
                  setState(() {
                    _stackIndex=1;
                  });
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
              RaisedButton(
                child: Text('video youtube'),
                onPressed: () async {
                  if(_controller.isCompleted) {
                    await _controller.future.then((controller) async {
                      String currentUrl = await controller.currentUrl();
                      if(currentUrl != 'https://m.youtube.com/watch?v=vnj2i6RNo3g') {
                        controller.loadUrl('https://m.youtube.com/watch?v=vnj2i6RNo3g');
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
        ),
        GameWebView(url: 'https://flutter.dev', onClose: () {
          if(_stackIndex != 0) {
            setState(() {
              _stackIndex = 0;
            });
          }
        },),
      ],
    );
  }
}

typedef OnCloseWebView = Function();
class GameWebView extends StatefulWidget {
  final String url;
  final OnCloseWebView onClose;

  GameWebView({this.url, this.onClose, Key key}): super(key: key);

  @override
  _GameWebViewState createState() => _GameWebViewState();
}

class _GameWebViewState extends State<GameWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  Future<bool> _onBack() async {
    if(_controller.isCompleted) {
      await _controller.future.then((controller) async {
        if(await controller.canGoBack()) {
          await controller.goBack();
        } else {
          if(widget.onClose != null) {
            widget.onClose();
          }
        }
      });
    } else {
      if(widget.onClose != null) {
        widget.onClose();
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.widget.url,
        ),
        leading: BackButton(
          onPressed: () => _onBack(),
        ),
      ),
      body: Container(
        child: WillPopScope(
          onWillPop: () async {
            return _onBack();
          },
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
      ),
    );
  }
}