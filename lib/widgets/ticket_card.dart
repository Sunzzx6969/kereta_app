import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TicketCard extends StatelessWidget {
  final String code, date, route;
  const TicketCard({super.key, required this.code, required this.date, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.confirmation_num, color: AppColors.primaryNavy),
        title: Text(code, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$route\n$date"),
        isThreeLine: true,
      ),
    );
  }
}