import 'event_item.dart';

/// Model tiket hasil pendaftaran.
class RegistrationTicket {
  final String id;
  final String code;
  final EventItem event;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final DateTime attendanceDate;
  final String kitPackage;
  final int kitPrice;
  final int donation;
  final DateTime createdAt;

  const RegistrationTicket({
    required this.id,
    required this.code,
    required this.event,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendanceDate,
    required this.kitPackage,
    required this.kitPrice,
    required this.donation,
    required this.createdAt,
  });

  int get total => event.price + kitPrice + donation;
}
