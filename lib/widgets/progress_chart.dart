import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';

class ProgressChart extends StatelessWidget {
  final List<Activity> activities;

  const ProgressChart({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(
        child: Text("Belum ada data untuk ditampilkan."),
      );
    }

    // Urutkan data berdasarkan tanggal
    activities.sort((a, b) => a.date.compareTo(b.date));

    // Buat titik data untuk grafik
    final spots = activities.asMap().entries.map((entry) {
      int index = entry.key;
      Activity activity = entry.value;
      return FlSpot(index.toDouble(), activity.progress.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= activities.length) {
                  return const SizedBox.shrink();
                }
                DateTime date = activities[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('dd/MM').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blueAccent.withOpacity(0.2),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
        minY: 0,
      ),
    );
  }
}
