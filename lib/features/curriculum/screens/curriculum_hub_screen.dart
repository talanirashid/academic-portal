import 'package:flutter/material.dart';
import '../models/chapter_resource_model.dart';
import '../models/curriculum_stream.dart';
import '../repositories/curriculum_repository.dart';
import 'unit_detail_screen.dart';

/// Dedicated Hub Screen enforcing strict board separation (STBB vs FBISE) & Class Isolation.
class CurriculumHubScreen extends StatefulWidget {
  const CurriculumHubScreen({super.key});

  @override
  State<CurriculumHubScreen> createState() => _CurriculumHubScreenState();
}

class _CurriculumHubScreenState extends State<CurriculumHubScreen> {
  final CurriculumRepository _repository = CurriculumRepository();

  BoardStream _activeBoard = BoardStream.stbb;
  AcademicClass _activeClass = AcademicClass.class11;

  @override
  Widget build(BuildContext context) {
    final activeThemeColor = _activeBoard.badgeColor;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate
      appBar: AppBar(
        title: Text('${_activeBoard.shortCode} Curriculum Vault', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: activeThemeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Board Switcher Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: activeThemeColor.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Target Educational Board:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          avatar: const Icon(Icons.school, size: 16, color: Colors.white),
                          label: const Text('Sindh Board (STBB)'),
                          selected: _activeBoard == BoardStream.stbb,
                          selectedColor: BoardStream.stbb.badgeColor,
                          labelStyle: TextStyle(
                            color: _activeBoard == BoardStream.stbb ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (_) => setState(() => _activeBoard = BoardStream.stbb),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          avatar: const Icon(Icons.account_balance, size: 16, color: Colors.white),
                          label: const Text('Federal Board (FBISE)'),
                          selected: _activeBoard == BoardStream.fbise,
                          selectedColor: BoardStream.fbise.badgeColor,
                          labelStyle: TextStyle(
                            color: _activeBoard == BoardStream.fbise ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (_) => setState(() => _activeBoard = BoardStream.fbise),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Class Selection Chips
            const Text('Select Target Class Grade:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AcademicClass.values.map((c) {
                  final isSelected = _activeClass == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c.uiLabel),
                      selected: isSelected,
                      selectedColor: Colors.amber[800],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 11,
                      ),
                      onSelected: (_) => setState(() => _activeClass = c),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Isolated Unit Stream
            StreamBuilder<List<ChapterResourceModel>>(
              stream: _repository.streamUnits(
                stream: _activeBoard.name,
                targetClass: _activeClass.codeKey,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: Colors.amberAccent),
                    ),
                  );
                }

                final units = snapshot.data ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    final unit = units[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFF334155)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: activeThemeColor,
                          child: Text('${unit.unitNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(unit.unitTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(unit.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeThemeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UnitDetailScreen(
                                  unit: unit,
                                  screenTitle: '${_activeBoard.shortCode} Unit ${unit.unitNumber}',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward, size: 14),
                          label: const Text('Open Unit', style: TextStyle(fontSize: 11)),
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
