import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks_data.dart';
import 'package:date_field/date_field.dart';
import 'package:todo/screens/tasksScreen.dart';
import '../theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String? newTaskTitle;
DateTime? dateTime;

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewInsets.bottom + 350,
      color: Colors.transparent,
      child: Container(
          height: MediaQuery.of(context).viewInsets.bottom + 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'عنوان وظیفه',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 25),
                ),
                TextField(
                  // controller: myController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    newTaskTitle = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'تاریخ انقضا وظیفه',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightBlue, fontSize: 25),
                ),
                SizedBox(
                  height: 10,
                ),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: null),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  initialDatePickerMode: DatePickerMode.day,
                  firstDate: DateTime.now(),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) =>
                      (e?.day ?? 0) == 1 ? 'لطفا روز اول وارد نکنید' : null,
                  onDateSelected: (DateTime value) {
                    dateTime = value;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlue),
                  ),
                  autofocus: false,
                  onPressed: () async {
                    print(newTaskTitle);
                    print(dateTime);
                    Provider.of<TaskData>(context, listen: false)
                        .addTask(newTaskTitle!, dateTime!, id);
                    await flutterLocalNotificationsPlugin.schedule(
                      id++,
                      'تاریخ وظیفه گذشته',
                      newTaskTitle!,
                      dateTime!,
                      const NotificationDetails(
                          android: AndroidNotificationDetails(
                              '1', 'تاریخ گذشته', 'یادآور وظایف')),
                      androidAllowWhileIdle: true,
                    );
                    await flutterLocalNotificationsPlugin.schedule(
                      id++,
                      dateTime!.difference(DateTime.now()).inMinutes / 2 < 60
                          ? '${dateTime!.difference(DateTime.now()).inMinutes / 2} دقیقه مانده'
                          : '${dateTime!.difference(DateTime.now()).inHours / 2} ساعت مانده',
                      newTaskTitle!,
                      dateTime!.subtract(Duration(
                          minutes:
                              (dateTime!.difference(DateTime.now()).inMinutes /
                                      2)
                                  .toInt())),
                      const NotificationDetails(
                          android: AndroidNotificationDetails(
                              '5', 'زمان باقی مانده', 'یادآور وظایف')),
                      androidAllowWhileIdle: true,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      // backgroundColor: Colors.lightBlueAccent,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Provider.of<ThemeModel>(context).currentTheme ==
                    ThemeData.dark()
                ? Colors.black
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          )),
    );
  }
}
