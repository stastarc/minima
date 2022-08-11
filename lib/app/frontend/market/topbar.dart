import 'package:flutter/material.dart';
import 'package:minima/app/frontend/market/pages/checkout.dart';
import 'package:minima/app/frontend/market/pages/search.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/pllogo.dart';
import 'package:minima/shared/widgets/button.dart';

class MarketTopBar extends StatelessWidget {
  const MarketTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 18),
      child: Row(
        children: [
          const PLLogo(size: 38),
          const SizedBox(width: 8),
          const Text('MARKET',
              style: TextStyle(
                  color: Color(0xFF4CC760),
                  fontFamily: 'ibm',
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const Spacer(),
          PrimaryButton(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child:
                  const Icon(Icons.search, color: Color(0xFF1A1A1A), size: 28),
              onPressed: () {
                Navigator.push(context, fade(const SearchPage()));
              }),
          PrimaryButton(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: Color(0xFF1A1A1A), size: 28),
              onPressed: () {
                Navigator.push(context, slideRTL(const CheckoutPage()));
              }),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color.fromARGB(255, 255, 166, 166),
            backgroundImage: AssetImage('assets/images/icons/profile.png'),
          ),
        ],
      ),
    );
  }
}
