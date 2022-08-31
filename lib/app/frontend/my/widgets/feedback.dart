import 'package:flutter/material.dart';
import 'package:minima/app/backend/auth/auth.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/future_wait.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:toast/toast.dart';

class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({
    super.key,
  });

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  TextEditingController content = TextEditingController();
  bool uploading = false;

  void onSubmit() async {
    final content = this.content.text.trim();
    if (content.length < 2) {
      Toast.show('피드백 내용은 2자 이상 작성해야 해요.');
      return;
    }

    futureWaitDialog<bool>(context, title: '피드백', message: '피드백을 보내고있어요.',
        future: () async {
      return Auth.instance.sendFeedback(content);
    }(), onDone: (e) {
      if (e) {
        Toast.show('피드백 보냈어요.');
      } else {
        Toast.show('피드백을 보내는데 오류가 발생했어요.', duration: Toast.lengthLong);
      }

      Navigator.pop(context);
    }, onError: (e) {
      Toast.show('피드백을 보내는데 오류가 발생했어요.\n$e', duration: Toast.lengthLong);
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, left: 2, right: 2),
      child: Column(
        children: [
          const Text('피드백 보내기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          PrimaryTextField(
            hint: '피드백 내용을 입력해주세요. (최대 1000자)',
            minLines: 10,
            maxLines: 20,
            maxLength: 1000,
            controller: content,
            keyboardType: TextInputType.multiline,
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '전화번호, 주민등록번호와 같은 개인정보는 작성하지 말아주세요.',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF878787)),
            ),
          ),
          PrimaryButton(
              borderRadius: 14,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              onPressed: onSubmit,
              child: const Text(
                '보내기',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
        ],
      ),
    );
  }
}
