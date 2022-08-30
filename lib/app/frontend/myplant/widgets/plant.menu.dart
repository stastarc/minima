part of './plant.dart';

extension _MyPlantViewStateMenu on _MyPlantViewState {
  void showMyPlantAddMenuSheet(BuildContext context, VoidCallback onAdd) {
    showBottomMenuSheet(context, [
      BottomMenuItem(
        title: '기존 식물 등록하기',
        onPressed: () {
          Navigator.push(context, slideRTL(MyPlantAddPage(onAdd: onAdd)));
        },
      ),
      BottomMenuItem(
        title: '마켓에서 데려오기',
        color: Colors.black45,
        enable: false,
        onPressed: () {},
      ),
    ]);
  }
}

extension MyPlantItemMenu on MyPlantItem {
  void showMyPlantMenuSheet(BuildContext context,
      {required VoidCallback onRefresh}) {
    void delete(BuildContext _) {
      futureWaitDialog<bool?>(
        context,
        title: '삭제',
        message: '스케줄을 정리하고있어요.',
        future: (() async {
          ToastContext().init(context);
          final res = await MyPlant.instance.unregisterMyPlant(myPlant.id);
          return res;
        })(),
        onDone: (f) {
          onRefresh();
          Toast.show(f == true ? '식물을 삭제했어요.' : '식물을 삭제하지 못했어요.',
              duration: Toast.lengthLong);
        },
        onError: (e) {
          Toast.show('식물을 삭제하지 못했어요.\n$e', duration: Toast.lengthLong);
        },
      );
    }

    void onDelete() {
      showMessageDialog(context,
          title: '정말로 삭제하시겠어요?',
          message: '식물을 정원에서 삭제하면 식물과 함께한 다이어리가 모두 사라져요 😥\n정말로 삭제할까요?',
          buttons: [
            MessageDialogButton.closeButton(title: '취소'),
            MessageDialogButton.closeButton(
                title: '확인', isDestructive: true, onTap: delete),
          ]);
    }

    showBottomMenuSheet(context, [
      BottomMenuItem(
        title: '이름/사진 바꾸기',
        onPressed: () {},
      ),
      BottomMenuItem(
        title: '식물 삭제하기',
        color: const Color(0xFFFF4B4B),
        onPressed: () => onDelete(),
      ),
    ]);
  }
}
