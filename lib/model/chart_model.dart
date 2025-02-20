import 'package:flutter/material.dart';

class AttendanceRecord {
  final String date;
  final List<POSData> pos;

  AttendanceRecord({required this.date, required this.pos});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: json['date'],
      pos: (json['pos'] as List).map((e) => POSData.fromJson(e)).toList(),
    );
  }
}

class POSData {
  final String posId;
  final List<GroupAttendance> groups;

  POSData({required this.posId, required this.groups});

  factory POSData.fromJson(Map<String, dynamic> json) {
    return POSData(
      posId: json['pos_id'],
      groups: (json['groups'] as List)
          .map((e) => GroupAttendance.fromJson(e))
          .toList(),
    );
  }
}

class GroupAttendance {
  final String groupName;
  final String color;
  final double attendancePercentage;

  GroupAttendance({
    required this.groupName,
    required this.color,
    required this.attendancePercentage,
  });

  factory GroupAttendance.fromJson(Map<String, dynamic> json) {
    return GroupAttendance(
      groupName: json['group_name'],
      color: json['color'],
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
    );
  }
}

class AttendanceChartData {
  final String date;
  final String groupName;
  final double attendancePercentage;
  final Color color;

  AttendanceChartData({
    required this.date,
    required this.groupName,
    required this.attendancePercentage,
    required this.color,
  });
}
