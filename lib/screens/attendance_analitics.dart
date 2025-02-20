import 'package:attendance_task/controller/attendance_analitics_controller.dart';
import 'package:attendance_task/widget/daily_chart.dart';
import 'package:attendance_task/widget/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceAnalitics extends StatelessWidget {
  const AttendanceAnalitics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10.withOpacity(.97),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Attendance Analitics",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: Color(0XFF0a2256),
          ),
        ),
        scrolledUnderElevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.account_circle_outlined,
              size: 35,
              color: Colors.grey,
            ),
          )
        ],
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget get body {
    return GetBuilder(
        init: AttendanceAnaliticsController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 1.2,
                      color: Colors.grey.withOpacity(.5),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Showing 2 records",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 25),
                    const Icon(
                      Icons.file_download_outlined,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 35,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: controller.filterName.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index == 0) {}
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.5, horizontal: 15),
                          child: index == 0
                              ? DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: const SizedBox(),
                                    value: controller.selectedDate,
                                    items: controller.availableDates
                                        .map((date) => DropdownMenuItem(
                                              value: date,
                                              child: Text(
                                                date,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) =>
                                        controller.selectDate(value!),
                                  ),
                                )
                              : index == 1
                                  ? DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        icon: const SizedBox(),
                                        value: controller.selectedPos,
                                        items: ["POS 1", "POS 2", "POS 3"]
                                            .map((pos) => DropdownMenuItem(
                                                  value: pos,
                                                  child: Text(
                                                    pos,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.blue),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          controller.selectPos(value!);
                                        },
                                      ),
                                    )
                                  : Text(
                                      controller.filterName[index],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                controller.filteredData.isEmpty
                    ? const Expanded(
                        child: Center(child: Text("No data available")))
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            DailyChart(
                              attendanceData: controller.filteredData,
                              selectedPos: controller.selectedPos,
                            ),
                            const SizedBox(height: 20),
                            WeeklyChart(
                              selectedPos: controller.selectedPos,
                            ),
                            const SizedBox(height: 10),
                          ]),
                        ),
                      )
              ],
            ),
          );
        });
  }

  Widget get bottomNavigationBar {
    return Theme(
      data: ThemeData(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: BottomNavigationBar(
        iconSize: 30,
        currentIndex: 1,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0XFF0a2256),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Stack(children: <Widget>[
                Icon(Icons.bar_chart_outlined),
                Positioned(
                  top: 1.0,
                  left: -1,
                  child:
                      Icon(Icons.brightness_1, size: 8.0, color: Colors.blue),
                )
              ]),
              label: "Statistics"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notes_rounded), label: "Records")
        ],
      ),
    );
  }
}
