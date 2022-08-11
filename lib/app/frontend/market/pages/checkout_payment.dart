import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minima/app/backend/market/checkout.dart';
import 'package:minima/app/frontend/market/widgets/checkout/menu.dart';
import 'package:minima/app/frontend/market/widgets/checkout/product.dart';
import 'package:minima/app/models/market/checkout.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:toast/toast.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final CheckoutDeliveryAddress address;
  final String method;
  final List<CheckoutItem> items;

  const CheckoutPaymentPage({
    super.key,
    required this.address,
    required this.method,
    required this.items,
  });

  @override
  State createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  MarketCheckout marketCheckout = MarketCheckout.instance;
  bool _isInPayment = true;
  dynamic checkout;
  late Future<void> initailized;
  late BuildContext myContext;

  Future<void> initailize() async {
    try {
      checkout = await marketCheckout.get();
      await Future.delayed(const Duration(seconds: 4));
      await onSuccess();
    } catch (e) {
      checkout = BackendError.fromException(e);
    }
    setState(() {});
  }

  void retry() {
    initailized = initailize();
  }

  @override
  void initState() {
    super.initState();
    initailized = initailize();
  }

  Future<void> onSuccess() async {
    final cache = checkout as CheckoutCache;
    for (var item in widget.items) {
      cache.items.remove(item);
    }
    await marketCheckout.save();

    setState(() {
      _isInPayment = false;
    });
  }

  void onConfirm() {
    Navigator.pop(myContext);
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    return PageWidget(
        title: '결제',
        hideClose: true,
        child: Column(
          children: [
            const SizedBox(height: 32),
            SizedBox(
                width: 72,
                height: 72,
                child: _isInPayment
                    ? LoadingAnimationWidget.bouncingBall(
                        color: const Color(0xFF52DA98), size: 72)
                    : SvgPicture.asset(
                        'assets/images/icons/checkout_payment.svg')),
            const SizedBox(height: 16),
            Text(_isInPayment ? '결제를 진행하고 있습니다.' : '결제가 완료되었습니다.',
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(
              height: 64,
              child: _isInPayment
                  ? null
                  : const Text('주문이 접수되었습니다.\nMy > 주문내역에서 확인하세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D3D3D))),
            ),
            const SizedBox(height: 12),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            WidthMenuItem(
              color: const Color(0xFFFAFAFA),
              icon: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF3D3D3D),
              ),
              onPressed: () {},
              child: Text('${widget.address.address} ${widget.address.detail}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3D3D))),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            WidthMenuItem(
              color: const Color(0xFFFAFAFA),
              icon: const Icon(
                Icons.credit_card_outlined,
                color: Color(0xFF3D3D3D),
              ),
              onPressed: () {},
              child: Text(widget.method,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3D3D))),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            Expanded(
                child: ListView(
              children: [
                for (final item in widget.items)
                  CheckoutProductItem(
                    item: item,
                    isFixed: true,
                  ),
              ],
            )),
            if (!_isInPayment)
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                  child: PrimaryButton(
                      width: double.infinity,
                      onPressed: onConfirm,
                      child: const Padding(
                        padding: EdgeInsets.all(3),
                        child: Text('확인',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ))),

            //   if (_isInPayment)
            //  ...[
            // ],
            // else ...[

            // ]
          ],
        ));
  }

  @override
  void dispose() {
    // if (_isInPayment) {
    //   Toast.show('결제를 취소했어요.',
    //       duration: Toast.lengthLong, gravity: Toast.bottom);
    // }
    super.dispose();
  }
}
