import 'dart:io';
import 'dart:math';

import 'package:PoolCalGenerator/ScheduleEvent.dart';
import 'package:PoolCalGenerator/VersitMaker.dart';

void generate(Map<int,List<ScheduleEvent>> eventsMap, String iCalPath)
{
  VersitMaker vCal = VersitMaker.vCal();

  int currentWeek = _currentWeekOfYear();
  int firstCallWeek = eventsMap.keys.reduce(min);

  int year = DateTime.now().year;

  // Case when we have schedule for next year in the end of year
  if (currentWeek >= 49 && firstCallWeek < 10)
  {
    year++;
  }

  eventsMap.forEach((week, events) {
    events.forEach((event){
      DateTime dateTime = DateTime(year, 1,week*7-(6-event.day));
      vCal.addVersit(VersitMaker.vEvent(dateTime, event.start, event.duration, event.students));
    });
  });

  File ics = new File(iCalPath);
  ics.writeAsStringSync(vCal.toString());
}

int _currentWeekOfYear()
{
  final date = DateTime.now();
  final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
  final firstMonday = startOfYear.weekday;
  final daysInFirstWeek = 8 - firstMonday;
  final diff = date.difference(startOfYear);
  var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
// It might differ how you want to treat the first week
  if(daysInFirstWeek > 3) {
    weeks += 1;
  }
}
