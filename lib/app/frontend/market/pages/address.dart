import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:minima/app/backend/market/checkout.dart';
import 'package:minima/app/models/market/checkout.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:toast/toast.dart';

class DeliveryAddressPage extends StatefulWidget {
  final void Function(CheckoutDeliveryAddress) onAddressChanged;
  const DeliveryAddressPage({
    super.key,
    required this.onAddressChanged,
  });
  @override
  State createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController detailedAddressController = TextEditingController();
  String? postCode, address, detailedAddress;

  String get addressText => '$address ($postCode)';

  void onCallback(Kpostal res) {
    postCode = res.postCode;
    address = res.address;
    addressController.text = addressText;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    MarketCheckout.instance.get().then((cache) {
      if (cache.address != null) {
        postCode = cache.address!.postCode;
        address = cache.address!.address;
        addressController.text = addressText;
        detailedAddressController.text =
            detailedAddress = cache.address!.detail;
        setState(() {});
      }
    });
  }

  void onComplete() async {
    if (postCode == null) {
      Toast.show('주소를 입력해주세요.',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }

    final addr = CheckoutDeliveryAddress(
      postCode: postCode!,
      address: address!,
      detail: detailedAddressController.text.trim(),
    );

    MarketCheckout.instance.update((cache) {
      cache.address = addr;
      return true;
    });

    widget.onAddressChanged(addr);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return PageWidget(
      title: '주소 선택',
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(children: [
                  PrimaryTextField(
                    controller: addressController,
                    title: '주소',
                    hint: '주소를 입력해주세요.',
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          slideRTL(KpostalView(
                            callback: onCallback,
                          )));
                    },
                  ),
                  const SizedBox(height: 18),
                  PrimaryTextField(
                    controller: detailedAddressController,
                    maxLength: 100,
                    title: '상세주소',
                    hint: '동·호수 등 상세주소를 입력해주세요.',
                  )
                ]),
              ),
              const Spacer(),
              PrimaryButton(
                  width: double.infinity,
                  onPressed: onComplete,
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('완료',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )),
            ],
          )),
    );
  }
}
