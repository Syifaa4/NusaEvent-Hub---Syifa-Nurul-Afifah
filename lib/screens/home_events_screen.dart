import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/app_background.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/glass_container.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  int _index = 0;
  String _category = 'Semua';
  final List<RegistrationTicket> _tickets = [];

  List<EventItem> get _filtered => _category == 'Semua'
      ? sampleEvents
      : sampleEvents.where((e) => e.category == _category).toList();

  SnackBar _snack(String msg, {SnackBarAction? action}) => SnackBar(
        content: Text(msg),
        action: action,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      );

  Future<void> _openFilter() async {
    final result = await showFilterBottomSheet(context, _category);
    if (result != null) setState(() => _category = result);
  }

  Future<void> _openRegistration(EventItem event) async {
    // Cegah pendaftaran ganda untuk acara yang sama.
    if (_tickets.any((t) => t.event.id == event.id)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(_snack(
          'Kamu sudah punya tiket untuk acara ini.',
          action: SnackBarAction(
            label: 'Lihat',
            onPressed: () => setState(() => _index = 2),
          ),
        ));
      return;
    }

    final ticket = await Navigator.of(context).push<RegistrationTicket>(
      MaterialPageRoute(builder: (_) => EventRegistrationScreen(event: event)),
    );
    if (ticket == null || !mounted) return;
    setState(() => _tickets.insert(0, ticket));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_snack(
        'Pendaftaran berhasil! Tiket ${ticket.code} sudah aktif.',
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () => setState(() => _index = 2),
        ),
      ));
  }

  void _cancelTicket(RegistrationTicket t) {
    setState(() => _tickets.removeWhere((x) => x.id == t.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_snack('Tiket ${t.code} berhasil dibatalkan.'));
  }

  void _showPoster(EventItem e) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(aspectRatio: 0.72, child: EventPoster(event: e)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openRegistration(e);
                        },
                        child: const Text('Daftar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _EventsTab(
        key: const ValueKey('events'),
        events: _filtered,
        category: _category,
        onFilter: _openFilter,
        onTap: _openRegistration,
      ),
      _GalleryTab(key: const ValueKey('gallery'), onPoster: _showPoster),
      RegisteredTicketsScreen(
        key: const ValueKey('tickets'),
        tickets: _tickets,
        onCancel: _cancelTicket,
      ),
    ];

    return AppBackground(
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: pages[_index],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: GlassContainer(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            padding: EdgeInsets.zero,
            radius: 28,
            blur: 24,
            opacity: 0.12,
            child: NavigationBar(
              height: 68,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.event_note_outlined),
                  selectedIcon: Icon(Icons.event_note_rounded),
                  label: 'Seminar',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.photo_library_outlined),
                  selectedIcon: Icon(Icons.photo_library_rounded),
                  label: 'Galeri',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: _tickets.isNotEmpty,
                    label: Text('${_tickets.length}'),
                    child: const Icon(Icons.confirmation_number_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: _tickets.isNotEmpty,
                    label: Text('${_tickets.length}'),
                    child: const Icon(Icons.confirmation_number_rounded),
                  ),
                  label: 'Tiket',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium?.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GlassContainer(
            padding: const EdgeInsets.all(12),
            radius: 18,
            child: Icon(icon),
          ),
        ],
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  final List<EventItem> events;
  final String category;
  final VoidCallback onFilter;
  final ValueChanged<EventItem> onTap;

  const _EventsTab({
    super.key,
    required this.events,
    required this.category,
    required this.onFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'NusaEvent Hub',
                subtitle: 'Temukan seminar & workshop teknologi terbaik.',
                icon: Icons.auto_awesome_rounded,
              ),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(
                          avatar: Icon(categoryIcon(category), size: 18),
                          label: Text(category),
                        ),
                        Text('${events.length} acara',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onFilter,
                    icon: const Icon(Icons.tune_rounded),
                    label: const Text('Filter'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: events.isEmpty
                    ? const Center(
                        child: Text('Belum ada acara pada kategori ini.',
                            style: TextStyle(color: Colors.white70)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 110),
                        itemCount: events.length,
                        itemBuilder: (_, i) => EventCard(
                          event: events[i],
                          onTap: () => onTap(events[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryTab extends StatelessWidget {
  final ValueChanged<EventItem> onPoster;
  const _GalleryTab({super.key, required this.onPoster});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Galeri & Denah',
                subtitle: 'Poster acara dan denah venue interaktif.',
                icon: Icons.map_rounded,
              ),
              Text('Galeri Poster',
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, c) {
                  final cols = c.maxWidth > 640 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sampleEvents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (_, i) => EventPoster(
                      event: sampleEvents[i],
                      onTap: () => onPoster(sampleEvents[i]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('Denah Venue',
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              const VenueMapViewer(),
            ],
          ),
        ),
      ),
    );
  }
}