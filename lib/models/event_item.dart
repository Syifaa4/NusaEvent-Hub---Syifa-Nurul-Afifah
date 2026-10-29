import 'package:flutter/material.dart';

/// Satu sesi pada rundown acara.
class RundownItem {
  final String time;
  final String title;
  final String desc;
  const RundownItem(this.time, this.title, this.desc);
}

/// Satu fasilitas / benefit untuk peserta.
class FacilityItem {
  final String title;
  final String desc;
  const FacilityItem(this.title, this.desc);
}

/// Model data seminar / workshop.
class EventItem {
  final String id;
  final String title;
  final String category; // AI, Mobile, IoT, Cybersecurity
  final String speaker;
  final String venue;
  final String time;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final int quota;
  final int registered;
  final IconData icon;
  final List<Color> gradient;
  final String? image;

  // ---- Data untuk halaman Detail Acara (semua opsional) ----
  final String organizer;
  final String speakerRole;
  final String speakerTag;
  final String speakerBio;
  final List<String> details; // paragraf deskripsi lengkap
  final String prerequisite;
  final String locationNote;
  final List<RundownItem> rundown;
  final List<FacilityItem> facilities;

  const EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.speaker,
    required this.venue,
    required this.time,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.quota,
    required this.registered,
    required this.icon,
    required this.gradient,
    this.image,
    this.organizer = 'Himpunan Mahasiswa Informatika (HMIF)',
    this.speakerRole = '',
    this.speakerTag = '',
    this.speakerBio = '',
    this.details = const [],
    this.prerequisite = '',
    this.locationNote = '',
    this.rundown = const [],
    this.facilities = const [],
  });

  int get remaining => quota - registered;
}