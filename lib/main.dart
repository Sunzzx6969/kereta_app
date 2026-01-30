import 'package:flutter/material.dart';
import 'package:kereta_app/providers/admin_provider.dart';
import 'package:kereta_app/providers/booking_provider.dart';
import 'package:kereta_app/screens/pelanggan/booking_screen.dart';
import 'package:kereta_app/screens/pelanggan/detail_jadwal_screen.dart';
import 'package:kereta_app/screens/pelanggan/payment_screen.dart';
import 'package:kereta_app/screens/pelanggan/ticket_detail_screen.dart';
import 'package:kereta_app/screens/petugas/jadwal_management_screen.dart';
import 'package:kereta_app/screens/petugas/kereta_management_screen.dart';
import 'package:kereta_app/screens/petugas/kursi_management_screen.dart';
import 'package:kereta_app/screens/petugas/monthly_report_screen.dart';
import 'package:kereta_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/pelanggan/home_screen.dart';
import 'screens/petugas/admin_home_screen.dart';

void main() {
  runApp(
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => AdminProvider()), // Tambahkan ini
    ChangeNotifierProvider(create: (_) => BookingProvider()), // Tambahkan ini
  ],
  child: MyApp(),
)
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Ganti ke splash
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainNavigation(),
        '/booking': (context) => BookingScreen(),
        '/ticket-detail': (context) => TicketDetailScreen(),
        '/admin-home': (context) => AdminHomeScreen(),
        '/kereta-manage': (context) => KeretaManagementScreen(),
        '/jadwal-manage': (context) => JadwalManagementScreen(),
        '/kursi-manage': (context) => KursiManagementScreen(),
        '/report': (context) => MonthlyReportScreen(),
        '/detail-jadwal': (context) => DetailJadwalScreen(),
        '/payment': (context) => PaymentScreen(),
      },
    );
  }
}
