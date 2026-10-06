import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PaymentAccountDetails {
  final String providerName; // 'JazzCash' | 'EasyPaisa' | 'HBL'
  final String accountTitle;
  final String accountNumber;
  final String type;
  final String? iban;
  final String? branchName;
  final IconData icon;
  final Color brandColor;

  const PaymentAccountDetails({
    required this.providerName,
    required this.accountTitle,
    required this.accountNumber,
    required this.type,
    this.iban,
    this.branchName,
    required this.icon,
    required this.brandColor,
  });
}

class PaymentConfig {
  PaymentConfig._();

  static const PaymentAccountDetails jazzCash = PaymentAccountDetails(
    providerName: 'JazzCash',
    accountTitle: 'Muhammad Rashid',
    accountNumber: '03336366291',
    type: 'Mobile Wallet',
    icon: Icons.account_balance_wallet,
    brandColor: Color(0xFFD32F2F),
  );

  static const PaymentAccountDetails easyPaisa = PaymentAccountDetails(
    providerName: 'EasyPaisa',
    accountTitle: 'Muhammad Rashid',
    accountNumber: '03336366291',
    type: 'Mobile Wallet',
    icon: Icons.phone_android,
    brandColor: Color(0xFF388E3C),
  );

  static const PaymentAccountDetails hblBank = PaymentAccountDetails(
    providerName: 'HBL (Habib Bank Limited)',
    accountTitle: 'Muhammad Rashid',
    accountNumber: '12347900123403',
    type: 'Bank Transfer',
    iban: 'PK36HABB0012347900123403',
    branchName: 'Karachi Cantt Branch (Code: 1234)',
    icon: Icons.account_balance,
    brandColor: Color(0xFF006633),
  );

  static List<PaymentAccountDetails> get allChannels => [
        jazzCash,
        easyPaisa,
        hblBank,
      ];

  /// Copy text helper with SnackBar feedback
  static Future<void> copyToClipboard(
      BuildContext context, String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copied to clipboard!'),
          backgroundColor: const Color(0xFF006633),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
