import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDatePicked;

  CustomDatePicker({required this.onDatePicked});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: context.theme.primaryColor, // Change the primary color to blue
            colorScheme: ColorScheme.light(primary: context.theme.primaryColor), // Change the color scheme to blue
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDatePicked(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: "Pick a date",
        suffixIcon: Icon(Icons.today, color: context.theme.primaryColor,),
        border: UnderlineInputBorder(),
      ),
      initialValue: "${selectedDate.toLocal()}".split(' ')[0],
    );
  }
}
