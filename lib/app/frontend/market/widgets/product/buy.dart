import 'package:flutter/material.dart';
import 'package:minima/app/backend/market/checkout.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/pages/checkout.dart';
import 'package:minima/app/models/market/checkout.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/checkbox.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class BuySheet extends StatefulWidget {
  final ProductDetail product;

  const BuySheet({
    super.key,
    required this.product,
  });

  @override
  State<BuySheet> createState() => _BuySheetState();
}

class _BuySheetState extends State<BuySheet> {
  late BuildContext myContext;
  late List<bool> buyOptions;
  late List<ProductOption> options;
  late int _totalPrice;

  @override
  void initState() {
    super.initState();
    options = widget.product.options;
    buyOptions = [
      for (var i = 0; i < options.length; i++) options[i].important
    ];
  }

  bool onOptionChange(int index, bool value) {
    final option = options[index];
    if (option.important && !value) {
      Toast.show('${option.name}은(는) 필수 옵션입니다.',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return false;
    }
    buyOptions[index] = value;
    return true;
  }

  void onOptionChanged(bool _) {
    setState(() {});
  }

  int getTotalPrice() {
    return _totalPrice =
        options.mapIndexed((i, e) => buyOptions[i] ? e.price : 0).sum;
  }

  void onBuy(bool now) async {
    if (!buyOptions.any((e) => e == true)) {
      Toast.show('옵션을 선택해주세요.',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }

    await MarketCheckout.instance.update((cache) {
      final product = widget.product;
      cache.items.add(CheckoutItem(
        product: product,
        options: buyOptions,
      ));
      return true;
    });

    if (now) {
      setState(() {
        Navigator.pop(myContext);
        Navigator.push(myContext, slideRTL(const CheckoutPage()));
      });
    } else {
      Toast.show('장바구니에 추가되었습니다.',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      setState(() {
        Navigator.pop(myContext);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    ToastContext().init(context);
    return Column(
      children: [
        const Text(
          '옵션 선택하기',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
        ),
        ...widget.product.options
            .mapIndexed((i, option) => BuyOptionItem(
                  option: option,
                  onChange: (value) => onOptionChange(i, value),
                  onChanged: onOptionChanged,
                ))
            .toList(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              '총 ${currencyFormat(getTotalPrice())}원',
              style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF54CE87),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _totalPrice > Market.instance.freeDelivery
                  ? '무료배송 (${currencyFormat(Market.instance.freeDelivery)}원 이상 주문시)'
                  : '배송비 ${currencyFormat(widget.product.deliveryPrice)}원',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8E8E8E),
                fontWeight: FontWeight.w500,
              ),
            )
          ]),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.black12,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrimaryButton(
              grey: true,
              onPressed: () {
                onBuy(false);
              },
              padding: const EdgeInsets.fromLTRB(52, 10, 52, 10),
              child: const Text('장바구니', style: TextStyle(fontSize: 16)),
            ),
            PrimaryButton(
              onPressed: () {
                onBuy(true);
              },
              padding: const EdgeInsets.fromLTRB(52, 10, 52, 10),
              child: const Text('즉시 결제', style: TextStyle(fontSize: 16)),
            ),
          ],
        )
      ],
    );
  }
}

class BuyOptionItem extends StatefulWidget {
  final ProductOption option;
  final bool Function(bool) onChange;
  final ValueChanged<bool>? onChanged;

  const BuyOptionItem({
    super.key,
    required this.option,
    required this.onChange,
    this.onChanged,
  });

  @override
  State<BuyOptionItem> createState() => _BuyOptionItemState();
}

class _BuyOptionItemState extends State<BuyOptionItem> {
  bool _isSelected = true;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.option.important;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          color: const Color(0xFFF6F6F6),
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Row(
            children: [
              PrimaryCheckbox(
                  value: _isSelected,
                  onChanged: (e) {
                    if (widget.onChange(e ?? false)) {
                      setState(() {
                        _isSelected = e ?? false;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(e ?? false);
                      }
                    }
                  }),
              Text(
                widget.option.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${currencyFormat(widget.option.price)}원',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.black12,
        ),
      ],
    );
  }
}
