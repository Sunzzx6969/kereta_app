import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({super.key, this.message = "Mohon tunggu..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryOrange),
          ),
          SizedBox(height: 15),
          Text(message, style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}