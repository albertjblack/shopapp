import 'dart:math';

import 'package:flutter/material.dart';

import './../widgets/auth_card.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 39, 110, 241).withOpacity(0.9),
                      const Color.fromARGB(255, 77, 0, 193).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 1])),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 50.0),
                        transform: Matrix4.rotationZ(0.0 * pi / 180.0)
                          ..translate(0.0, 0.0),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(0, 2))
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueAccent),
                        // child of container
                        child: const Text(
                          "My Shop",
                          style: TextStyle(
                              fontSize: 50,
                              fontFamily: "Lato",
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Flexible(
                        child: const AuthCard(),
                        flex: deviceSize.width > 600 ? 2 : 1)
                  ]),
            ),
          ),
          // Center(
          //   child: SizedBox(
          //       width: 136,
          //       // child: Image.asset("assets/images/logo/**_n_white.png")),
          // ),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: const [
            // Center(child: Text("from", style: TextStyle(color: Colors.white))),
            Center(
                child: Text("Technologies L.L.C.",
                    style: TextStyle(color: Colors.white, fontFamily: "Lato"))),
            SizedBox(
              height: 37,
            )
          ])
        ],
      ),
    );
  }
}
