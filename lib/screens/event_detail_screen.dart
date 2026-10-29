import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_container.dart';
import 'event_registration_screen.dart';

/// Halaman Detail Acara: tampil sebelum form pendaftaran.
/// Mengembalikan [RegistrationTicket] jika user berhasil mendaftar,
/// atau null jika user kembali tanpa mendaftar.
class EventDetailScreen extends StatefulWidget {
  final EventItem event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  static const _tabs = ['Tentang', 'Pembicara', 'Rundown', 'Fasilitas'];
  int _tab = 0;

  Future<void> _register() async {
    final ticket = await Navigator.of(context).push<RegistrationTicket>(
      MaterialPageRoute(
        builder: (_) => EventRegistrationScreen(event: widget.event),
      ),
    );
    if (ticket != null && mounted) Navigator.of(context).pop(ticket);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final full = e.remaining <= 0;

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Detail Acara'),
        ),
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  _hero(e),
                  const SizedBox(height: 14),
                  _infoGrid(e),
                  const SizedBox(height: 16),
                  _tabBar(),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(_tab),
                      child: switch (_tab) {
                        0 => _about(e),
                        1 => _speaker(e),
                        2 => _rundown(e),
                        _ => _facilities(e),
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  _location(e),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: GlassContainer(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                radius: 24,
                blur: 24,
                opacity: 0.14,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Biaya masuk',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white70)),
                        Text(formatRupiah(e.price),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: full ? null : _register,
                          icon: Icon(
                              full
                                  ? Icons.block_rounded
                                  : Icons.confirmation_number_rounded,
                              size: 20),
                          label: Text(full ? 'Kuota Penuh' : 'Daftar Sekarang',
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Hero ----------
  Widget _hero(EventItem e) {
    final r = e.remaining;
    final hot = r <= 10;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: e.gradient,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (e.image != null) ...[
              Image.asset(
                e.image!,
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
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
            ),
            if (e.image == null)
              Positioned(
                right: 18,
                top: 30,
                child: Icon(
                  e.icon,
                  size: 96,
                  color: Colors.white.withValues(alpha: 0.30),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _pill(e.category, Colors.black, 0.30, Colors.white),
                      _pill(
                        r <= 0
                            ? 'Penuh'
                            : (hot ? 'Sisa $r kursi' : 'Pendaftaran Dibuka'),
                        Colors.black,
                        0.30,
                        r <= 0
                            ? Colors.redAccent
                            : (hot ? Colors.orangeAccent : Colors.greenAccent),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(e.organizer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(e.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w800, height: 1.2)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color bg, double bgAlpha, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg.withValues(alpha: bgAlpha),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
          ],
        ),
      );

  // ---------- Info grid ----------
  Widget _infoGrid(EventItem e) {
    final hot = e.remaining <= 10;
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _infoTile(
                Icons.event_rounded,
                'Waktu Acara',
                formatDateRange(e.startDate, e.endDate),
                e.time,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _infoTile(
                Icons.place_rounded,
                'Lokasi',
                e.venue,
                'Gedung CS Center',
              ),
            ),
          ],
        ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _infoTile(
                Icons.payments_rounded,
                'Biaya Masuk',
                formatRupiah(e.price),
                'Termasuk e-sertifikat',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _infoTile(
                Icons.chair_alt_rounded,
                'Sisa Kuota',
                '${e.remaining} / ${e.quota} kursi',
                hot ? 'Sangat terbatas!' : 'Masih tersedia',
                accent: hot ? Colors.orangeAccent : null,
              ),
            ),
          ],
        ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value, String sub,
      {Color? accent}) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      radius: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (accent ?? Colors.white).withValues(alpha: 0.16),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 2),
                Text(value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: accent)),
                const SizedBox(height: 2),
                Text(sub,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tab bar ----------
  Widget _tabBar() {
    final primary = Theme.of(context).colorScheme.primary;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => setState(() => _tab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: _tab == i
                        ? primary.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                        color: _tab == i ? primary : Colors.white24),
                  ),
                  child: Text(_tabs[i],
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            if (i != _tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String text, {Widget? trailing}) => Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF66AFFE)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
          if (trailing != null) trailing,
        ],
      );

  // ---------- Tab: Tentang ----------
  Widget _about(EventItem e) {
    final paragraphs = e.details.isEmpty ? [e.description] : e.details;
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.info_rounded, 'Deskripsi Acara'),
          const SizedBox(height: 10),
          for (final p in paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(p,
                  style: const TextStyle(
                      fontSize: 13.5, height: 1.5, color: Colors.white70)),
            ),
          if (e.prerequisite.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.terminal_rounded,
                      size: 18, color: Color(0xFF66AFFE)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Prasyarat',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(e.prerequisite,
                            style: const TextStyle(
                                fontSize: 12.5, color: Colors.white70)),
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

  // ---------- Tab: Pembicara ----------
  String _initials(String name) {
    final words = name
        .split(' ')
        .map((w) => w.replaceAll(',', ''))
        .where((w) => w.isNotEmpty && !w.contains('.'))
        .toList();
    if (words.isEmpty) return '?';
    final take = words.take(2).map((w) => w[0].toUpperCase());
    return take.join();
  }

  Widget _speaker(EventItem e) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.record_voice_over_rounded, 'Pembicara'),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: e.gradient),
                  border: Border.all(color: Colors.white38, width: 2),
                ),
                child: Text(_initials(e.speaker),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.speaker,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    if (e.speakerRole.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(e.speakerRole,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.5, color: Color(0xFF66AFFE))),
                    ],
                    if (e.speakerTag.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _pill(e.speakerTag, Colors.white, 0.12, Colors.white),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (e.speakerBio.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(e.speakerBio,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.5, color: Colors.white70)),
          ],
        ],
      ),
    );
  }

  // ---------- Tab: Rundown ----------
  Widget _rundown(EventItem e) {
    final colors = [
      const Color(0xFF00C6FF),
      const Color(0xFF8E54FF),
      Colors.white54,
      Colors.orangeAccent,
    ];
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.schedule_rounded,
            'Agenda & Timeline',
            trailing: Text('${e.rundown.length} sesi',
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ),
          const SizedBox(height: 14),
          if (e.rundown.isEmpty)
            const Text('Rundown belum tersedia.',
                style: TextStyle(color: Colors.white70))
          else
            for (var i = 0; i < e.rundown.length; i++)
              _rundownRow(
                e.rundown[i],
                colors[i % colors.length],
                isLast: i == e.rundown.length - 1,
              ),
        ],
      ),
    );
  }

  Widget _rundownRow(RundownItem r, Color c, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.withValues(alpha: 0.30),
                    border: Border.all(color: c, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.white24),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.time,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: c)),
                  const SizedBox(height: 2),
                  Text(r.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(r.desc,
                      style: const TextStyle(
                          fontSize: 12.5, color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tab: Fasilitas ----------
  Widget _facilities(EventItem e) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.card_giftcard_rounded, 'Benefit Peserta'),
          const SizedBox(height: 4),
          const Text('Semua peserta terdaftar mendapatkan:',
              style: TextStyle(fontSize: 12.5, color: Colors.white70)),
          const SizedBox(height: 12),
          for (final f in e.facilities)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.greenAccent.withValues(alpha: 0.2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 16, color: Colors.greenAccent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.title,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(f.desc,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70)),
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

  // ---------- Petunjuk lokasi ----------
  Widget _location(EventItem e) {
    if (e.locationNote.isEmpty) return const SizedBox.shrink();
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.map_rounded,
            'Petunjuk Lokasi',
            trailing: _pill(e.venue, Colors.white, 0.12, Colors.white),
          ),
          const SizedBox(height: 8),
          Text(e.locationNote,
              style: const TextStyle(
                  fontSize: 13, height: 1.45, color: Colors.white70)),
        ],
      ),
    );
  }
}