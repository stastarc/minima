import 'package:flutter/material.dart';
import 'package:minima/shared/pllogo.dart';

class MarketTopBar extends StatelessWidget {
  const MarketTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 18),
      child: Row(
        children: const [
          PLLogo(size: 38),
          SizedBox(width: 8),
          Text('MARKET',
              style: TextStyle(
                  color: Color(0xFF4CC760),
                  fontFamily: 'ibm',
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          Spacer(),
          Icon(Icons.search, color: Color(0xFF1A1A1A), size: 28),
          SizedBox(width: 16),
          Icon(Icons.shopping_bag_outlined, color: Color(0xFF1A1A1A), size: 28),
          SizedBox(width: 16),
          CircleAvatar(
            radius: 16,
            backgroundColor: Color.fromARGB(255, 255, 166, 166),
            backgroundImage: AssetImage('assets/images/icons/profile.png'),
          ),
        ],
      ),
    );
  }
}
