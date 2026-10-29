import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/app_background.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/glass_container.dart';
import '../widgets/venue_map_viewer.dart';
import 'registered_tickets_screen.dart';
import 'event_detail_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  int _index = 0;
  String _category = 'Semua';
  String _query = '';
  String _sort = 'default'; // default | nearest | popular
  final List<RegistrationTicket> _tickets = [];

  List<EventItem> get _filtered {
    final q = _query.trim().toLowerCase();
    final list = sampleEvents.where((e) {
      final okCat = _category == 'Semua' || e.category == _category;
      final okQ = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.speaker.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.venue.toLowerCase().contains(q);
      return okCat && okQ;
    }).toList();
    if (_sort == 'nearest') {
      list.sort((a, b) => a.startDate.compareTo(b.startDate));
    } else if (_sort == 'popular') {
      list.sort((a, b) => b.registered.compareTo(a.registered));
    }
    return list;
  }

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
    MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
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
          constraints: const BoxConstraints(maxWidth: 340), // lebar tetap
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.image != null)
                  // Ada gambar: tinggi mengikuti rasio asli gambar (landscape)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      e.image!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  // Tidak ada gambar: poster gradien potret seperti semula
                  AspectRatio(
                    aspectRatio: 0.72,
                    child: EventPoster(event: e),
                  ),
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
        query: _query,
        sort: _sort,
        onFilter: _openFilter,
        onTap: _openRegistration,
        onCategory: (c) => setState(() => _category = c),
        onQuery: (q) => setState(() => _query = q),
        onSort: (s) => setState(() => _sort = _sort == s ? 'default' : s),
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
                  label: 'Galeri & Denah',
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

// =====================================================================
// TAB SEMINAR
// =====================================================================

class _EventsTab extends StatefulWidget {
  final List<EventItem> events;
  final String category;
  final String query;
  final String sort;
  final VoidCallback onFilter;
  final ValueChanged<EventItem> onTap;
  final ValueChanged<String> onCategory;
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onSort;

  const _EventsTab({
    super.key,
    required this.events,
    required this.category,
    required this.query,
    required this.sort,
    required this.onFilter,
    required this.onTap,
    required this.onCategory,
    required this.onQuery,
    required this.onSort,
  });

  @override
  State<_EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<_EventsTab> {
  late final TextEditingController _search =
      TextEditingController(text: widget.query);
  final PageController _page = PageController(viewportFraction: 0.93);
  int _featIndex = 0;

  @override
  void dispose() {
    _search.dispose();
    _page.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      ));
  }

  List<EventItem> get _featured {
    final list = widget.events.where((e) => e.remaining > 0).toList()
      ..sort((a, b) =>
          (b.registered / b.quota).compareTo(a.registered / a.quota));
    return list.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final events = widget.events;
    final featured = _featured;
    final showFeatured = widget.query.trim().isEmpty && featured.isNotEmpty;
    final idx = _featIndex.clamp(0, featured.isEmpty ? 0 : featured.length - 1);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            // ---------- Greeting ----------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Halo, Charlotte 👋',
                              style: t.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Temukan event teknologi & workshop kampus terkini.',
                          style: t.bodyMedium?.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ---------- Search + filter ----------
            GlassContainer(
              radius: 28,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: widget.onQuery,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Cari seminar, workshop, topik...',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  if (widget.query.isNotEmpty)
                    IconButton(
                      tooltip: 'Hapus pencarian',
                      icon: const Icon(Icons.cancel_rounded, size: 20),
                      onPressed: () {
                        _search.clear();
                        widget.onQuery('');
                      },
                    ),
                  Container(width: 1, height: 24, color: Colors.white24),
                  IconButton(
                    tooltip: 'Filter',
                    onPressed: widget.onFilter,
                    icon: Badge(
                      isLabelVisible: widget.category != 'Semua',
                      smallSize: 9,
                      child: const Icon(Icons.tune_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------- Chip kategori ----------
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _CategoryChip(
                  label: categories[i],
                  selected: widget.category == categories[i],
                  onTap: () => widget.onCategory(categories[i]),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ---------- Chip cepat ----------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const _OpenBadge(),
                  const SizedBox(width: 8),
                  _QuickChip(
                    label: 'Terdekat',
                    icon: Icons.near_me_rounded,
                    selected: widget.sort == 'nearest',
                    onTap: () => widget.onSort('nearest'),
                  ),
                  const SizedBox(width: 8),
                  _QuickChip(
                    label: 'Populer',
                    icon: Icons.trending_up_rounded,
                    selected: widget.sort == 'popular',
                    onTap: () => widget.onSort('popular'),
                  ),
                ],
              ),
            ),

            // ---------- Event Unggulan ----------
            if (showFeatured) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded,
                      color: Colors.orangeAccent, size: 22),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('Event Unggulan',
                        style: t.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  _CountPill('${idx + 1} dari ${featured.length}'),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 280,
                child: PageView.builder(
                  controller: _page,
                  padEnds: false,
                  itemCount: featured.length,
                  onPageChanged: (i) => setState(() => _featIndex = i),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FeaturedEventCard(
                      event: featured[i],
                      onTap: () => widget.onTap(featured[i]),
                    ),
                  ),
                ),
              ),
            ],

            // ---------- Semua event ----------
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Text('Semua Seminar & Workshop',
                      style: t.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ),
                _CountPill('${events.length}'),
              ],
            ),
            const SizedBox(height: 12),
            if (events.isEmpty)
              const GlassContainer(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 48, color: Colors.white54),
                      SizedBox(height: 10),
                      Text('Acara tidak ditemukan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Coba kata kunci atau kategori lain.',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              )
            else
              for (final e in events)
                EventCard(event: e, onTap: () => widget.onTap(e)),

            // ---------- Banner ajakan ----------
            const SizedBox(height: 4),
            GlassContainer(
              onTap: () => _toast('Fitur pengajuan proposal segera hadir.'),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    child: const Icon(Icons.campaign_rounded),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Punya Ide Workshop Sendiri?',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        SizedBox(height: 2),
                        Text('Ajukan proposal komunitasmu ke Divisi Tech Kampus',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: () =>
                        _toast('Fitur pengajuan proposal segera hadir.'),
                    child: const Text('Ajukan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.7)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: Colors.greenAccent),
            SizedBox(width: 6),
            Text('Pendaftaran Dibuka',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _QuickChip({
    required this.label,
    required this.icon,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15),
                const SizedBox(width: 5),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: selected
                  ? const LinearGradient(
                      colors: [Color(0xFF8E54FF), Color(0xFF00C6FF)])
                  : null,
              color: selected ? null : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                  color: selected ? Colors.transparent : Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(categoryIcon(label), size: 17),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}

class _CountPill extends StatelessWidget {
  final String text;
  const _CountPill(this.text);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      );
}

// =====================================================================
// TAB GALERI & DENAH
// =====================================================================

class _GalleryTab extends StatefulWidget {
  final ValueChanged<EventItem> onPoster;
  const _GalleryTab({super.key, required this.onPoster});

  @override
  State<_GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<_GalleryTab> {
  int _seg = 0; // 0 = denah venue, 1 = galeri poster
  String _cat = 'Semua';

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      icon: Icon(Icons.map_rounded, size: 18),
                      label: Text('Denah Venue',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    ButtonSegment(
                      value: 1,
                      icon: Icon(Icons.photo_library_rounded, size: 18),
                      label: Text('Galeri Poster',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                  selected: {_seg},
                  onSelectionChanged: (s) => setState(() => _seg = s.first),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _seg == 0
                    ? const VenueMapViewer(key: ValueKey('venue'))
                    : _posters(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _posters(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final list = _cat == 'Semua'
        ? sampleEvents
        : sampleEvents.where((e) => e.category == _cat).toList();

    return Column(
      key: const ValueKey('posters'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Poster & Arsip',
                      style: t.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('Dokumentasi seminar & workshop teknologi',
                      style: t.bodySmall?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            _CountPill('${list.length} acara'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _CategoryChip(
              label: categories[i],
              selected: _cat == categories[i],
              onTap: () => setState(() => _cat = categories[i]),
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const GlassContainer(
            padding: EdgeInsets.all(28),
            child: Center(
              child: Text('Belum ada poster pada kategori ini.',
                  style: TextStyle(color: Colors.white70)),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth > 640 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.78,
                ),
                itemBuilder: (_, i) => EventPoster(
                  event: list[i],
                  onTap: () => widget.onPoster(list[i]),
                ),
              );
            },
          ),
      ],
    );
  }
}