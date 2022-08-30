import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'button.dart';

void showTimePickerSheet(BuildContext context,
    {selectionMode = DateRangePickerSelectionMode.single,
    void Function(DateTime)? onSelected,
    void Function(DateTime?)? onDone,
    DateTime? selectedDate,
    String title = '날짜를 선택해주세요.'}) {
  showSheet(context,
      child: TimePickerSheet(
          onSelected: onSelected,
          selectionMode: selectionMode,
          onDone: onDone,
          selectedDate: selectedDate,
          title: title));
}

class TimePickerSheet extends StatelessWidget {
  final DateRangePickerSelectionMode selectionMode;
  final void Function(DateTime)? onSelected;
  final void Function(DateTime?)? onDone;
  final DateTime? selectedDate;
  final String title;

  const TimePickerSheet(
      {super.key,
      this.selectionMode = DateRangePickerSelectionMode.single,
      this.onSelected,
      this.onDone,
      this.selectedDate,
      this.title = '시간을 선택해주세요.'});

  @override
  Widget build(BuildContext context) {
    DateTime? value;

    void _onDone() {
      if (onDone != null) {
        onDone!(value);
      }
      Navigator.of(context).pop();
    }

    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TimePickerSpinner(
          time: selectedDate,
          minutesInterval: 5,
          is24HourMode: false,
          highlightedTextStyle:
              const TextStyle(fontSize: 32, color: Colors.black87),
          normalTextStyle: const TextStyle(fontSize: 32, color: Colors.black26),
          spacing: 50,
          itemHeight: 80,
          isForce2Digits: true,
          onTimeChange: (time) {
            value = time;
            if (onSelected != null) {
              onSelected!(time);
            }
          },
        ),
        const SizedBox(height: 8),
        PrimaryButton(
            borderRadius: 14,
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            onPressed: _onDone,
            child: const Text(
              '완료',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ],
    );
  }
}
