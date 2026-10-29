import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import 'glass_container.dart';

/// Menampilkan bottom sheet filter kategori. Mengembalikan kategori terpilih.
Future<String?> showFilterBottomSheet(BuildContext context, String current) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheet(current: current),
  );
}

class _FilterSheet extends StatefulWidget {
  final String current;
  const _FilterSheet({required this.current});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _selected = widget.current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GlassContainer(
        margin: const EdgeInsets.all(12),
        radius: 28,
        blur: 30,
        opacity: 0.14,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Filter Kategori',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Pilih topik seminar yang ingin ditampilkan.',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final c in categories)
                    ChoiceChip(
                      avatar: Icon(categoryIcon(c), size: 18),
                      label: Text(c),
                      selected: _selected == c,
                      onSelected: (_) => setState(() => _selected = c),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, 'Semua'),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, _selected),
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
