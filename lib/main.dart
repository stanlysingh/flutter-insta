import 'package:flutter/material.dart';

import 'Module/Login/login_view.dart';

void main() =>runApp(
    new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
            primarySwatch: Colors.blue
        ),
        home: new LoginPage()
    )
);
