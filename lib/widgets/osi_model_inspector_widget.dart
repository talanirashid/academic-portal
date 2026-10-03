import 'package:flutter/material.dart';

class OsiLayer {
  final int number;
  final String name;
  final String pdu;
  final String protocols;
  final String function;

  const OsiLayer(this.number, this.name, this.pdu, this.protocols, this.function);
}

/// OSI 7-Layer Model Inspector Widget for FBISE Class 11 Unit 5 Networking.
class OsiModelInspectorWidget extends StatefulWidget {
  const OsiModelInspectorWidget({super.key});

  @override
  State<OsiModelInspectorWidget> createState() => _OsiModelInspectorWidgetState();
}

class _OsiModelInspectorWidgetState extends State<OsiModelInspectorWidget> {
  int _selectedLayerIndex = 6; // Default Layer 7: Application

  final List<OsiLayer> _layers = const [
    OsiLayer(7, 'Application Layer', 'Data', 'HTTP, HTTPS, FTP, DNS, SMTP', 'Network services directly accessible to user software applications.'),
    OsiLayer(6, 'Presentation Layer', 'Data', 'SSL/TLS, ASCII, JPEG, MPEG', 'Data representation, encryption, compression, and format conversion.'),
    OsiLayer(5, 'Session Layer', 'Data', 'NetBIOS, PPTP, RPC', 'Establishes, manages, and terminates communication sessions between hosts.'),
    OsiLayer(4, 'Transport Layer', 'Segment', 'TCP, UDP', 'End-to-end reliable transmission, flow control, and error checking.'),
    OsiLayer(3, 'Network Layer', 'Packet', 'IPv4, IPv6, ICMP, ARP, OSPF', 'Logical IP addressing and packet routing across subnetworks.'),
    OsiLayer(2, 'Data Link Layer', 'Frame', 'Ethernet (802.3), Wi-Fi (802.11), MAC', 'Physical MAC addressing, framing, and node-to-node error detection.'),
    OsiLayer(1, 'Physical Layer', 'Bits', 'Cables, Fiber Optics, RJ45, Radio Waves', 'Transmission of raw unstructured binary bitstreams over physical medium.'),
  ];

  @override
  Widget build(BuildContext context) {
    final layer = _layers[_selectedLayerIndex];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.layers, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text(
                  'FBISE Unit 5: OSI 7-Layer Protocol Stack Inspector',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Select an OSI layer to inspect its PDU (Protocol Data Unit), associated protocols, and data encapsulation functions:',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Layer Buttons Stack
                Expanded(
                  flex: 2,
                  child: Column(
                    children: _layers.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final l = entry.value;
                      final isSelected = _selectedLayerIndex == idx;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: InkWell(
                          onTap: () => setState(() => _selectedLayerIndex = idx),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF004D26) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isSelected ? const Color(0xFF004D26) : Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: isSelected ? Colors.amber : const Color(0xFF006633),
                                  child: Text('${l.number}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.white)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l.name,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),

                // Details Panel
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF006633).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF006633).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Layer ${layer.number}: ${layer.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF004D26)),
                        ),
                        const Divider(height: 16),
                        _buildDetailRow('PDU Unit:', layer.pdu),
                        const SizedBox(height: 6),
                        _buildDetailRow('Protocols:', layer.protocols),
                        const SizedBox(height: 8),
                        Text('Core Function:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text(layer.function, style: const TextStyle(fontSize: 12, height: 1.3, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 6),
        Expanded(child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006633)))),
      ],
    );
  }
}
