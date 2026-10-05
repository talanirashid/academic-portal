import 'package:flutter/material.dart';
import 'acronym_glossary_widget.dart';
import 'bilingual_tooltip_widget.dart';
import 'cpp_code_runner_widget.dart';
import 'cpu_cycle_simulator_widget.dart';
import 'gantt_chart_simulator_widget.dart';
import 'kmap_solver_widget.dart';
import 'logic_gate_simulator_widget.dart';
import 'number_system_scratchpad_widget.dart';
import 'osi_model_inspector_widget.dart';
import 'sql_sandbox_widget.dart';
import 'subnet_calculator_widget.dart';
import 'twos_complement_solver_widget.dart';

/// Rebranded "CS Practical & Interactive Lab" with a clean 3-Tab Architecture.
class CsPracticalLabSection extends StatefulWidget {
  const CsPracticalLabSection({super.key});

  @override
  State<CsPracticalLabSection> createState() => _CsPracticalLabSectionState();
}

class _CsPracticalLabSectionState extends State<CsPracticalLabSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openDialogTool(BuildContext context, String title, Widget toolWidget) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820, maxHeight: 680),
            child: Scaffold(
              appBar: AppBar(
                title: Text(title),
                backgroundColor: const Color(0xFF004D26),
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: toolWidget,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rebranded Header Title & Badge Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF006633),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.science, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CS Practical & Interactive Lab',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF004D26)),
                        ),
                        Text(
                          'Official Board Practicals, Visual Simulators & Solved Code for Class 9th–12th',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber[800]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 14, color: Color(0xFF004D26)),
                      SizedBox(width: 4),
                      Text(
                        'FBISE & STBB Syllabi Aligned',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3-Tab Selector Bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF006633),
              unselectedLabelColor: Colors.grey[700],
              indicatorColor: const Color(0xFF006633),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.menu_book, size: 18), text: 'Board Practicals & Solved Copies'),
                Tab(icon: Icon(Icons.memory, size: 18), text: 'Interactive Visual Simulators'),
                Tab(icon: Icon(Icons.code, size: 18), text: 'Code Runner & Reference'),
              ],
            ),
            const SizedBox(height: 16),

            // Tab Views Container
            SizedBox(
              height: 380,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // TAB 1: Board Practicals & Solved Copies
                  _buildTab1Practicals(),

                  // TAB 2: Interactive Visual Simulators
                  _buildTab2Simulators(context),

                  // TAB 3: Code Runner & Reference
                  _buildTab3CodeRunner(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab1Practicals() {
    final practicalsList = [
      {'title': 'Experiment 1: C++ Array Insertion & Deletion', 'class': 'Class 12 (HSSC-II)', 'board': 'FBISE & STBB', 'viva': '10 Solved Viva Q&As'},
      {'title': 'Experiment 2: Logic Gate Circuit Verification', 'class': 'Class 11 (HSSC-I)', 'board': 'FBISE & STBB', 'viva': '12 Solved Viva Q&As'},
      {'title': 'Experiment 3: SQL Table Creation & Queries', 'class': 'Class 12 (HSSC-II)', 'board': 'BIEK Karachi', 'viva': '8 Solved Viva Q&As'},
      {'title': 'Experiment 4: Flowcharts & Python Loops', 'class': 'Class 9 (SSC-I)', 'board': 'FBISE & STBB', 'viva': '15 Solved Viva Q&As'},
    ];

    return ListView.builder(
      itemCount: practicalsList.length,
      itemBuilder: (context, index) {
        final item = practicalsList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[300]!)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF006633),
              radius: 18,
              child: Icon(Icons.assignment_turned_in, color: Colors.white, size: 20),
            ),
            title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('${item['class']} • ${item['board']} • ${item['viva']}', style: const TextStyle(fontSize: 11, color: Colors.black87)),
            trailing: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006633),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Downloading watermarked journal copy for ${item['title']}...'), backgroundColor: const Color(0xFF006633)),
                );
              },
              icon: const Icon(Icons.picture_as_pdf, size: 14),
              label: const Text('Journal Copy PDF', style: TextStyle(fontSize: 11)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab2Simulators(BuildContext context) {
    final simulators = [
      {'title': 'CPU Fetch-Execute Cycle', 'desc': 'PC, MAR, MDR, IR & ACC Registers', 'icon': Icons.developer_board, 'color': const Color(0xFF006633), 'widget': const CpuCycleSimulatorWidget()},
      {'title': 'Logic Gate Playground', 'desc': 'AND, OR, NOT, NAND, NOR, XOR & Truth Tables', 'icon': Icons.tune, 'color': const Color(0xFF004D26), 'widget': const LogicGateSimulatorWidget()},
      {'title': '2\'s Complement Subtraction', 'desc': 'Step-by-step binary subtraction visualizer', 'icon': Icons.exposure_minus_1, 'color': Colors.amber[800]!, 'widget': const TwosComplementSolverWidget()},
      {'title': 'K-Map 2-Var Simplifier', 'desc': 'Gray code reduction & Boolean SOP minimizer', 'icon': Icons.grid_on, 'color': Colors.amber[900]!, 'widget': const KMapSolverWidget()},
      {'title': 'OS Gantt Chart Scheduler', 'desc': 'FCFS & SJF process scheduling execution', 'icon': Icons.access_time, 'color': Colors.blue[800]!, 'widget': const GanttChartSimulatorWidget()},
      {'title': 'Network Subnet CIDR', 'desc': 'IP Subnetting calculator & host range', 'icon': Icons.lan, 'color': Colors.purple[800]!, 'widget': const SubnetCalculatorWidget()},
      {'title': 'DBMS SQL Query Sandbox', 'desc': 'Interactive SQL SELECT, WHERE, ORDER BY', 'icon': Icons.storage, 'color': Colors.purple[900]!, 'widget': const SqlSandboxWidget()},
      {'title': 'OSI 7-Layer Inspector', 'desc': 'PDU encapsulation & TCP/IP stack', 'icon': Icons.layers, 'color': Colors.teal[800]!, 'widget': const OsiModelInspectorWidget()},
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: simulators.length,
      itemBuilder: (context, index) {
        final sim = simulators[index];
        final Color col = sim['color'] as Color;
        return InkWell(
          onTap: () => _openDialogTool(context, sim['title'] as String, sim['widget'] as Widget),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: col.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: col.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: col,
                  radius: 16,
                  child: Icon(sim['icon'] as IconData, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sim['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: col), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(sim['desc'] as String, style: const TextStyle(fontSize: 10, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab3CodeRunner(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(14)),
                  onPressed: () => _openDialogTool(context, 'C++ Code Runner & Memory Tracer', const CppCodeRunnerWidget()),
                  icon: const Icon(Icons.code, color: Color(0xFF006633)),
                  label: const Text('Launch C++ Runner (Board Programs)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(14)),
                  onPressed: () => _openDialogTool(context, 'Base Conversion Remainder Scratchpad', const NumberSystemScratchpadWidget()),
                  icon: const Icon(Icons.calculate, color: Colors.amber),
                  label: const Text('Launch Base Conversion Scratchpad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const BilingualTooltipWidget(),
          const SizedBox(height: 12),
          const AcronymGlossaryWidget(),
        ],
      ),
    );
  }
}
