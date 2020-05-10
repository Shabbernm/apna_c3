import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  static const routeName = '/RequestScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request To Start Services')),
      body: Column(
        children: <Widget>[
          Text(
              'We have received your request. We will start doing our service in your area as soon as possible! Thanks for requesting.'),
          RaisedButton(
            child: Text('Go to Shop Category page'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
