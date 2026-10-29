import 'package:flutter/material.dart';
import 'glass_container.dart';

class _Room {
  final String label;
  final Rect rect; // koordinat ternormalisasi 0..1
  final Color color;
  const _Room(this.label, this.rect, this.color);
}

const _rooms = <_Room>[
  _Room('Main Hall', Rect.fromLTWH(0.03, 0.05, 0.50, 0.42), Color(0xFF8E54FF)),
  _Room('Workshop A', Rect.fromLTWH(0.56, 0.05, 0.18, 0.20), Color(0xFF00C6FF)),
  _Room('Workshop B', Rect.fromLTWH(0.77, 0.05, 0.20, 0.20), Color(0xFF38EF7D)),
  _Room('IoT Lab', Rect.fromLTWH(0.56, 0.28, 0.41, 0.19), Color(0xFFA8E063)),
  _Room('Registrasi', Rect.fromLTWH(0.03, 0.52, 0.20, 0.20), Color(0xFFFF4DA6)),
  _Room('Lobby & Pintu Masuk', Rect.fromLTWH(0.26, 0.52, 0.30, 0.45), Color(0xFFFFC857)),
  _Room('Food Court', Rect.fromLTWH(0.59, 0.52, 0.38, 0.28), Color(0xFFFF7A59)),
  _Room('Booth Sponsor', Rect.fromLTWH(0.03, 0.75, 0.20, 0.22), Color(0xFF5EEAD4)),
  _Room('Toilet', Rect.fromLTWH(0.59, 0.83, 0.17, 0.14), Color(0xFF94A3B8)),
  _Room('Musala', Rect.fromLTWH(0.80, 0.83, 0.17, 0.14), Color(0xFF93C5FD)),
];

class _VenuePainter extends CustomPainter {
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
      final rect = Rect.fromLTWH(
        r.rect.left * size.width,
        r.rect.top * size.height,
        r.rect.width * size.width,
        r.rect.height * size.height,
      );
      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(10));
      canvas.drawRRect(rr, Paint()..color = r.color.withValues(alpha: 0.30));
      canvas.drawRRect(
        rr,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = r.color.withValues(alpha: 0.9),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Denah venue yang dapat digeser & di-zoom dengan InteractiveViewer.
class VenueMapViewer extends StatefulWidget {
  const VenueMapViewer({super.key});

  @override
  State<VenueMapViewer> createState() => _VenueMapViewerState();
}

class _VenueMapViewerState extends State<VenueMapViewer> {
  final _controller = TransformationController();

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

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Geser & cubit untuk zoom',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              IconButton(
                tooltip: 'Perkecil',
                onPressed: () => _zoom(1 / 1.3),
                icon: const Icon(Icons.zoom_out_rounded),
              ),
              IconButton(
                tooltip: 'Perbesar',
                onPressed: () => _zoom(1.3),
                icon: const Icon(Icons.zoom_in_rounded),
              ),
              IconButton(
                tooltip: 'Reset',
                onPressed: () => _controller.value = Matrix4.identity(),
                icon: const Icon(Icons.center_focus_strong_rounded),
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.25),
                child: InteractiveViewer(
                  transformationController: _controller,
                  minScale: 1.0,
                  maxScale: 5.0,
                  boundaryMargin: const EdgeInsets.all(100),
                  child: SizedBox.expand(
                    child: CustomPaint(painter: _VenuePainter()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
