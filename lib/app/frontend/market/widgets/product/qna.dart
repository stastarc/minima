import 'package:flutter/material.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/widgets/product/qna_item.dart';
import 'package:minima/app/frontend/market/widgets/product/qna_writer.dart';
import 'package:minima/app/models/market/product.dart';
import 'package:minima/app/models/market/qna.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:toast/toast.dart';

class QnAView extends StatefulWidget {
  final int productId;
  final ProductDetail? product;
  List<ProductQnA>? qnas;

  QnAView({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  State<QnAView> createState() => _QnAViewState();
}

class _QnAViewState extends State<QnAView> {
  dynamic qnas;
  late Future<void> initailized;

  Future<void> initailize() async {
    try {
      qnas = await Market.instance.getProductQnAs(widget.productId);
      widget.qnas = qnas;
    } catch (e) {
      qnas = BackendError.fromException(e);
    }
    setState(() {});
  }

  void retry() {
    qnas = null;
    initailized = initailize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (widget.qnas == null) {
      initailized = initailize();
    } else {
      qnas = widget.qnas;
      initailized = Future.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              '상품문의',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black38,
            ),
            FutureBuilder(
                future: initailized,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (qnas == null || qnas is BackendError) {
                      return RetryButton(
                          onPressed: retry,
                          error: qnas ?? BackendError.unknown());
                    } else {
                      final qnas = this.qnas as List<ProductQnA>;

                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (final qna in qnas)
                              QnAItem(
                                qna: qna,
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PrimaryButton(
                                    grey: true,
                                    child: const Text('문의 작성하기'),
                                    onPressed: () {
                                      showSheet(context,
                                          child: QnAWriterSheet(
                                            title:
                                                (widget.product?.name) ?? '상품',
                                            productId: widget.productId,
                                            onSubmit: retry,
                                          ));
                                    }),
                                const SizedBox(width: 16),
                              ],
                            )
                          ]);
                    }
                  } else {
                    return Skeleton(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 2; i++) const QnAItemSkeleton(),
                      ],
                    ));
                  }
                })
          ],
        ));
  }
}
