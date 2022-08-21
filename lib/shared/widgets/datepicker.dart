import 'package:flutter/material.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/textfield.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void showDatePickerSheet(BuildContext context,
    {selectionMode = DateRangePickerSelectionMode.single,
    void Function(dynamic)? onDateTimeSelected,
    void Function(dynamic)? onDone,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? selectedDate,
    String title = '날짜를 선택해주세요.'}) {
  showSheet(context,
      child: DatePickerSheet(
          onDateTimeSelected: onDateTimeSelected,
          selectionMode: selectionMode,
          onDone: onDone,
          minDate: minDate,
          maxDate: maxDate,
          selectedDate: selectedDate,
          title: title));
}

class DatePickerSheet extends StatelessWidget {
  final DateRangePickerSelectionMode selectionMode;
  final void Function(dynamic)? onDateTimeSelected;
  final void Function(dynamic)? onDone;
  final DateTime? minDate, maxDate, selectedDate;
  final String title;

  const DatePickerSheet(
      {super.key,
      this.selectionMode = DateRangePickerSelectionMode.single,
      this.onDateTimeSelected,
      this.onDone,
      this.minDate,
      this.maxDate,
      this.selectedDate,
      this.title = '날짜를 선택해주세요.'});

  @override
  Widget build(BuildContext context) {
    dynamic value;
    void _onDone() {
      if (onDone != null) {
        onDone!(value);
      }
      Navigator.of(context).pop();
    }

    void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      value = args.value;
      if (onDateTimeSelected != null) {
        onDateTimeSelected!(args.value);
      }
    }

    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        SfDateRangePicker(
            minDate: minDate,
            maxDate: maxDate,
            initialSelectedDate: selectedDate,
            selectionColor: const Color(0xFF53CE86),
            todayHighlightColor: const Color(0xFF53CE86),
            selectionMode: selectionMode,
            onSelectionChanged: onSelectionChanged),
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

class DatePickerField extends StatefulWidget {
  final bool Function(DateTime)? onDateSelect;
  final void Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String? title;
  final String pickerTitle;
  final String? hint;

  const DatePickerField({
    super.key,
    this.onDateSelect,
    this.selectedDate,
    this.minDate,
    this.maxDate,
    this.title = '날짜',
    this.pickerTitle = '날짜를 선택해주세요.',
    this.hint = '날짜를 선택해주세요.',
    required this.onDateSelected,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController textField;

  @override
  void initState() {
    super.initState();
    textField = TextEditingController(
        text: widget.selectedDate != null
            ? longDateFormat(widget.selectedDate!)
            : null);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: textField,
      title: widget.title,
      readOnly: true,
      prefixIcon: const Icon(Icons.calendar_month, color: Color(0xFF3D3D3D)),
      onTap: () => showDatePickerSheet(
        context,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
        selectedDate: widget.selectedDate,
        title: widget.pickerTitle,
        onDone: (value) => setState(() {
          if (value == null) return;
          if (widget.onDateSelect != null && !widget.onDateSelect!(value)) {
            return;
          }
          textField.text = longDateFormat(value);
          widget.onDateSelected(value);
        }),
        selectionMode: DateRangePickerSelectionMode.single,
      ),
      hint: widget.hint,
    );
  }
}
