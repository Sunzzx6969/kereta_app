import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  Map<String, dynamic>? _selectedTicket;
  
  Map<String, dynamic>? get selectedTicket => _selectedTicket;

  void setTicket(Map<String, dynamic> ticket) {
    _selectedTicket = ticket;
    notifyListeners();
  }

  void clearBooking() {
    _selectedTicket = null;
    notifyListeners();
  }
}