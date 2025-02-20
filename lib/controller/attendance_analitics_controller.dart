import 'dart:math';

import 'package:attendance_task/model/chart_model.dart';
import 'package:attendance_task/utils/json_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceAnaliticsController extends GetxController {
  List<String> filterName = ["Date", "POS", "Group", "Program"];

  List<AttendanceRecord> attendanceData = [];
  String selectedDate = "";
  String selectedPos = "POS 1";
  List<AttendanceRecord> filteredData = [];
  List<String> availableDates = [];
  List<AttendanceChartData> weeklyChartData = [];

  @override
  onInit() {
    super.onInit();
    loadAttendanceData();
  }

  Future<void> loadAttendanceData() async {
    List<AttendanceRecord> records = (jsonData['attendance_records'] as List)
        .map((e) => AttendanceRecord.fromJson(e))
        .toList();

    weeklyChartData = processWeeklyData(records);

    attendanceData = records;
    if (records.isNotEmpty) {
      selectedDate = records.last.date;
    }
    getDailyAttandanceData();
    update();
  }

  selectDate(String value) {
    selectedDate = value;
    getDailyAttandanceData();
    update();
  }

  selectPos(String value) {
    selectedPos = value;
    List<AttendanceRecord> records = (jsonData['attendance_records'] as List)
        .map((e) => AttendanceRecord.fromJson(e))
        .toList();

    weeklyChartData = processWeeklyData(records);
    getDailyAttandanceData();
    update();
  }

  getDailyAttandanceData() {
    availableDates =
        attendanceData.map((record) => record.date).toSet().toList();
    availableDates.sort((a, b) => b.compareTo(a));

    int selectedIndex = availableDates.indexOf(selectedDate);
    List<String> lastFourDates = (selectedIndex != -1)
        ? availableDates.sublist(
            selectedIndex,
            (selectedIndex + 4 <= availableDates.length)
                ? selectedIndex + 4
                : availableDates.length)
        : [selectedDate];

    filteredData = attendanceData
        .where((record) => lastFourDates.contains(record.date))
        .where((record) => record.pos.any((pos) => pos.posId == selectedPos))
        .toList();
  }

  List<AttendanceChartData> processWeeklyData(List<AttendanceRecord> records) {
    if (records.isEmpty) return [];

    records.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    DateTime firstDate = DateTime.parse(records.first.date);
    int firstMonth = firstDate.month;
    int firstYear = firstDate.year;

    records = records.where((r) {
      DateTime date = DateTime.parse(r.date);
      return date.month == firstMonth && date.year == firstYear;
    }).toList();

    Map<String, Map<String, List<double>>> weeklyGroups = {};

    for (var record in records) {
      DateTime date = DateTime.parse(record.date);
      int startDay = ((date.day - 1) ~/ 10) * 10 + 1;
      int endDay = startDay + 9;
      if (endDay > 31) endDay = DateTime(firstYear, firstMonth + 1, 0).day;
      String weekLabel = "$startDay-$endDay ${DateFormat('MMM').format(date)}";

      var posData = record.pos.firstWhere((pos) => pos.posId == selectedPos,
          orElse: () => POSData(posId: selectedPos, groups: []));

      for (var group in posData.groups) {
        weeklyGroups.putIfAbsent(weekLabel, () => {});
        weeklyGroups[weekLabel]!.putIfAbsent(group.groupName, () => []);
        weeklyGroups[weekLabel]![group.groupName]!
            .add(group.attendancePercentage);
      }
    }

    Random random = Random();
    List<AttendanceChartData> chartData = [];

    weeklyGroups.forEach((weekLabel, groupData) {
      groupData.forEach((groupName, percentages) {
        if (percentages.isNotEmpty) {
          double randomAttendance =
              percentages[random.nextInt(percentages.length)] - 5;

          chartData.add(AttendanceChartData(
            date: weekLabel,
            groupName: groupName,
            attendancePercentage: randomAttendance,
            color: getColorForGroup(groupName),
          ));
        }
      });
    });

    return chartData;
  }

  Color getColorForGroup(String groupName) {
    return Colors.primaries[groupName.hashCode % Colors.primaries.length];
  }
}
