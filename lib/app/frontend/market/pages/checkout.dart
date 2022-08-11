import 'package:flutter/material.dart';
import 'package:minima/app/backend/market/checkout.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/pages/address.dart';
import 'package:minima/app/frontend/market/pages/checkout_payment.dart';
import 'package:minima/app/frontend/market/widgets/checkout/menu.dart';
import 'package:minima/app/frontend/market/widgets/checkout/product.dart';
import 'package:minima/app/models/market/checkout.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State createState() => _CheckoutPagePageState();
}

class _CheckoutPagePageState extends State<CheckoutPage> {
  MarketCheckout marketCheckout = MarketCheckout.instance;
  List<CheckoutItem> _items = [];
  dynamic checkout;
  late Future<void> initailized;
  late BuildContext myContext;

  Future<void> initailize() async {
    try {
      checkout = await marketCheckout.get();
      final cache = checkout as CheckoutCache;
      _items = [...cache.items];
    } catch (e) {
      checkout = BackendError.fromException(e);
    }
    setState(() {});
  }

  void retry() {
    initailized = initailize();
  }

  void onItemRemove(int index) async {
    if (checkout is! CheckoutCache) return;
    final cache = checkout as CheckoutCache;
    final item = cache.items[index];
    cache.items.removeAt(index);
    _items.remove(item);
    await marketCheckout.save();
    setState(() {});
  }

  bool onItemCheckChange(int index, bool value) {
    final cache = checkout as CheckoutCache;
    final item = cache.items[index];
    if (value) {
      _items.add(item);
    } else {
      _items.remove(item);
    }
    setState(() {});
    return true;
  }

  void onDeliveryAddressChange() {
    Navigator.push(
        myContext,
        slideRTL(DeliveryAddressPage(
          onAddressChanged: ((e) => setState(() {})),
        )));
  }

  int get totalPrice {
    if (checkout is! CheckoutCache) return 0;
    final cache = checkout as CheckoutCache;
    return cache.items.foldIndexed(0,
        (i, sum, item) => sum + (_items.contains(item) ? item.totalPrice : 0));
  }

  int get deliveryPrice {
    if (checkout is! CheckoutCache) return 0;
    final cache = checkout as CheckoutCache;
    return cache.items.foldIndexed(
        0,
        (i, sum, item) =>
            sum +
            (_items.contains(item)
                ? (item.totalPrice > Market.instance.freeDelivery
                    ? 0
                    : item.product.deliveryPrice)
                : 0));
  }

  String get deliveryAddress {
    final cache = checkout as CheckoutCache;
    final address = cache.address;
    if (address == null) return '주소를 입력해주세요';
    return '${address.address} ${address.detail}';
  }

  @override
  void initState() {
    super.initState();
    initailized = initailize();
  }

  void onCheckout() async {
    if (_items.isEmpty) {
      Toast.show('상품을 선택해주세요',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }

    final cache = checkout as CheckoutCache;

    Navigator.pop(myContext);
    Navigator.push(
        myContext,
        slideRTL(CheckoutPaymentPage(
          address: cache.address!,
          items: _items,
          method: 'KB국민카드 (3070)',
        )));
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    myContext = context;
    return PageWidget(
        title: '장바구니',
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
            top: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          )),
          child: FutureBuilder(
            future: initailized,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (checkout == null || checkout is BackendError) {
                  return RetryButton(
                    text: '장바구니를 가져올 수 없습니다.',
                    error: checkout ?? BackendError.unknown(),
                    onPressed: () {
                      initailized = initailize();
                      setState(() {});
                    },
                  );
                } else {
                  final checkout = this.checkout as CheckoutCache;
                  final deliveryPrice = this.deliveryPrice;
                  final totalPrice = this.totalPrice;

                  return Column(children: [
                    Expanded(
                        child: ListView(
                            children: checkout.items
                                .mapIndexed(
                                  (i, item) => CheckoutProductItem(
                                    item: item,
                                    checked: _items.any((e) => e == item),
                                    onRemove: () => onItemRemove(i),
                                    onCheckChange: (v) =>
                                        onItemCheckChange(i, v),
                                  ),
                                )
                                .toList())),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(children: [
                        WidthMenuItem(
                            icon: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF3D3D3D),
                            ),
                            onPressed: onDeliveryAddressChange,
                            forward: true,
                            child: Text(deliveryAddress,
                                style: const TextStyle(
                                    color: Color(0xFF3D3D3D),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))),
                        const Divider(
                          color: Colors.black26,
                          height: 1,
                        ),
                        WidthMenuItem(
                          icon: const Icon(
                            Icons.credit_card_outlined,
                            color: Color(0xFF3D3D3D),
                          ),
                          onPressed: () {},
                          forward: true,
                          child: const Text('KB국민카드 (3070)',
                              style: TextStyle(
                                  color: Color(0xFF3D3D3D),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const Divider(
                          color: Colors.black26,
                          height: 1,
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('총 ${currencyFormat(totalPrice)}원',
                                      style: const TextStyle(
                                          color: Color(0xFF4FC083),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '+ 배송비 ${currencyFormat(deliveryPrice)}원',
                                      style: const TextStyle(
                                          color: Color(0xFF6D6D6D),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                ])),
                        const Divider(
                          color: Colors.black26,
                          height: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                            child: PrimaryButton(
                                width: double.infinity,
                                grey: totalPrice == 0,
                                onPressed: onCheckout,
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                      '${currencyFormat(totalPrice + deliveryPrice)}원 결제하기',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                )))
                      ]),
                    )
                  ]);
                }
              }
              return const SizedBox(
                height: 100,
              );
            },
          ),
        ));
  }
}
