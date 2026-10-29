import 'package:flutter/material.dart';

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
  });

  int get remaining => quota - registered;
}
