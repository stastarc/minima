import 'package:flutter/material.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:toast/toast.dart';

class QnAWriterSheet extends StatefulWidget {
  final int productId;
  final String title;
  final VoidCallback onSubmit;

  const QnAWriterSheet({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.productId,
  });

  @override
  State<QnAWriterSheet> createState() => _QnAWriterSheetState();
}

class _QnAWriterSheetState extends State<QnAWriterSheet> {
  TextEditingController content = TextEditingController();
  bool uploading = false;

  void onSubmit() async {
    try {
      final text = content.text.trim();
      if (text.isEmpty || text.length < 5) {
        Toast.show('문의 내용을 입력해주세요. (최소 5자 이상)',
            duration: Toast.lengthLong, gravity: Toast.bottom);
        return;
      }
      setState(() {
        uploading = true;
      });
      Toast.show('문의를 올리고 있어요.',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      await Market.instance.writeQnA(widget.productId, text);
      setState(() {
        Navigator.pop(context);
        Toast.show('문의를 올렸어요.',
            duration: Toast.lengthLong, gravity: Toast.bottom);
      });
    } catch (e) {
      Toast.show('문의를 올리지 못했어요.\n$e',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      setState(() {
        uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          width: double.infinity,
          height: 325,
          child: Column(
            children: [
              Text(
                '${widget.title}\n문의를 작성해주세요.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF434343)),
              ),
              const SizedBox(height: 8),
              TextField(
                minLines: 5,
                maxLines: 5,
                maxLength: 400,
                controller: content,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: '문의 내용을 입력해주세요. (최대 400자)',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
                      borderRadius: BorderRadius.circular(16),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  '전화번호, 주민등록번호와 같은 개인정보는 상품문의에 작성하지 말아주세요.',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF878787)),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                  grey: uploading,
                  onPressed: onSubmit,
                  child: const Text('문의하기'))
            ],
          ),
        ));
  }
}
