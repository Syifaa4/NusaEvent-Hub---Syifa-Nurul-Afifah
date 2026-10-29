import 'dart:math';
import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';
import '../utils/format.dart';
import '../widgets/glass_container.dart';
import 'home_events_screen.dart' show PageHeader;

class RegisteredTicketsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;
  final ValueChanged<RegistrationTicket> onCancel;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onCancel,
  });

  @override
  State<RegisteredTicketsScreen> createState() =>
      _RegisteredTicketsScreenState();
}

class _RegisteredTicketsScreenState extends State<RegisteredTicketsScreen> {
  String _filter = 'aktif'; // semua | aktif | selesai

  bool _isFinished(RegistrationTicket t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return t.event.endDate.isBefore(today);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      ));
  }

  Future<bool> _confirm(RegistrationTicket t) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.orangeAccent, size: 36),
        title: const Text('Batalkan tiket?'),
        content: Text(
          'Tiket ${t.code} untuk "${t.event.title}" akan dibatalkan dan tidak dapat dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, batalkan'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _cancelByButton(RegistrationTicket t) async {
    final ok = await _confirm(t);
    if (ok && mounted) widget.onCancel(t);
  }

  void _openETicket(RegistrationTicket t) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _ETicketDialog(ticket: t),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = widget.tickets;
    final active = all.where((t) => !_isFinished(t)).toList();
    final done = all.where(_isFinished).toList();
    final shown = _filter == 'semua'
        ? all
        : (_filter == 'aktif' ? active : done);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Tiket Saya',
                subtitle: active.isEmpty
                    ? 'Belum ada tiket aktif.'
                    : '${active.length} tiket aktif • geser ke kiri untuk membatalkan',
                icon: Icons.confirmation_number_rounded,
              ),
              if (all.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: 'semua',
                            label: Text('Semua (${all.length})',
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          ButtonSegment(
                            value: 'aktif',
                            label: Text('Aktif (${active.length})',
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          ButtonSegment(
                            value: 'selesai',
                            label: Text('Selesai (${done.length})',
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                        selected: {_filter},
                        onSelectionChanged: (s) =>
                            setState(() => _filter = s.first),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Check-in Mandiri',
                      onPressed: () =>
                          _toast('Membuka kamera Check-in Mandiri (simulasi).'),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
              Expanded(
                child: all.isEmpty
                    ? const _EmptyState()
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 110),
                        children: [
                          if (shown.isEmpty)
                            const GlassContainer(
                              margin: EdgeInsets.only(bottom: 14),
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  'Tidak ada tiket pada kategori ini.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          for (final t in shown)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _isFinished(t)
                                  ? _TicketCard(
                                      ticket: t,
                                      finished: true,
                                      onOpen: () => _toast(
                                          'Mengunduh E-Sertifikat: ${t.event.title}...'),
                                      onCancel: () {},
                                    )
                                  : Dismissible(
                                      key: ValueKey(t.id),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (_) => _confirm(t),
                                      onDismissed: (_) => widget.onCancel(t),
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 24),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent
                                              .withValues(alpha: 0.55),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.delete_forever_rounded,
                                                size: 30),
                                            Text('Batalkan',
                                                style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      child: _TicketCard(
                                        ticket: t,
                                        finished: false,
                                        onOpen: () => _openETicket(t),
                                        onCancel: () => _cancelByButton(t),
                                      ),
                                    ),
                            ),
                          const _PresenceInfo(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: GlassContainer(
          margin: const EdgeInsets.only(bottom: 110),
          padding: const EdgeInsets.all(28),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.confirmation_number_outlined,
                  size: 56, color: Colors.white54),
              SizedBox(height: 12),
              Text('Belum ada tiket',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('Daftar seminar dari tab Seminar untuk mendapat tiket.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresenceInfo extends StatelessWidget {
  const _PresenceInfo();

  @override
  Widget build(BuildContext context) {
    return const GlassContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: Color(0xFF66AFFE)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Informasi Presensi Acara',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text(
                  'Tunjukkan QR code tiket saat registrasi ulang di pintu masuk venue. Naikkan kecerahan layar agar pemindaian lebih cepat.',
                  style: TextStyle(fontSize: 12.5, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final RegistrationTicket ticket;
  final bool finished;
  final VoidCallback onOpen;
  final VoidCallback onCancel;
  const _TicketCard({
    required this.ticket,
    required this.finished,
    required this.onOpen,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final e = ticket.event;
    final statusColor = finished ? Colors.white70 : Colors.greenAccent;

    return Opacity(
      opacity: finished ? 0.85 : 1,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aksen gradien atas
            Container(
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: e.gradient),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: e.gradient.first.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: e.gradient.first.withValues(alpha: 0.7)),
                        ),
                        child: Text(e.category,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('#${ticket.code}',
                            overflow: TextOverflow.ellipsis,
                            style: t.labelMedium?.copyWith(
                                letterSpacing: 1, color: Colors.white70)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                finished
                                    ? Icons.check_circle_rounded
                                    : Icons.circle,
                                size: finished ? 12 : 7,
                                color: statusColor),
                            const SizedBox(width: 5),
                            Text(finished ? 'SELESAI' : 'AKTIF',
                                style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: statusColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(e.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800, height: 1.25)),
                  const SizedBox(height: 8),
                  _Row(Icons.event_rounded,
                      '${formatDate(ticket.attendanceDate)} • ${e.time}'),
                  _Row(Icons.place_rounded, e.venue),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _KV('Peserta', '${ticket.name} • ${ticket.nim}'),
                        _KV('Tipe', ticket.participantType),
                        _KV('Paket', 'Seminar Kit ${ticket.kitPackage}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Garis perforasi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 1,
                width: double.infinity,
                child: CustomPaint(painter: _DashedLinePainter()),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.qr_code_2_rounded, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Barcode Presensi',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white70)),
                            Text('SEC-${ticket.code.split('-').last}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total bayar',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white70)),
                          Text(formatRupiah(ticket.total),
                              style: t.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onOpen,
                      icon: Icon(
                          finished
                              ? Icons.download_rounded
                              : Icons.qr_code_scanner_rounded,
                          size: 20),
                      label: Text(
                          finished ? 'Unduh E-Sertifikat' : 'Buka E-Tiket & QR Code',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (!finished) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent),
                        onPressed: onCancel,
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Batalkan Tiket'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.4;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(min(x + 6, size.width), 0), p);
      x += 11;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white60),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      );
}

class _KV extends StatelessWidget {
  final String k;
  final String v;
  const _KV(this.k, this.v);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(k,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(v,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

// =====================================================================
// DIALOG E-TIKET + QR
// =====================================================================

class _ETicketDialog extends StatelessWidget {
  final RegistrationTicket ticket;
  const _ETicketDialog({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final e = ticket.event;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          child: GlassContainer(
            blur: 28,
            opacity: 0.18,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.confirmation_number_rounded),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Tiket Digital Kampus',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: 176,
                    height: 176,
                    child: CustomPaint(painter: _QrPainter(ticket.code)),
                  ),
                ),
                const SizedBox(height: 14),
                Text(e.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('#${ticket.code}',
                    style: const TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF66AFFE))),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _KV('Waktu',
                          '${formatDate(ticket.attendanceDate)} • ${e.time}'),
                      _KV('Lokasi', e.venue),
                      _KV('Pemilik', ticket.name),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tunjukkan QR Code ini ke panitia di meja registrasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pola mirip QR (visual simulasi) yang dibangkitkan dari kode tiket.
class _QrPainter extends CustomPainter {
  final String seed;
  const _QrPainter(this.seed);

  static const int n = 25;

  bool _inFinder(int r, int c) =>
      (r < 8 && c < 8) || (r < 8 && c >= n - 8) || (r >= n - 8 && c < 8);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / n;
    final dark = Paint()..color = const Color(0xFF0B0B2B);
    final light = Paint()..color = Colors.white;
    final rnd = Random(seed.hashCode);

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (_inFinder(r, c)) continue;
        if (rnd.nextBool()) {
          canvas.drawRect(
              Rect.fromLTWH(c * cell, r * cell, cell + 0.5, cell + 0.5), dark);
        }
      }
    }

    void finder(int r0, int c0) {
      canvas.drawRect(
          Rect.fromLTWH(c0 * cell, r0 * cell, 7 * cell, 7 * cell), dark);
      canvas.drawRect(
          Rect.fromLTWH((c0 + 1) * cell, (r0 + 1) * cell, 5 * cell, 5 * cell),
          light);
      canvas.drawRect(
          Rect.fromLTWH((c0 + 2) * cell, (r0 + 2) * cell, 3 * cell, 3 * cell),
          dark);
    }

    finder(0, 0);
    finder(0, n - 7);
    finder(n - 7, 0);
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.seed != seed;
}