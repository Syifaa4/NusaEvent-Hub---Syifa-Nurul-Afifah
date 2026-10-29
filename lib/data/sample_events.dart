import 'package:flutter/material.dart';
import '../models/event_item.dart';

const categories = ['Semua', 'AI', 'Mobile', 'IoT', 'Cybersecurity'];

IconData categoryIcon(String c) {
  switch (c) {
    case 'AI':
      return Icons.psychology_rounded;
    case 'Mobile':
      return Icons.smartphone_rounded;
    case 'IoT':
      return Icons.sensors_rounded;
    case 'Cybersecurity':
      return Icons.security_rounded;
    default:
      return Icons.apps_rounded;
  }
}

/// Fasilitas dasar yang didapat semua peserta.
const _baseFacilities = [
  FacilityItem('E-Sertifikat Resmi', 'Divalidasi panitia dan fakultas.'),
  FacilityItem('Modul & Materi Digital',
      'Akses materi dan contoh kode setelah acara selesai.'),
];

final List<EventItem> sampleEvents = [
  EventItem(
    id: 'e1',
    title: 'Generative AI untuk Produktivitas Kampus',
    category: 'AI',
    speaker: 'Dr. Rina Zayn, M.Kom.',
    venue: 'Main Hall',
    time: '08.30 – 12.00 WIB',
    description:
        'Pengenalan LLM, prompt engineering, dan studi kasus AI di dunia kampus.',
    startDate: DateTime(2026, 11, 14),
    endDate: DateTime(2026, 11, 14),
    price: 25000,
    quota: 150,
    registered: 98,
    icon: Icons.psychology_rounded,
    gradient: const [Color(0xFF8E2DE2), Color(0xFFF953C6)],
    image: 'assets/images/ai0.jpg',
    organizer: 'UKM Artificial Intelligence Kampus',
    speakerRole: 'Dosen & Peneliti AI, Fakultas Ilmu Komputer',
    speakerTag: 'Peneliti NLP',
    speakerBio:
        'Meneliti pemrosesan bahasa alami dan pemanfaatan AI generatif di perguruan tinggi. Aktif membimbing mahasiswa dalam riset dan pengembangan aplikasi berbasis LLM.',
    details: [
      'Seminar ini membahas cara kerja large language model dan bagaimana memanfaatkannya secara bertanggung jawab untuk kegiatan kampus: menyusun ringkasan materi, merancang outline tugas, hingga membantu administrasi.',
      'Peserta akan belajar teknik prompt engineering yang praktis dan mempelajari studi kasus nyata, termasuk batasan, etika, dan risiko penggunaan AI dalam akademik.',
    ],
    prerequisite: 'Bawa laptop atau ponsel. Tidak perlu pengalaman coding.',
    locationNote:
        'Main Hall berada di sisi barat gedung. Masuk lewat Lobby, lalu lanjut lurus ke arah panggung utama.',
    rundown: [
      RundownItem('08.30 – 09.00 WIB', 'Registrasi & Check-in',
          'Scan QR tiket dan pembagian name tag.'),
      RundownItem('09.00 – 10.00 WIB', 'Pengenalan LLM',
          'Cara kerja model bahasa besar serta kelebihan dan batasannya.'),
      RundownItem('10.00 – 10.15 WIB', 'Coffee Break',
          'Rehat dan networking bersama peserta lain.'),
      RundownItem('10.15 – 12.00 WIB', 'Prompt Engineering & Studi Kasus',
          'Praktik menyusun prompt untuk tugas kuliah, riset, dan administrasi.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Template Prompt', 'Kumpulan prompt siap pakai untuk mahasiswa.'),
      FacilityItem('Snack & Coffee Break', 'Disediakan saat sesi rehat.'),
    ],
  ),
  EventItem(
    id: 'e2',
    title: 'Workshop Machine Learning dengan Python',
    category: 'AI',
    speaker: 'Bagas Prasetyo, M.T.',
    venue: 'Workshop A',
    time: '09.00 – 16.00 WIB',
    description:
        'Praktik membangun model prediksi menggunakan scikit-learn dan pandas.',
    startDate: DateTime(2026, 11, 21),
    endDate: DateTime(2026, 11, 22),
    price: 75000,
    quota: 60,
    registered: 57,
    icon: Icons.auto_graph_rounded,
    gradient: const [Color(0xFF6A11CB), Color(0xFF2575FC)],
    image: 'assets/images/ai1.jpg',
    organizer: 'UKM Artificial Intelligence Kampus',
    speakerRole: 'Data Scientist, praktisi industri fintech',
    speakerTag: 'Praktisi ML',
    speakerBio:
        'Berpengalaman membangun model prediksi untuk analisis risiko dan perilaku pelanggan. Gemar mengajarkan machine learning dengan pendekatan praktik langsung.',
    details: [
      'Workshop dua hari ini membawa peserta dari nol sampai bisa membangun model prediksi sederhana: membersihkan data, eksplorasi, melatih model, dan mengevaluasi hasilnya.',
      'Seluruh sesi berbasis praktik dengan Python, pandas, dan scikit-learn. Jadwal sama setiap harinya dan peserta bebas memilih tanggal hadir.',
    ],
    prerequisite:
        'Laptop dengan Python 3.10+ dan Jupyter terpasang. Dasar Python sangat disarankan.',
    locationNote:
        'Workshop A ada di sisi timur Main Hall. Ikuti penunjuk arah Workshop dari Lobby.',
    rundown: [
      RundownItem('09.00 – 10.00 WIB', 'Setup Environment',
          'Instalasi Python, Jupyter, scikit-learn, dan pandas.'),
      RundownItem('10.00 – 12.00 WIB', 'Data Cleaning & EDA',
          'Membersihkan data dan membaca pola dengan visualisasi.'),
      RundownItem('12.00 – 13.00 WIB', 'Ishoma', 'Istirahat, sholat, dan makan siang.'),
      RundownItem('13.00 – 16.00 WIB', 'Membangun & Evaluasi Model',
          'Melatih model prediksi dan mengukur performanya.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Dataset & Notebook', 'Dataset latihan dan notebook lengkap.'),
      FacilityItem('Makan Siang', 'Disediakan setiap hari pelaksanaan.'),
    ],
  ),
  EventItem(
    id: 'e3',
    title: 'Flutter Material 3 Masterclass',
    category: 'Mobile',
    speaker: 'Nadia Chelsie, S.Kom.',
    venue: 'Workshop B',
    time: '13.00 – 17.00 WIB',
    description:
        'Membangun UI modern, responsif, dan interaktif dengan Flutter dan Material 3.',
    startDate: DateTime(2026, 11, 18),
    endDate: DateTime(2026, 11, 18),
    price: 50000,
    quota: 80,
    registered: 41,
    icon: Icons.flutter_dash_rounded,
    gradient: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
    image: 'assets/images/ai2.jpg',
    organizer: 'Google Developer Student Club',
    speakerRole: 'Senior Mobile Engineer',
    speakerTag: 'Flutter Specialist',
    speakerBio:
        'Telah membangun berbagai aplikasi Flutter skala produksi dan aktif berbagi ilmu di komunitas pengembang mobile.',
    details: [
      'Masterclass ini fokus pada pembuatan antarmuka modern dengan Material 3: color scheme, tipografi, komponen terbaru, dan tema dinamis.',
      'Peserta juga belajar membuat layout responsif dan bebas overflow, serta praktik membangun halaman interaktif langsung dari nol.',
    ],
    prerequisite: 'Laptop dengan Flutter SDK 3.19+ dan VS Code atau Android Studio.',
    locationNote:
        'Workshop B berada di sebelah Workshop A, dekat jalur menuju IoT Lab.',
    rundown: [
      RundownItem('13.00 – 13.30 WIB', 'Registrasi & Setup',
          'Check-in tiket dan verifikasi proyek starter.'),
      RundownItem('13.30 – 15.00 WIB', 'Material 3 & Theming',
          'ColorScheme, tipografi, dan komponen Material 3.'),
      RundownItem('15.00 – 15.15 WIB', 'Break', 'Rehat singkat dan snack.'),
      RundownItem('15.15 – 17.00 WIB', 'Hands-on Responsive UI',
          'Membangun layout responsif dan interaktif secara langsung.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Source Code Starter Kit', 'Repo proyek awal dan hasil akhir.'),
      FacilityItem('Stiker Flutter', 'Bagian dari seminar kit.'),
    ],
  ),
  EventItem(
    id: 'e4',
    title: 'Kotlin Multiplatform untuk Pemula',
    category: 'Mobile',
    speaker: 'Ardhana Brahmana, M.Kom.',
    venue: 'Workshop B',
    time: '09.00 – 12.00 WIB',
    description:
        'Berbagi kode bisnis antara Android dan iOS menggunakan Kotlin Multiplatform.',
    startDate: DateTime(2026, 12, 5),
    endDate: DateTime(2026, 12, 5),
    price: 35000,
    quota: 70,
    registered: 22,
    icon: Icons.android_rounded,
    gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
    image: 'assets/images/kode.jpg',
    organizer: 'Google Developer Student Club',
    speakerRole: 'Android Engineer & Dosen Tamu',
    speakerTag: 'Praktisi Kotlin',
    speakerBio:
        'Berpengalaman mengembangkan aplikasi Android dan memperkenalkan pendekatan lintas platform kepada mahasiswa.',
    details: [
      'Pelajari cara berbagi logika bisnis antara Android dan iOS menggunakan Kotlin Multiplatform tanpa menulis ulang kode di setiap platform.',
      'Sesi ini cocok untuk pemula: dimulai dari konsep, struktur proyek, sampai praktik membuat modul bersama.',
    ],
    prerequisite: 'Laptop dengan Android Studio terbaru. Dasar Kotlin lebih baik.',
    locationNote: 'Workshop B berada di lantai yang sama dengan Workshop A.',
    rundown: [
      RundownItem('09.00 – 09.30 WIB', 'Pengantar KMP',
          'Konsep dan ekosistem Kotlin Multiplatform.'),
      RundownItem('09.30 – 10.30 WIB', 'Shared Module',
          'Struktur proyek, expect/actual, dan modul bersama.'),
      RundownItem('10.30 – 10.45 WIB', 'Break', 'Rehat dan networking.'),
      RundownItem('10.45 – 12.00 WIB', 'Hands-on',
          'Berbagi logika bisnis antara Android dan iOS.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Contoh Proyek KMP', 'Repo contoh siap dijalankan.'),
    ],
  ),
  EventItem(
    id: 'e5',
    title: 'Smart Campus dengan ESP32 & MQTT',
    category: 'IoT',
    speaker: 'Ir. Hafiz Hartono, M.T.',
    venue: 'IoT Lab',
    time: '08.00 – 15.00 WIB',
    description:
        'Merancang sistem monitoring ruangan berbasis sensor, ESP32, dan protokol MQTT.',
    startDate: DateTime(2026, 11, 28),
    endDate: DateTime(2026, 11, 29),
    price: 90000,
    quota: 40,
    registered: 36,
    icon: Icons.developer_board_rounded,
    gradient: const [Color(0xFF56AB2F), Color(0xFFA8E063)],
    image: 'assets/images/kode1.jpg',
    organizer: 'Komunitas IoT Kampus',
    speakerRole: 'Dosen Teknik Elektro & Konsultan Embedded',
    speakerTag: 'Embedded Systems',
    speakerBio:
        'Berpengalaman merancang sistem monitoring berbasis mikrokontroler untuk lingkungan kampus dan industri kecil.',
    details: [
      'Workshop dua hari untuk membangun sistem monitoring ruangan (suhu, kelembapan, dan kehadiran) dengan ESP32 dan protokol MQTT.',
      'Peserta merakit perangkat, mengirim data ke broker MQTT, lalu menampilkannya pada dashboard sederhana.',
    ],
    prerequisite:
        'Laptop dengan Arduino IDE atau PlatformIO. Komponen praktik disediakan panitia.',
    locationNote:
        'IoT Lab berada di sisi timur, di bawah Workshop B. Ikuti papan penunjuk Lab.',
    rundown: [
      RundownItem('08.00 – 09.00 WIB', 'Registrasi & Pengenalan ESP32',
          'Check-in dan pembagian perangkat praktik.'),
      RundownItem('09.00 – 11.30 WIB', 'Sensor & Wiring',
          'Merakit sensor dan membaca data dari ESP32.'),
      RundownItem('11.30 – 12.30 WIB', 'Ishoma', 'Istirahat, sholat, dan makan siang.'),
      RundownItem('12.30 – 15.00 WIB', 'MQTT & Dashboard',
          'Mengirim data ke broker dan membangun dashboard monitoring.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Kit Perangkat Praktik', 'ESP32 dan sensor dipinjamkan selama acara.'),
      FacilityItem('Makan Siang', 'Disediakan setiap hari pelaksanaan.'),
    ],
  ),
  EventItem(
    id: 'e6',
    title: 'Sensor & Edge Computing untuk Pertanian',
    category: 'IoT',
    speaker: 'Salsabila Davidya, S.T.',
    venue: 'IoT Lab',
    time: '10.00 – 14.00 WIB',
    description:
        'Studi kasus smart farming: pengolahan data sensor di perangkat edge.',
    startDate: DateTime(2026, 12, 12),
    endDate: DateTime(2026, 12, 12),
    price: 40000,
    quota: 50,
    registered: 12,
    icon: Icons.eco_rounded,
    gradient: const [Color(0xFF0BA360), Color(0xFF3CBA92)],
    image: 'assets/images/kode2.jpg',
    organizer: 'Komunitas IoT Kampus',
    speakerRole: 'Engineer Smart Farming',
    speakerTag: 'Agritech',
    speakerBio:
        'Mengembangkan solusi sensor tanah dan irigasi otomatis untuk lahan pertanian skala kecil.',
    details: [
      'Pelajari bagaimana data sensor kelembapan tanah, suhu, dan cuaca diolah langsung di perangkat edge agar keputusan irigasi bisa cepat dan hemat daya.',
      'Dilengkapi studi kasus smart farming dan demo perangkat nyata.',
    ],
    prerequisite: 'Tidak ada prasyarat khusus. Membawa laptop disarankan.',
    locationNote: 'IoT Lab berada di sisi timur gedung, dekat Workshop B.',
    rundown: [
      RundownItem('10.00 – 10.30 WIB', 'Pengantar Smart Farming',
          'Tantangan dan peluang teknologi di pertanian.'),
      RundownItem('10.30 – 12.00 WIB', 'Akuisisi Data Sensor',
          'Membaca dan merekam data sensor lapangan.'),
      RundownItem('12.00 – 13.00 WIB', 'Ishoma', 'Istirahat, sholat, dan makan siang.'),
      RundownItem('13.00 – 14.00 WIB', 'Edge Processing',
          'Demo pengolahan data pada perangkat edge.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Demo Perangkat Nyata', 'Peserta dapat mencoba perangkat langsung.'),
    ],
  ),
  EventItem(
    id: 'e7',
    title: 'Ethical Hacking & Web Security Basics',
    category: 'Cybersecurity',
    speaker: 'Rizky Adelard, CEH',
    venue: 'Main Hall',
    time: '09.00 – 15.00 WIB',
    description:
        'OWASP Top 10, simulasi serangan web, dan teknik pertahanan dasar.',
    startDate: DateTime(2026, 11, 25),
    endDate: DateTime(2026, 11, 25),
    price: 60000,
    quota: 120,
    registered: 104,
    icon: Icons.bug_report_rounded,
    gradient: const [Color(0xFFFF512F), Color(0xFFDD2476)],
    image: 'assets/images/kode3.jpg',
    organizer: 'Cyber Security Club Kampus',
    speakerRole: 'Penetration Tester',
    speakerTag: 'Certified Ethical Hacker',
    speakerBio:
        'Melakukan pengujian keamanan aplikasi web untuk berbagai organisasi dan rutin berbagi pengetahuan keamanan di komunitas.',
    details: [
      'Kenali sepuluh risiko keamanan web paling umum menurut OWASP Top 10 dan lihat bagaimana serangan disimulasikan di lingkungan lab yang aman.',
      'Seluruh praktik dilakukan pada target latihan yang legal. Peserta wajib mematuhi kode etik selama acara.',
    ],
    prerequisite: 'Laptop dengan browser modern. Pengetahuan dasar web membantu.',
    locationNote: 'Main Hall berada di sisi barat. Masuk lewat Lobby lalu lurus.',
    rundown: [
      RundownItem('09.00 – 09.30 WIB', 'Registrasi & Kode Etik',
          'Check-in dan penjelasan aturan praktik yang aman.'),
      RundownItem('09.30 – 11.30 WIB', 'OWASP Top 10',
          'Memahami risiko utama keamanan aplikasi web.'),
      RundownItem('11.30 – 12.30 WIB', 'Ishoma', 'Istirahat, sholat, dan makan siang.'),
      RundownItem('12.30 – 15.00 WIB', 'Simulasi Serangan & Pertahanan',
          'Praktik pada target latihan dan teknik mitigasi dasar.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Akses Lab Latihan', 'Akun lingkungan praktik selama acara.'),
      FacilityItem('Makan Siang', 'Disediakan untuk seluruh peserta.'),
    ],
  ),
  EventItem(
    id: 'e8',
    title: 'Digital Forensics & Incident Response',
    category: 'Cybersecurity',
    speaker: 'Dewi Qeiza, M.Sc.',
    venue: 'Workshop A',
    time: '13.00 – 17.00 WIB',
    description:
        'Investigasi insiden siber: akuisisi bukti, analisis log, dan pelaporan.',
    startDate: DateTime(2026, 12, 19),
    endDate: DateTime(2026, 12, 19),
    price: 45000,
    quota: 60,
    registered: 18,
    icon: Icons.shield_moon_rounded,
    gradient: const [Color(0xFFF7971E), Color(0xFFFF5E62)],
    image: 'assets/images/kode4.jpg',
    organizer: 'Cyber Security Club Kampus',
    speakerRole: 'Digital Forensics Analyst',
    speakerTag: 'Incident Response',
    speakerBio:
        'Menangani investigasi insiden siber dan membantu organisasi menyusun prosedur respons insiden.',
    details: [
      'Pelajari alur investigasi insiden siber dari pengamanan bukti digital, akuisisi data, analisis log, sampai penyusunan laporan.',
      'Sesi diisi studi kasus insiden dan latihan analisis log secara langsung.',
    ],
    prerequisite: 'Laptop dengan minimal 8 GB RAM. Dasar jaringan membantu.',
    locationNote: 'Workshop A berada di sisi timur Main Hall.',
    rundown: [
      RundownItem('13.00 – 13.30 WIB', 'Registrasi',
          'Check-in tiket dan persiapan perangkat.'),
      RundownItem('13.30 – 14.45 WIB', 'Akuisisi Bukti Digital',
          'Menjaga integritas bukti dan teknik akuisisi.'),
      RundownItem('14.45 – 15.00 WIB', 'Break', 'Rehat singkat dan snack.'),
      RundownItem('15.00 – 17.00 WIB', 'Analisis Log & Pelaporan',
          'Menganalisis log insiden dan menyusun laporan temuan.'),
    ],
    facilities: [
      ..._baseFacilities,
      FacilityItem('Template Laporan Insiden', 'Format laporan siap pakai.'),
    ],
  ),
];