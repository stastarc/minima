part of './plant.dart';

extension _MyPlantViewStateMenu on _MyPlantViewState {
  void showMyPlantAddMenuSheet(BuildContext context) {
    showBottomMenuSheet(context, [
      BottomMenuItem(
        title: '기존 식물 등록하기',
        onPressed: () {
          Navigator.push(context, slideRTL(const MyPlantAddPage()));
        },
      ),
      BottomMenuItem(
        title: '마켓에서 데려오기',
        onPressed: () {},
      ),
    ]);
  }
}

extension MyPlantItemMenu on MyPlantItem {
  void showMyPlantMenuSheet(BuildContext context) {
    showBottomMenuSheet(context, [
      BottomMenuItem(
        title: '이름/사진 바꾸기',
        onPressed: () {},
      ),
      BottomMenuItem(
        title: '식물 삭제하기',
        color: const Color(0xFFFF4B4B),
        onPressed: () {},
      ),
    ]);
  }
}
