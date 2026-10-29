import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../utils/format.dart';
import 'glass_container.dart';

/// Kartu seminar interaktif (InkWell ada di dalam GlassContainer).
class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final almostFull = event.remaining <= 10;
    final isFull = event.remaining <= 0;

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 14),
      onTap: isFull ? null : onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(colors: event.gradient),
                ),
                child: Icon(event.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Tag(label: event.category, color: event.gradient.first),
                    const SizedBox(height: 6),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.speaker,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _Meta(Icons.event_rounded, formatDateRange(event.startDate, event.endDate)),
              _Meta(Icons.schedule_rounded, event.time),
              _Meta(Icons.place_rounded, event.venue),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatRupiah(event.price),
                      style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      isFull ? 'Kursi habis' : 'Sisa ${event.remaining} kursi',
                      style: t.bodySmall?.copyWith(
                        color: isFull || almostFull
                            ? Colors.orangeAccent
                            : Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: isFull ? null : onTap,
                child: Text(isFull ? 'Penuh' : 'Daftar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.7)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      );
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white60),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ),
        ],
      );
}

/// Poster seminar (dipakai di galeri GridView).
class EventPoster extends StatelessWidget {
  final EventItem event;
  final VoidCallback? onTap;
  const EventPoster({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: event.gradient,
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 40,
            child: Icon(event.icon,
                size: 84, color: Colors.white.withValues(alpha: 0.35)),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(event.category,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GlassContainer(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              radius: 18,
              blur: 14,
              opacity: 0.16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDateRange(event.startDate, event.endDate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}