import 'package:flutter/material.dart';
import 'package:kereta_app/screens/pelanggan/home_screen.dart';
import 'package:provider/provider.dart';

// --- Providers
import 'providers/history_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/booking_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/pelanggan/booking_screen.dart';
import 'screens/pelanggan/detail_jadwal_screen.dart';
// import 'screens/pelanggan/payment_screen.dart'; // Hapus/Comment
// import 'screens/pelanggan/ticket_detail_screen.dart'; // Hapus/Comment

import 'screens/petugas/admin_home_screen.dart';
import 'screens/petugas/jadwal_management_screen.dart';
import 'screens/petugas/kereta_management_screen.dart';
import 'screens/petugas/kursi_management_screen.dart';
import 'screens/petugas/transaksi_history_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()), 
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PEKERTA INDONESIA',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        
        '/home': (context) => const MainNavigation(),
        '/booking': (context) => const BookingScreen(),
        '/detail-jadwal': (context) => const DetailJadwalScreen(),
        
        // ❌ HAPUS DUA BARIS INI AGAR TIDAK MERAH ❌
        // '/payment': (context) => const PaymentScreen(),
        // '/ticket_detail': (context) => const TicketDetailScreen(),

        '/admin-home': (context) => const AdminHomeScreen(),
        '/kereta-manage': (context) => const KeretaManagementScreen(),
        '/jadwal-manage': (context) => const JadwalManagementScreen(),
        '/kursi-manage': (context) => const KursiManagementScreen(),
        '/transaksi-history': (context) => const TransaksiHistoryScreen(),
      },
    );
  }
}