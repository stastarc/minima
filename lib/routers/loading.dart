import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minima/app/backend/auth/auth.dart';
import 'package:minima/shared/pllogo.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(), () async {
      if (await Auth.instance.verifyToken()) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: PLLogo(size: 120)),
    );
  }
}
