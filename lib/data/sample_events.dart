import 'package:flutter/material.dart';
import '../models/event_item.dart';

const categories = ['Semua', 'AI', 'Mobile', 'IoT', 'Cybersecurity'];

IconData categoryIcon(String c) {
  switch (c) {
    case 'AI':
      return Icons.psychology_rounded;
    case 'Mobile':
      return Icons.smartphone_rounded;
    case 'IoT':
      return Icons.sensors_rounded;
    case 'Cybersecurity':
      return Icons.security_rounded;
    default:
      return Icons.apps_rounded;
  }
}

final List<EventItem> sampleEvents = [
  EventItem(
    id: 'e1',
    title: 'Generative AI untuk Produktivitas Kampus',
    category: 'AI',
    speaker: 'Dr. Rina Kusuma, M.Kom.',
    venue: 'Main Hall',
    time: '08.30 – 12.00 WIB',
    description: 'Pengenalan LLM, prompt engineering, dan studi kasus AI di dunia kampus.',
    startDate: DateTime(2026, 11, 14),
    endDate: DateTime(2026, 11, 14),
    price: 25000,
    quota: 150,
    registered: 98,
    icon: Icons.psychology_rounded,
    gradient: const [Color(0xFF8E2DE2), Color(0xFFF953C6)],
  ),
  EventItem(
    id: 'e2',
    title: 'Workshop Machine Learning dengan Python',
    category: 'AI',
    speaker: 'Bagas Prasetyo, M.T.',
    venue: 'Workshop A',
    time: '09.00 – 16.00 WIB',
    description: 'Praktik membangun model prediksi menggunakan scikit-learn dan pandas.',
    startDate: DateTime(2026, 11, 21),
    endDate: DateTime(2026, 11, 22),
    price: 75000,
    quota: 60,
    registered: 57,
    icon: Icons.auto_graph_rounded,
    gradient: const [Color(0xFF6A11CB), Color(0xFF2575FC)],
  ),
  EventItem(
    id: 'e3',
    title: 'Flutter Material 3 Masterclass',
    category: 'Mobile',
    speaker: 'Nadia Putri, S.Kom.',
    venue: 'Workshop B',
    time: '13.00 – 17.00 WIB',
    description: 'Membangun UI modern, responsif, dan interaktif dengan Flutter dan Material 3.',
    startDate: DateTime(2026, 11, 18),
    endDate: DateTime(2026, 11, 18),
    price: 50000,
    quota: 80,
    registered: 41,
    icon: Icons.flutter_dash_rounded,
    gradient: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
  ),
  EventItem(
    id: 'e4',
    title: 'Kotlin Multiplatform untuk Pemula',
    category: 'Mobile',
    speaker: 'Fajar Ramadhan, M.Kom.',
    venue: 'Workshop B',
    time: '09.00 – 12.00 WIB',
    description: 'Berbagi kode bisnis antara Android dan iOS menggunakan Kotlin Multiplatform.',
    startDate: DateTime(2026, 12, 5),
    endDate: DateTime(2026, 12, 5),
    price: 35000,
    quota: 70,
    registered: 22,
    icon: Icons.android_rounded,
    gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
  ),
  EventItem(
    id: 'e5',
    title: 'Smart Campus dengan ESP32 & MQTT',
    category: 'IoT',
    speaker: 'Ir. Dimas Hartono, M.T.',
    venue: 'IoT Lab',
    time: '08.00 – 15.00 WIB',
    description: 'Merancang sistem monitoring ruangan berbasis sensor, ESP32, dan protokol MQTT.',
    startDate: DateTime(2026, 11, 28),
    endDate: DateTime(2026, 11, 29),
    price: 90000,
    quota: 40,
    registered: 36,
    icon: Icons.developer_board_rounded,
    gradient: const [Color(0xFF56AB2F), Color(0xFFA8E063)],
  ),
  EventItem(
    id: 'e6',
    title: 'Sensor & Edge Computing untuk Pertanian',
    category: 'IoT',
    speaker: 'Salsabila Arini, S.T.',
    venue: 'IoT Lab',
    time: '10.00 – 14.00 WIB',
    description: 'Studi kasus smart farming: pengolahan data sensor di perangkat edge.',
    startDate: DateTime(2026, 12, 12),
    endDate: DateTime(2026, 12, 12),
    price: 40000,
    quota: 50,
    registered: 12,
    icon: Icons.eco_rounded,
    gradient: const [Color(0xFF0BA360), Color(0xFF3CBA92)],
  ),
  EventItem(
    id: 'e7',
    title: 'Ethical Hacking & Web Security Basics',
    category: 'Cybersecurity',
    speaker: 'Rizky Maulana, CEH',
    venue: 'Main Hall',
    time: '09.00 – 15.00 WIB',
    description: 'OWASP Top 10, simulasi serangan web, dan teknik pertahanan dasar.',
    startDate: DateTime(2026, 11, 25),
    endDate: DateTime(2026, 11, 25),
    price: 60000,
    quota: 120,
    registered: 104,
    icon: Icons.bug_report_rounded,
    gradient: const [Color(0xFFFF512F), Color(0xFFDD2476)],
  ),
  EventItem(
    id: 'e8',
    title: 'Digital Forensics & Incident Response',
    category: 'Cybersecurity',
    speaker: 'Dewi Anggraini, M.Sc.',
    venue: 'Workshop A',
    time: '13.00 – 17.00 WIB',
    description: 'Investigasi insiden siber: akuisisi bukti, analisis log, dan pelaporan.',
    startDate: DateTime(2026, 12, 19),
    endDate: DateTime(2026, 12, 19),
    price: 45000,
    quota: 60,
    registered: 18,
    icon: Icons.shield_moon_rounded,
    gradient: const [Color(0xFFF7971E), Color(0xFFFF5E62)],
  ),
];
