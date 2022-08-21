part of 'add_plant.dart';

extension _MyPlantAddPageStatePages on _MyPlantAddPageState {
  List<Tuple2<bool Function(), Widget Function()>> get pages => [
        Tuple2(
            () => true,
            () => SearchView(
                  onSelected: (item) {
                    plant = item;
                    onNext();
                  },
                )),
        Tuple2(
            page1Valid,
            () => ListView(padding: const EdgeInsets.all(18), children: [
                  const Text(
                    '사진',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF434343)),
                  ),
                  const SizedBox(height: 4),
                  ClipButton(
                      width: 260,
                      height: 260,
                      onPressed: onSetImage,
                      backgroundColor: const Color(0x8E000000),
                      overlay: image != null
                          ? null
                          : const Center(
                              child: Icon(Icons.add,
                                  size: 42, color: Colors.white),
                            ),
                      child: Opacity(
                        opacity: image != null ? 1 : .2,
                        child: image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.cover,
                                width: 260,
                                height: 260,
                              )
                            : CDN.image(id: plant!.image, fit: BoxFit.cover),
                      )),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    controller: nameField,
                    title: '식물 별명',
                    hint: name ??= getRandomName(),
                  ),
                  const SizedBox(height: 16),
                  Expandable(
                    expanded: buildDatePickerFields(scheduleFields.sublist(1)),
                    child: buildDatePickerFields(scheduleFields.sublist(0, 1)),
                  ),
                ])),
        Tuple2(
            () => false,
            () => MyPlantRegisterView(
                  name: plantName,
                  plantName: plant!.name,
                  plantId: plant!.id,
                  image: image!,
                  schedules: dates,
                  onDone: onDone,
                ))
      ];

  void onSetImage() {
    showOpenImageMenu(context, (img) {
      if (img == null) return;
      // ignore: invalid_use_of_protected_member
      setState(() {
        image = img;
      });
    });
  }

  String get plantName =>
      nameField.text.trim().isEmpty ? name! : nameField.text.trim();

  bool page1Valid() {
    if (image == null) {
      Toast.show('$plantName의 사진을 선택해주세요.');
      return false;
    }
    for (var schedule in scheduleFields) {
      if (schedule.required && dates[schedule.key] == null) {
        Toast.show('${schedule.title}을(를) 입력해주세요.', duration: Toast.lengthLong);
        return false;
      }
    }
    return true;
  }

  Widget buildDatePickerFields(List<ScheduleField> fields) {
    return Column(children: [
      for (var schedule in fields) ...[
        const SizedBox(height: 16),
        DatePickerField(
            title: schedule.title,
            hint: schedule.required
                ? '마지막으로 ${schedule.title}를 입력해주세요.'
                : '날짜를 잘 모르거나 없는경우 비워두세요.',
            maxDate: DateTime.now(),
            onDateSelected: (value) => dates[schedule.key] = value),
      ]
    ]);
  }
}

class ScheduleField {
  final bool required;
  final String title;
  final String key;

  const ScheduleField({
    required this.required,
    required this.title,
    required this.key,
  });
}

const List<ScheduleField> scheduleFields = [
  ScheduleField(required: true, title: '물을 준 날짜', key: 'water'),
  ScheduleField(required: false, title: '영양제 준 날짜', key: 'fertilize'),
  ScheduleField(required: false, title: '가지치기한 날짜', key: 'prune'),
];
