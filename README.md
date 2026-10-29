# NusaEvent Hub

Aplikasi Flutter untuk menampilkan seminar dan workshop kampus, melihat detail acara, melihat galeri poster dan denah venue, serta mendaftar dan mengelola tiket digital.
Proyek ini dibuat untuk **Tugas 05 – Sesi 5**.

## Identitas

| | |
| Nama | Syifa Nurul Afifah |
| NIM | 20240040286 |

## Demo Aplikasi
https://youtu.be/q4VFIg5xYpY

## Fitur

### 1. Seminar & Workshop
- Daftar seminar dengan kartu interaktif (`InkWell`).
- Pencarian berdasarkan judul, pembicara, kategori, dan venue.
- Filter kategori: **AI, Mobile, IoT, Cybersecurity** (lewat chip dan bottom sheet).
- Urutkan berdasarkan **Terdekat** atau **Populer**.
- Carousel **Event Unggulan** berdasarkan tingkat keterisian kursi.
- Indikator status kuota: Dibuka, Sisa kursi, Penuh.

### 2. Detail Acara
Halaman yang tampil sebelum pendaftaran, dengan empat tab:
- **Tentang**: deskripsi lengkap dan prasyarat.
- **Pembicara**: nama, jabatan, dan bio.
- **Rundown**: timeline sesi acara.
- **Fasilitas**: benefit untuk peserta.

### 3. Galeri & Denah Venue
- Galeri poster dengan `GridView.builder`, bisa difilter per kategori.
- Poster mendukung gambar sendiri (`assets/images/`), dengan fallback gradien dan ikon.
- Denah venue interaktif dengan `InteractiveViewer` (geser dan zoom 1x–5x).
- Ruangan bisa diketuk untuk melihat detail dan acara yang berlangsung di sana.

### 4. Pendaftaran Tiket
- Formulir dengan `GlobalKey<FormState>` dan validasi:
  - Nama (minimal 3 huruf)
  - NIM (8–12 digit angka)
  - Email (format valid)
  - WhatsApp (format `08xx` / `+628xx`)
- Pilihan tipe peserta, tanggal kehadiran (`showDatePicker`), paket seminar kit, donasi, dan persetujuan tata tertib.
- Rincian pembayaran otomatis.
- Indikator loading dan `SnackBar` setelah pendaftaran berhasil.
- Pencegahan pendaftaran ganda untuk acara yang sama.

### 5. Tiket Saya
- Daftar tiket aktif dan selesai.
- Pembatalan tiket dengan **geser ke kiri** (`Dismissible`) dan dialog konfirmasi (`AlertDialog`).
- E-tiket dengan QR code simulasi.

## Struktur Folder

```
tugas_sesi_5/
├── assets/
│   └── images/               # gambar poster acara
├── lib/
│   ├── models/
│   │   ├── event_item.dart
│   │   └── registration_ticket.dart
│   ├── data/
│   │   └── sample_events.dart
│   ├── widgets/
│   │   ├── event_card.dart
│   │   ├── filter_bottom_sheet.dart
│   │   ├── venue_map_viewer.dart
│   │   ├── glass_container.dart
│   │   └── app_background.dart
│   ├── screens/
│   │   ├── home_events_screen.dart
│   │   ├── event_detail_screen.dart
│   │   ├── event_registration_screen.dart
│   │   └── registered_tickets_screen.dart
│   ├── utils/
│   │   └── format.dart
│   └── main.dart
└── pubspec.yaml
```

## Teknologi

- Flutter dengan **Material 3**
- Dart SDK `^3.6.0`
- Tema gelap dengan efek glassmorphism (`BackdropFilter`)
- Tanpa package eksternal selain bawaan Flutter

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terpasang:
   ```bash
   flutter doctor
   ```
2. Ambil dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan di emulator atau perangkat:
   ```bash
   flutter run
   ```

## Data Contoh

Data acara berasal dari `lib/data/sample_events.dart` (8 acara di 4 kategori). Aplikasi ini tidak memakai backend: tiket disimpan di memori dan hilang ketika aplikasi ditutup.
