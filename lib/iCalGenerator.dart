import 'dart:io';
import 'dart:math';

import 'package:PoolCalGenerator/ScheduleEvent.dart';
import 'package:PoolCalGenerator/VersitMaker.dart';

void generate(Map<int,List<ScheduleEvent>> eventsMap, String iCalPath)
{
  print("iCalGenerator: Begin...");
  VersitMaker vCal = VersitMaker.vCal();

  int currentWeek = _currentWeekOfYear();
  int firstCalWeek = eventsMap.keys.reduce(min);
  int lastCalWeek = eventsMap.keys.reduce(max);

  int year = DateTime.now().year;

  // Case when we have schedule for next year in the end of year
  if (currentWeek >= 49 && firstCalWeek < 10)
  {
    year++;
  }
  print("iCalGenerator: Parsing weeks $firstCalWeek - $lastCalWeek for year $year");

  eventsMap.forEach((week, events) {
    events.forEach((event){
      DateTime dateTime = DateTime(year, 1,week*7-(6-event.day));
      vCal.addVersit(VersitMaker.vEvent(dateTime, event.start, event.duration, event.students));
    });
  });

  print("iCalGenerator: Saving iCal file...");
  File ics = new File(iCalPath);
  ics.writeAsStringSync(vCal.toString());

  print("iCalGenerator: Done!");
}

int _currentWeekOfYear()
{
  final date = DateTime.now();
  final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
  final diff = date.difference(startOfYear);
  var weeks = (diff.inDays / 7).ceil();

  return weeks;
}
