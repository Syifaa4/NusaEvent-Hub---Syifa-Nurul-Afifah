import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';
import '../utils/format.dart';
import '../widgets/glass_container.dart';
import 'home_events_screen.dart' show PageHeader;

class RegisteredTicketsScreen extends StatelessWidget {
  final List<RegistrationTicket> tickets;
  final ValueChanged<RegistrationTicket> onCancel;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onCancel,
  });

  Future<bool> _confirm(BuildContext context, RegistrationTicket t) async {
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
              PageHeader(
                title: 'Tiket Terdaftar',
                subtitle: tickets.isEmpty
                    ? 'Belum ada tiket aktif.'
                    : '${tickets.length} tiket aktif • geser ke kiri untuk membatalkan',
                icon: Icons.confirmation_number_rounded,
              ),
              Expanded(
                child: tickets.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 110),
                        itemCount: tickets.length,
                        itemBuilder: (context, i) {
                          final t = tickets[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Dismissible(
                              key: ValueKey(t.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) => _confirm(context, t),
                              onDismissed: (_) => onCancel(t),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(alpha: 0.55),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete_forever_rounded, size: 30),
                                    Text('Batalkan',
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              child: _TicketCard(ticket: t),
                            ),
                          );
                        },
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
              Icon(Icons.confirmation_number_outlined, size: 56, color: Colors.white54),
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

class _TicketCard extends StatelessWidget {
  final RegistrationTicket ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final e = ticket.event;

    return GlassContainer(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: e.gradient,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(ticket.code,
                              overflow: TextOverflow.ellipsis,
                              style: t.labelLarge?.copyWith(
                                  letterSpacing: 1.2, color: Colors.white70)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.greenAccent),
                          ),
                          child: const Text('AKTIF',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.greenAccent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(e.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const Divider(height: 22, color: Colors.white24),
                    _Row(Icons.person_rounded, '${ticket.name} • ${ticket.nim}'),
                    _Row(Icons.badge_rounded, ticket.participantType),
                    _Row(Icons.event_available_rounded,
                        'Hadir: ${formatDate(ticket.attendanceDate)}'),
                    _Row(Icons.card_giftcard_rounded,
                        'Seminar Kit ${ticket.kitPackage}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Total bayar',
                              style: TextStyle(color: Colors.white70)),
                        ),
                        Text(formatRupiah(ticket.total),
                            style: t.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
