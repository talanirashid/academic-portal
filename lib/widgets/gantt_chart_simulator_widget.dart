import 'package:flutter/material.dart';

class Process {
  final String pid;
  final int burstTime;

  const Process(this.pid, this.burstTime);
}

/// Interactive OS Process Scheduling Gantt Chart Visualizer for Class 11 OS Chapters.
class GanttChartSimulatorWidget extends StatefulWidget {
  const GanttChartSimulatorWidget({super.key});

  @override
  State<GanttChartSimulatorWidget> createState() => _GanttChartSimulatorWidgetState();
}

class _GanttChartSimulatorWidgetState extends State<GanttChartSimulatorWidget> {
  String _algorithm = 'FCFS';

  final List<Process> _processes = const [
    Process('P1', 6),
    Process('P2', 3),
    Process('P3', 8),
    Process('P4', 2),
  ];

  @override
  Widget build(BuildContext context) {
    List<Process> sortedList = List.from(_processes);
    if (_algorithm == 'SJF (Shortest Job First)') {
      sortedList.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    }

    int currentTimeline = 0;
    List<Map<String, dynamic>> ganttTimeline = [];
    int totalWaitingTime = 0;

    for (var p in sortedList) {
      int start = currentTimeline;
      int end = currentTimeline + p.burstTime;
      int waitingTime = start;
      totalWaitingTime += waitingTime;
      currentTimeline = end;

      ganttTimeline.add({
        'pid': p.pid,
        'burst': p.burstTime,
        'start': start,
        'end': end,
        'waiting': waitingTime,
      });
    }

    final avgWaitingTime = (totalWaitingTime / sortedList.length).toStringAsFixed(2);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.timeline, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'OS Process Scheduling Gantt Chart',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _algorithm,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'FCFS', child: Text('FCFS')),
                    DropdownMenuItem(value: 'SJF (Shortest Job First)', child: Text('SJF')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _algorithm = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Simulating CPU process execution order and time-slice Gantt chart:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Live Gantt Timeline Chart
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ganttTimeline.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D26),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item['pid'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item['start']}s - ${item['end']}s',
                          style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Wait: ${item['waiting']}s',
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Average Waiting Time Summary
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF006633).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Color(0xFF006633), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Average Waiting Time: $avgWaitingTime seconds',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D26), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
