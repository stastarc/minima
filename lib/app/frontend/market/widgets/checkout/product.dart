import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/models/market/checkout.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/checkbox.dart';
import 'package:collection/collection.dart';

class CheckoutProductItem extends StatefulWidget {
  final CheckoutItem item;
  final bool checked;
  final VoidCallback? onRemove;
  final bool Function(bool value)? onCheckChange;
  final bool isFixed;

  const CheckoutProductItem({
    super.key,
    required this.item,
    this.checked = false,
    this.isFixed = false,
    this.onRemove,
    this.onCheckChange,
  });

  @override
  State<CheckoutProductItem> createState() => _CheckoutProductItemState();
}

class _CheckoutProductItemState extends State<CheckoutProductItem> {
  late bool _isChecked;

  String deliveryTime() {
    final date = DateTime.now().add(const Duration(days: 2));
    return '${deliveryDateFormat(date)} ~ ${deliveryDateFormat(date.add(const Duration(days: 1)))}';
  }

  void onCheckChanged(bool? value) {
    if (widget.onCheckChange!(value ?? false)) {
      setState(() {
        _isChecked = value ?? false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked;
  }

  Widget buildInnerProduct() {
    final totalPrice = widget.item.totalPrice;
    return Row(
      children: [
        const SizedBox(width: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 98,
            width: 98,
            child: CDN.image(
                id: widget.item.product.images.firstOrNull ?? '',
                fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${deliveryTime()}일 도착 예정',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  letterSpacing: .3,
                  color: Color(0xFF4FC083)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: Text(
                widget.item.selectedOptions.map((e) => e.name).join(', '),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF424242),
                ),
              ),
            ),
            Text(
              '${currencyFormat(totalPrice)}원',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              totalPrice > Market.instance.freeDelivery
                  ? '무료배송'
                  : '배송비 ${currencyFormat(widget.item.product.deliveryPrice)}원',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: widget.isFixed
          ? buildInnerProduct()
          : Column(children: [
              Row(
                children: [
                  PrimaryCheckbox(value: _isChecked, onChanged: onCheckChanged),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.item.product.components
                            .map((e) => '${e.item2} ${e.item1}개')
                            .join(', '),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3D3D3D)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: TextButton(
                        onPressed: widget.onRemove,
                        child:
                            const Icon(Icons.close, color: Color(0xFFACACAC))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              buildInnerProduct()
            ]),
    );
  }
}
