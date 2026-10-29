import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../utils/format.dart';
import 'glass_container.dart';

double _fill(EventItem e) =>
    e.quota == 0 ? 0.0 : (e.registered / e.quota).clamp(0.0, 1.0).toDouble();

/// Kartu seminar (list utama).
class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
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
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(colors: event.gradient),
                ),
                child: event.image != null
                    ? Image.asset(event.image!, fit: BoxFit.cover)
                    : Icon(event.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Tag(label: event.category, color: event.gradient.first),
                        const Spacer(),
                        _StatusPill(event),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800, height: 1.25),
                    ),
                    const SizedBox(height: 3),
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _Meta(Icons.event_rounded,
                        formatDateRange(event.startDate, event.endDate)),
                    _Meta(Icons.schedule_rounded, event.time),
                  ],
                ),
                const SizedBox(height: 6),
                _Meta(Icons.place_rounded, event.venue),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _QuotaBar(event),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  formatRupiah(event.price),
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              FilledButton.icon(
                onPressed: isFull ? null : onTap,
                icon: Icon(
                    isFull ? Icons.block_rounded : Icons.arrow_forward_rounded,
                    size: 18),
                label: Text(isFull ? 'Penuh' : 'Daftar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Kartu besar untuk carousel "Event Unggulan".
class FeaturedEventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  const FeaturedEventCard(
      {super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
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
          if (event.image != null) ...[
            Image.asset(
              event.image!,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.35),
            ),
          ],
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
          ),
          if (event.image == null)
            Positioned(
              right: 18,
              top: 44,
              child: Icon(
                event.icon,
                size: 92,
                color: Colors.white.withValues(alpha: 0.30),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(event.category,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    _StatusPill(event),
                  ],
                ),
                GlassContainer(
                  radius: 20,
                  blur: 16,
                  opacity: 0.16,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800, height: 1.25)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          _Meta(Icons.event_rounded,
                              formatDateRange(event.startDate, event.endDate)),
                          _Meta(Icons.place_rounded, event.venue),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _QuotaBar(event),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(formatRupiah(event.price),
                                style: t.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800)),
                          ),
                          FilledButton(
                            onPressed: onTap,
                            child: const Text('Daftar Sekarang'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final EventItem event;
  const _StatusPill(this.event);

  @override
  Widget build(BuildContext context) {
    final r = event.remaining;
    final Color c;
    final String label;
    if (r <= 0) {
      c = Colors.redAccent;
      label = 'Penuh';
    } else if (r <= 10) {
      c = Colors.orangeAccent;
      label = 'Sisa $r kursi';
    } else {
      c = Colors.greenAccent;
      label = 'Dibuka';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 10.5, fontWeight: FontWeight.w800, color: c)),
        ],
      ),
    );
  }
}

class _QuotaBar extends StatelessWidget {
  final EventItem event;
  const _QuotaBar(this.event);

  @override
  Widget build(BuildContext context) {
    final fill = _fill(event);
    final hot = event.remaining <= 10;
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Kursi terisi',
                  style: TextStyle(fontSize: 11, color: Colors.white70)),
            ),
            Text(
              '${event.registered}/${event.quota} (${(fill * 100).round()}%)',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: fill,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.14),
            color: hot ? Colors.orangeAccent : Colors.white,
          ),
        ),
      ],
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
/// Poster seminar (dipakai di galeri GridView).
class EventPoster extends StatelessWidget {
  final EventItem event;
  final VoidCallback? onTap;
  const EventPoster({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage = event.image != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Latar gradien
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: event.gradient,
              ),
            ),
          ),

          // 2. Kalau ada gambar: tampilkan utuh
          if (hasImage)
            Image.asset(event.image!, fit: BoxFit.contain),

          // 3. Kalau TIDAK ada gambar: dekorasi lama (lingkaran + ikon)
          if (!hasImage) ...[
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      style: const TextStyle(
                          fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // 4. Area sentuh (selalu ada)
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