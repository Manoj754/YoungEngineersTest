import 'package:flutter/material.dart';

LinearGradient getGradientForGroup(String groupName) {
  if (groupName == "Group 1") {
    return const LinearGradient(
      colors: [Color(0XFF1187D5), Color(0XFF15ACEC)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  } else if (groupName == "Group 2") {
    return const LinearGradient(
      colors: [Color(0XFF870D1A), Color(0XFFD61614)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  } else {
    return const LinearGradient(
      colors: [Color(0XFF19631F), Color(0XFF6DAF2D)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }
}