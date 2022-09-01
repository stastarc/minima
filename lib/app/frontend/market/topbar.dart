import 'package:flutter/material.dart';
import 'package:minima/app/backend/auth/user.dart';
import 'package:minima/app/frontend/market/pages/checkout.dart';
import 'package:minima/app/frontend/market/pages/search.dart';
import 'package:minima/app/frontend/my/widgets/profile_picture.dart';
import 'package:minima/app/models/auth/profile.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/pllogo.dart';
import 'package:minima/shared/widgets/future_builder_widget.dart';

class MarketTopBar extends StatelessWidget {
  const MarketTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 28, 18),
      child: Row(
        children: [
          const PLLogo(size: 36),
          const SizedBox(width: 4),
          const Spacer(),
          GestureDetector(
              child:
                  const Icon(Icons.search, color: Color(0xFF1A1A1A), size: 28),
              onTap: () {
                Navigator.push(context, fade(const SearchPage()));
              }),
          const SizedBox(width: 24),
          GestureDetector(
              child: const Icon(Icons.shopping_bag_outlined,
                  color: Color(0xFF1A1A1A), size: 28),
              onTap: () {
                Navigator.push(context, slideRTL(const CheckoutPage()));
              }),
          const SizedBox(width: 24),
          FutureBuilderWidget<ProfileData?>(
            future: User.instance.getInfo(),
            defaultBuilder: (user) => ProfilePicture(
              image: user?.picture,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}
