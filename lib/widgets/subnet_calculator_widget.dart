import 'dart:math';
import 'package:flutter/material.dart';

/// Network Subnetting & CIDR Calculator for Class 11 Networking Chapters.
class SubnetCalculatorWidget extends StatefulWidget {
  const SubnetCalculatorWidget({super.key});

  @override
  State<SubnetCalculatorWidget> createState() => _SubnetCalculatorWidgetState();
}

class _SubnetCalculatorWidgetState extends State<SubnetCalculatorWidget> {
  int _cidr = 24;
  final String _ip = '192.168.1.0';

  @override
  Widget build(BuildContext context) {
    int totalHosts = max(0, pow(2, 32 - _cidr).toInt() - 2);
    String subnetMask = '';
    if (_cidr == 24) subnetMask = '255.255.255.0';
    if (_cidr == 26) subnetMask = '255.255.255.192';
    if (_cidr == 28) subnetMask = '255.255.255.240';
    if (_cidr == 30) subnetMask = '255.255.255.252';

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
                    Icon(Icons.lan, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'Network Subnetting & CIDR Calculator',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                DropdownButton<int>(
                  value: _cidr,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 24, child: Text('/24 Mask')),
                    DropdownMenuItem(value: 26, child: Text('/26 Mask')),
                    DropdownMenuItem(value: 28, child: Text('/28 Mask')),
                    DropdownMenuItem(value: 30, child: Text('/30 Mask')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _cidr = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'IP Network Address: $_ip /$_cidr',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF006633)),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _buildSubnetTile('Subnet Mask', subnetMask)),
                const SizedBox(width: 8),
                Expanded(child: _buildSubnetTile('Usable Hosts', '$totalHosts Hosts')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubnetTile(String label, String val) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
        ],
      ),
    );
  }
}
