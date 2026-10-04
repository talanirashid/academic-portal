import 'package:flutter/material.dart';
import 'acronym_glossary_widget.dart';
import 'bilingual_tooltip_widget.dart';
import 'cpp_code_runner_widget.dart';
import 'cpu_cycle_simulator_widget.dart';
import 'er_diagram_normalization_widget.dart';
import 'gantt_chart_simulator_widget.dart';
import 'kmap_solver_widget.dart';
import 'logic_gate_simulator_widget.dart';
import 'number_system_scratchpad_widget.dart';
import 'osi_model_inspector_widget.dart';
import 'sql_sandbox_widget.dart';
import 'subnet_calculator_widget.dart';
import 'twos_complement_solver_widget.dart';

class PracticalHubCategory {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget contentWidget;

  const PracticalHubCategory({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.contentWidget,
  });
}

/// Categorized Modular Computing Solver & Practical Hub Grid.
class PracticalHubWidget extends StatefulWidget {
  const PracticalHubWidget({super.key});

  @override
  State<PracticalHubWidget> createState() => _PracticalHubWidgetState();
}

class _PracticalHubWidgetState extends State<PracticalHubWidget> {
  void _openToolModal(BuildContext context, String title, Widget toolWidget) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 650),
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
    final categories = [
      PracticalHubCategory(
        title: 'CPU & Digital Logic',
        description: 'CPU Fetch-Execute Cycle, Logic Gates & Truth Tables',
        icon: Icons.developer_board,
        color: const Color(0xFF006633),
        contentWidget: Column(
          children: const [
            CpuCycleSimulatorWidget(),
            SizedBox(height: 16),
            LogicGateSimulatorWidget(),
          ],
        ),
      ),
      PracticalHubCategory(
        title: 'Number Systems & K-Map',
        description: '2\'s Complement Subtraction, Base Converter & K-Map',
        icon: Icons.calculate,
        color: Colors.amber[800]!,
        contentWidget: Column(
          children: const [
            TwosComplementSolverWidget(),
            SizedBox(height: 16),
            KMapSolverWidget(),
            SizedBox(height: 16),
            NumberSystemScratchpadWidget(),
          ],
        ),
      ),
      PracticalHubCategory(
        title: 'Programming & OS',
        description: 'Class 12 C++ Code Runner & OS Gantt Scheduler',
        icon: Icons.code,
        color: Colors.blue[800]!,
        contentWidget: Column(
          children: const [
            CppCodeRunnerWidget(),
            SizedBox(height: 16),
            GanttChartSimulatorWidget(),
          ],
        ),
      ),
      PracticalHubCategory(
        title: 'Networks & Databases',
        description: 'Subnetting CIDR Calculator, SQL Sandbox & OSI 7-Layer',
        icon: Icons.lan,
        color: Colors.purple[800]!,
        contentWidget: Column(
          children: const [
            SubnetCalculatorWidget(),
            SizedBox(height: 16),
            SqlSandboxWidget(),
            SizedBox(height: 16),
            OsiModelInspectorWidget(),
            SizedBox(height: 16),
            ErDiagramNormalizationWidget(),
          ],
        ),
      ),
      PracticalHubCategory(
        title: 'Glossary & Acronyms',
        description: 'Urdu/English Technical Terminology & Acronyms',
        icon: Icons.menu_book,
        color: Colors.teal[800]!,
        contentWidget: Column(
          children: const [
            BilingualTooltipWidget(),
            SizedBox(height: 16),
            AcronymGlossaryWidget(),
          ],
        ),
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006633).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.build_circle, color: Color(0xFF006633), size: 24),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modular Computing Solver & Practical Hub',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004D26)),
                    ),
                    Text(
                      'Select a practical category to launch interactive lab simulators:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int cols = constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return InkWell(
                      onTap: () => _openToolModal(context, cat.title, cat.contentWidget),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cat.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: cat.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: cat.color,
                              radius: 18,
                              child: Icon(cat.icon, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.title,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: cat.color),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    cat.description,
                                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
