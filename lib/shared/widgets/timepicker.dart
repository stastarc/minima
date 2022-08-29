import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void showTimePickerSheet(BuildContext context,
    {selectionMode = DateRangePickerSelectionMode.single,
    void Function(dynamic)? onDateTimeSelected,
    void Function(dynamic)? onDone,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? selectedDate,
    String title = '날짜를 선택해주세요.'}) {
  showSheet(context,
      child: TimePickerSheet(
          onDateTimeSelected: onDateTimeSelected,
          selectionMode: selectionMode,
          onDone: onDone,
          minDate: minDate,
          maxDate: maxDate,
          selectedDate: selectedDate,
          title: title));
}

class TimePickerSheet extends StatelessWidget {
  final DateRangePickerSelectionMode selectionMode;
  final void Function(dynamic)? onDateTimeSelected;
  final void Function(dynamic)? onDone;
  final DateTime? minDate, maxDate, selectedDate;
  final String title;

  const TimePickerSheet(
      {super.key,
      this.selectionMode = DateRangePickerSelectionMode.single,
      this.onDateTimeSelected,
      this.onDone,
      this.minDate,
      this.maxDate,
      this.selectedDate,
      this.title = '시간을 선택해주세요.'});

  @override
  Widget build(BuildContext context) {
    dynamic value;
    void _onDone() {
      if (onDone != null) {
        onDone!(value);
      }
      Navigator.of(context).pop();
    }

    // void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    //   value = args.value;
    //   if (onDateTimeSelected != null) {
    //     onDateTimeSelected!(args.value);
    //   }
    // }

    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        TimePickerSpinner(
          is24HourMode: false,
          normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
          highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
          spacing: 50,
          itemHeight: 80,
          isForce2Digits: true,
          onTimeChange: (time) {},
        ),
      ],
    );
  }
}
