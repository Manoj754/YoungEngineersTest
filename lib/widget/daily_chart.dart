import 'package:attendance_task/model/chart_model.dart';
import 'package:attendance_task/utils/gradient_for_group.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyChart extends StatelessWidget {
  final List<AttendanceRecord> attendanceData;
  final String selectedPos;
  static RxBool isStackedBar = false.obs;

  const DailyChart(
      {super.key, required this.attendanceData, required this.selectedPos});

  @override
  Widget build(BuildContext context) {
    List<AttendanceChartData> chartData = [];
    Set<String> uniqueGroupNames = {};

    for (var record in attendanceData) {
      var posData = record.pos.firstWhere((pos) => pos.posId == selectedPos,
          orElse: () => POSData(posId: selectedPos, groups: []));

      for (var group in posData.groups) {
        chartData.add(AttendanceChartData(
          date: record.date,
          groupName: group.groupName,
          attendancePercentage: group.attendancePercentage,
          color: Color(int.parse(group.color.replaceAll("#", "0xFF"))),
        ));
        uniqueGroupNames.add(group.groupName); 
      }
    }

    return Obx(
      () => Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Icon(
                    Icons.checklist_outlined,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Daily attendance",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0XFF0a2256)),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.file_download_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      isStackedBar.value = !isStackedBar.value;
                    },
                    child: SvgPicture.asset(
                      isStackedBar.value
                          ? "assets/chart_rotate.svg"
                          : "assets/chart_rotate_2.svg",
                      height: isStackedBar.value ? 25 : 30,
                      width: isStackedBar.value ? 25 : 30,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    return ChartAxisLabel(
                        DateFormat("dd\nMMM yyyy")
                            .format(DateTime.parse(details.text)),
                        const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500));
                  },
                  axisLine: const AxisLine(color: Colors.blue),
                  tickPosition: TickPosition.outside,
                  majorTickLines:
                      const MajorTickLines(width: 0, color: Colors.transparent),
                  majorGridLines:
                      const MajorGridLines(width: 0, color: Colors.transparent),
                ),
                primaryYAxis: NumericAxis(
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    return ChartAxisLabel(
                        '${details.value.toInt()}%',
                        const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500));
                  },
                  axisLine: const AxisLine(width: 0, color: Colors.transparent),
                  majorTickLines:
                      const MajorTickLines(width: 0, color: Colors.transparent),
                  minimum: 10,
                  maximum: 110,
                  interval: 20,
                  majorGridLines: MajorGridLines(
                      color: Colors.blue.withOpacity(.6),
                      dashArray: List.generate(
                        10,
                        (index) => 8,
                      )),
                ),
                isTransposed: isStackedBar.value,
                legend: Legend(
                  isVisible: true,
                  alignment: ChartAlignment.near,
                  overflowMode: LegendItemOverflowMode.wrap,
                  legendItemBuilder:
                      (String name, dynamic series, dynamic point, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: getGradientForGroup(name)),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: uniqueGroupNames.map((groupName) {
                  return StackedColumnSeries<AttendanceChartData, String>(
                    animationDuration: 0,
                    legendIconType: LegendIconType.circle,
                    dataSource: chartData
                        .where((data) => data.groupName == groupName)
                        .toList(),
                    xValueMapper: (AttendanceChartData data, _) => data.date,
                    yValueMapper: (AttendanceChartData data, _) =>
                        data.attendancePercentage,
                    name: groupName,
                    gradient: getGradientForGroup(groupName),
                    width: isStackedBar.value ? 0.3 : 0.2,
                    borderRadius: groupName == "Group 3"
                        ? BorderRadius.only(
                            topLeft:
                                Radius.circular(isStackedBar.value ? 0 : 3),
                            bottomRight:
                                Radius.circular(isStackedBar.value ? 3 : 0),
                            topRight: const Radius.circular(3))
                        : BorderRadius.zero,
                    color: chartData
                        .firstWhere((data) => data.groupName == groupName)
                        .color,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
