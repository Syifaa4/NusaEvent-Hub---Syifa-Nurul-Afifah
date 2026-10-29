import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../utils/format.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_container.dart';

class _Kit {
  final String name;
  final int price;
  final String desc;
  const _Kit(this.name, this.price, this.desc);
}

const _kits = [
  _Kit('Basic', 0, 'Sertifikat digital + materi'),
  _Kit('Standard', 50000, 'Tote bag, notebook, sertifikat'),
  _Kit('Premium', 100000, 'Hoodie, tote bag, merchandise, sertifikat'),
];

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _nimC = TextEditingController();
  final _emailC = TextEditingController();
  final _waC = TextEditingController();

  String _type = 'Mahasiswa';
  DateTime? _date;
  _Kit _kit = _kits.first;
  double _donation = 0;
  bool _agree = false;
  bool _agreeError = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _nimC.dispose();
    _emailC.dispose();
    _waC.dispose();
    super.dispose();
  }

  int get _total => widget.event.price + _kit.price + _donation.round();

  // ---------- Validator ----------
  String? _vName(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Nama wajib diisi';
    if (s.length < 3) return 'Nama minimal 3 karakter';
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(s)) {
      return 'Nama hanya boleh berisi huruf';
    }
    return null;
  }

  String? _vNim(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'NIM wajib diisi';
    if (!RegExp(r'^\d{8,12}$').hasMatch(s)) return 'NIM harus 8–12 digit angka';
    return null;
  }

  String? _vEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(s)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _vWa(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Nomor WhatsApp wajib diisi';
    if (!RegExp(r'^(\+62|62|0)8\d{8,11}$').hasMatch(s)) {
      return 'Gunakan format 08xx / +628xx (10–13 digit)';
    }
    return null;
  }

  // ---------- Aksi ----------
  Future<void> _pickDate(FormFieldState<DateTime> state) async {
    final e = widget.event;
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? e.startDate,
      firstDate: e.startDate,
      lastDate: e.endDate,
      helpText: 'Pilih tanggal kehadiran',
    );
    if (picked != null) {
      state.didChange(picked);
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _agreeError = !_agree);
    if (!valid || !_agree) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Lengkapi data yang masih belum valid.'),
        ));
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi proses
    if (!mounted) return;

    final now = DateTime.now();
    final ticket = RegistrationTicket(
      id: now.microsecondsSinceEpoch.toString(),
      code:
          'NEH-${(now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      event: widget.event,
      name: _nameC.text.trim(),
      nim: _nimC.text.trim(),
      email: _emailC.text.trim(),
      whatsapp: _waC.text.trim(),
      participantType: _type,
      attendanceDate: _date!,
      kitPackage: _kit.name,
      kitPrice: _kit.price,
      donation: _donation.round(),
      createdAt: now,
    );
    Navigator.of(context).pop(ticket);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final t = Theme.of(context).textTheme;

    return PopScope(
      canPop: !_loading,
      child: AppBackground(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text('Pendaftaran Tiket'),
              ),
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ringkasan acara
                            GlassContainer(
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient:
                                          LinearGradient(colors: e.gradient),
                                    ),
                                    child: Icon(e.icon, color: Colors.white),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${formatDateRange(e.startDate, e.endDate)} • ${e.venue}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _section('Data Peserta'),
                            TextFormField(
                              controller: _nameC,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Nama Lengkap',
                                prefixIcon: Icon(Icons.person_rounded),
                              ),
                              validator: _vName,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _nimC,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'NIM',
                                prefixIcon: Icon(Icons.badge_rounded),
                              ),
                              validator: _vNim,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _emailC,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_rounded),
                              ),
                              validator: _vEmail,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _waC,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9+]')),
                                LengthLimitingTextInputFormatter(15),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Nomor WhatsApp',
                                hintText: '08123456789',
                                prefixIcon: Icon(Icons.chat_rounded),
                              ),
                              validator: _vWa,
                            ),
                            const SizedBox(height: 22),
                            _section('Tipe Peserta'),
                            SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<String>(
                                showSelectedIcon: false,
                                segments: const [
                                  ButtonSegment(
                                    value: 'Mahasiswa',
                                    label: Text('Mahasiswa',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  ButtonSegment(
                                    value: 'Dosen',
                                    label: Text('Dosen',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  ButtonSegment(
                                    value: 'Umum',
                                    label: Text('Umum',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                                selected: {_type},
                                onSelectionChanged: (s) =>
                                    setState(() => _type = s.first),
                              ),
                            ),
                            const SizedBox(height: 22),
                            _section('Tanggal Kehadiran'),
                            FormField<DateTime>(
                              validator: (v) => v == null
                                  ? 'Tanggal kehadiran wajib dipilih'
                                  : null,
                              builder: (state) => InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _pickDate(state),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Tanggal hadir',
                                    prefixIcon: const Icon(
                                        Icons.calendar_month_rounded),
                                    errorText: state.errorText,
                                  ),
                                  child: Text(
                                    state.value == null
                                        ? 'Ketuk untuk memilih tanggal'
                                        : formatDate(state.value!),
                                    style: TextStyle(
                                      color: state.value == null
                                          ? Colors.white54
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            _section('Paket Seminar Kit'),
                            for (final k in _kits) _kitTile(k),
                            const SizedBox(height: 14),
                            _section('Donasi (opsional)'),
                            GlassContainer(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 16, 4),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                            'Donasi untuk beasiswa komunitas',
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(
                                        _donation == 0
                                            ? 'Rp0'
                                            : formatRupiah(_donation.round()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _donation,
                                    min: 0,
                                    max: 100000,
                                    divisions: 10,
                                    label: formatRupiah(_donation.round()),
                                    onChanged: (v) =>
                                        setState(() => _donation = v),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            GlassContainer(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: _agree,
                                    onChanged: (v) => setState(() {
                                      _agree = v ?? false;
                                      _agreeError = !_agree;
                                    }),
                                    title: const Text(
                                      'Saya menyetujui tata tertib acara dan data yang diisi sudah benar.',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  if (_agreeError)
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 10),
                                      child: Text(
                                        'Anda harus menyetujui tata tertib',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            GlassContainer(
                              child: Column(
                                children: [
                                  _sum('Tiket seminar', formatRupiah(e.price)),
                                  _sum('Seminar kit ${_kit.name}',
                                      formatRupiah(_kit.price)),
                                  _sum('Donasi',
                                      formatRupiah(_donation.round())),
                                  const Divider(color: Colors.white24),
                                  _sum('Total', formatRupiah(_total),
                                      bold: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: FilledButton.icon(
                                onPressed: _loading ? null : _submit,
                                icon: const Icon(Icons.how_to_reg_rounded),
                                label: const Text('Daftar Sekarang'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_loading)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: const Center(
                    child: GlassContainer(
                      padding: EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Memproses pendaftaran...',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _section(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 4),
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      );

  Widget _sum(String l, String r, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
              child: Text(l,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: bold ? Colors.white : Colors.white70,
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w400)),
            ),
            Text(r,
                style: TextStyle(
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                    fontSize: bold ? 17 : 14)),
          ],
        ),
      );

  Widget _kitTile(_Kit k) {
    final selected = _kit == k;
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 10),
      opacity: selected ? 0.20 : 0.08,
      onTap: () => setState(() => _kit = k),
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.white54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(k.name,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(k.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(k.price == 0 ? 'Gratis' : formatRupiah(k.price),
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}