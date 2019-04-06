import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimePicker {
  DateTime date=new DateTime.now();
  TimeOfDay time= new TimeOfDay.now();

  Future<DateTime> selectDateTime(BuildContext context)async{
    await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          print('confirm $date');
          return date;
        }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}