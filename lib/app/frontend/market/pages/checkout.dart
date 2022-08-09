import 'package:flutter/material.dart';
import 'package:minima/shared/widgets/page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State createState() => _CheckoutPagePageState();
}

class _CheckoutPagePageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return const PageWidget(title: '장바구니', child: Text('장바구니'));
  }
}
