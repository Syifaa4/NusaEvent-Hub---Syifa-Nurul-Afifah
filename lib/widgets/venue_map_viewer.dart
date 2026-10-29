import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../utils/format.dart';
import 'glass_container.dart';

class _Room {
  final String label;
  final Rect rect; // koordinat ternormalisasi 0..1
  final Color color;
  final IconData icon;
  final String note;
  const _Room(this.label, this.rect, this.color, this.icon, this.note);
}

const _rooms = <_Room>[
  _Room('Main Hall', Rect.fromLTWH(0.03, 0.05, 0.50, 0.42), Color(0xFF8E54FF),
      Icons.account_balance_rounded, 'Ruang utama untuk seminar berkapasitas besar.'),
  _Room('Workshop A', Rect.fromLTWH(0.56, 0.05, 0.18, 0.20), Color(0xFF00C6FF),
      Icons.computer_rounded, 'Ruang praktik dengan meja dan stop kontak per peserta.'),
  _Room('Workshop B', Rect.fromLTWH(0.77, 0.05, 0.20, 0.20), Color(0xFF38EF7D),
      Icons.laptop_mac_rounded, 'Ruang praktik untuk sesi coding dan UI.'),
  _Room('IoT Lab', Rect.fromLTWH(0.56, 0.28, 0.41, 0.19), Color(0xFFA8E063),
      Icons.developer_board_rounded, 'Lab perangkat keras: sensor, mikrokontroler, dan bench kerja.'),
  _Room('Registrasi', Rect.fromLTWH(0.03, 0.52, 0.20, 0.20), Color(0xFFFF4DA6),
      Icons.how_to_reg_rounded, 'Check-in peserta dan scan QR tiket.'),
  _Room('Lobby & Pintu Masuk', Rect.fromLTWH(0.26, 0.52, 0.30, 0.45), Color(0xFFFFC857),
      Icons.door_front_door_rounded, 'Pintu masuk utama dan area tunggu.'),
  _Room('Food Court', Rect.fromLTWH(0.59, 0.52, 0.38, 0.28), Color(0xFFFF7A59),
      Icons.restaurant_rounded, 'Area makan dan minum untuk peserta.'),
  _Room('Booth Sponsor', Rect.fromLTWH(0.03, 0.75, 0.20, 0.22), Color(0xFF5EEAD4),
      Icons.storefront_rounded, 'Booth sponsor dan merchandise acara.'),
  _Room('Toilet', Rect.fromLTWH(0.59, 0.83, 0.17, 0.14), Color(0xFF94A3B8),
      Icons.wc_rounded, 'Toilet pria dan wanita.'),
  _Room('Musala', Rect.fromLTWH(0.80, 0.83, 0.17, 0.14), Color(0xFF93C5FD),
      Icons.mosque_rounded, 'Tempat ibadah untuk peserta.'),
];

class _VenuePainter extends CustomPainter {
  final String? selected;
  _VenuePainter(this.selected);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    for (var i = 1; i < 10; i++) {
      canvas.drawLine(Offset(size.width * i / 10, 0),
          Offset(size.width * i / 10, size.height), grid);
      canvas.drawLine(Offset(0, size.height * i / 10),
          Offset(size.width, size.height * i / 10), grid);
    }

    final fontSize = (size.shortestSide * 0.045).clamp(9.0, 18.0);

    for (final r in _rooms) {
      final isSel = r.label == selected;
      final rect = Rect.fromLTWH(
        r.rect.left * size.width,
        r.rect.top * size.height,
        r.rect.width * size.width,
        r.rect.height * size.height,
      );
      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(10));
      canvas.drawRRect(
          rr, Paint()..color = r.color.withValues(alpha: isSel ? 0.60 : 0.30));
      canvas.drawRRect(
        rr,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSel ? 3.0 : 1.6
          ..color = isSel ? Colors.white : r.color.withValues(alpha: 0.9),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: r.label,
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: '…',
      )..layout(maxWidth: rect.width - 8);
      tp.paint(canvas, rect.center - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _VenuePainter old) => old.selected != selected;
}

/// Denah venue: dapat digeser & di-zoom (InteractiveViewer), ruangan bisa diketuk.
class VenueMapViewer extends StatefulWidget {
  const VenueMapViewer({super.key});

  @override
  State<VenueMapViewer> createState() => _VenueMapViewerState();
}

class _VenueMapViewerState extends State<VenueMapViewer> {
  final _controller = TransformationController();
  String? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final cur = _controller.value.getMaxScaleOnAxis();
    final next = (cur * factor).clamp(1.0, 5.0);
    final f = next / cur;
    _controller.value = _controller.value.clone()..scaleByDouble(f, f, f, 1.0);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      ));
  }

  void _select(String? label) =>
      setState(() => _selected = label == _selected ? null : label);

  _Room? get _room {
    for (final r in _rooms) {
      if (r.label == _selected) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Peta ----------
        GlassContainer(
          padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: Colors.black.withValues(alpha: 0.25),
                    child: InteractiveViewer(
                      transformationController: _controller,
                      minScale: 1.0,
                      maxScale: 5.0,
                      boundaryMargin: const EdgeInsets.all(100),
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final size = c.biggest;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (d) {
                              final p = Offset(d.localPosition.dx / size.width,
                                  d.localPosition.dy / size.height);
                              String? hit;
                              for (final r in _rooms) {
                                if (r.rect.contains(p)) {
                                  hit = r.label;
                                  break;
                                }
                              }
                              _select(hit);
                            },
                            child: CustomPaint(
                              size: size,
                              painter: _VenuePainter(_selected),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pan_tool_rounded, size: 13),
                            const SizedBox(width: 5),
                            Text(_selected ?? 'Geser & cubit',
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Perbesar',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _zoom(1.3),
                          icon: const Icon(Icons.add_rounded),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Perkecil',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _zoom(1 / 1.3),
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Reset',
                          visualDensity: VisualDensity.compact,
                          onPressed: () =>
                              _controller.value = Matrix4.identity(),
                          icon: const Icon(Icons.center_focus_strong_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ---------- Legenda (juga bisa diketuk) ----------
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Keterangan Ruangan',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  Text('${_rooms.length} area',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in _rooms)
                    _RoomChip(
                      room: r,
                      selected: r.label == _selected,
                      onTap: () => _select(r.label),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ---------- Detail ruangan terpilih ----------
        _roomInfo(_room),
        const SizedBox(height: 12),

        // ---------- Info gedung ----------
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    child: const Icon(Icons.apartment_rounded),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gedung Pusat Sains & Teknologi',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        SizedBox(height: 2),
                        Text('(CS Center) • Lantai 1',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _InfoLine(Icons.location_on_rounded, Colors.orangeAccent,
                  'Jl. Kampus Raya No. 1, Zona Barat Terpadu, Gedung B'),
              const _InfoLine(Icons.directions_bus_rounded, Color(0xFF66AFFE),
                  'Dekat Halte Bis Kampus Timur, parkir motor Zona B & shelter sepeda'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () =>
                          _toast('Membuka Google Maps (simulasi).'),
                      icon: const Icon(Icons.navigation_rounded, size: 18),
                      label: const Text('Buka di Google Maps',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Bagikan',
                    onPressed: () => _toast('Lokasi venue disalin (simulasi).'),
                    icon: const Icon(Icons.share_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roomInfo(_Room? r) {
    if (r == null) {
      return const GlassContainer(
        child: Row(
          children: [
            Icon(Icons.touch_app_rounded, color: Colors.white70),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Ketuk ruangan pada denah atau pilih chip di atas untuk melihat detailnya.',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ),
          ],
        ),
      );
    }

    final events = sampleEvents.where((e) => e.venue == r.label).toList();
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: r.color.withValues(alpha: 0.35),
                  border: Border.all(color: r.color),
                ),
                child: Icon(r.icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.label,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(r.note,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          if (events.isNotEmpty) ...[
            const Divider(height: 22, color: Colors.white24),
            const Text('Acara di ruangan ini',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final e in events)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Icon(Icons.circle, size: 7, color: r.color),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    Text(formatDateRange(e.startDate, e.endDate),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _RoomChip extends StatelessWidget {
  final _Room room;
  final bool selected;
  final VoidCallback onTap;
  const _RoomChip({
    required this.room,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: room.color.withValues(alpha: selected ? 0.40 : 0.14),
              border: Border.all(
                  color: selected
                      ? Colors.white
                      : room.color.withValues(alpha: 0.7)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration:
                      BoxDecoration(color: room.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(room.label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _InfoLine(this.icon, this.color, this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 13, color: Colors.white70)),
            ),
          ],
        ),
      );
}