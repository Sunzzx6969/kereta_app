import 'package:flutter/material.dart';
import 'package:kereta_app/screens/pelanggan/payment_screen.dart';
import 'package:kereta_app/screens/pelanggan/ticket_detail_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/pelanggan/home_screen.dart';
import '../screens/petugas/admin_home_screen.dart';
import '../screens/petugas/monthly_report_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/home': (context) => MainNavigation(),
    '/admin-home': (context) => AdminHomeScreen(),
    '/report': (context) => MonthlyReportScreen(),
    // Pastikan ini ada!
'/payment': (context) => PaymentScreen(),
'/ticket-detail': (context) => TicketDetailScreen(),
    // Tambahkan manual untuk screen lainnya yang sudah kita buat
  };
}