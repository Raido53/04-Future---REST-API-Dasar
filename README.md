# Starter Template & Laporan Praktikum Pemrograman Mobile
### Program Studi Sarjana Terapan Teknologi Rekayasa Perangkat Lunak (TRPL)
**Politeknik Negeri Banyuwangi — Semester Ganjil 2026**

Panduan interaktif lengkap: [Portal Codelabs TRPL Poliwangi](https://codelabs-poliwangi.github.io/MobileDev-Codelabs/)

---

## 1. Identitas Mahasiswa

> [!IMPORTANT]
> **Wajib Mengganti Data di Bawah Ini!**  
> Lengkapi data ini sebelum mengumpulkan tautan repositori dan bukti praktik. Pengujian `verify_documentation_test.dart` membantu memeriksa placeholder secara lokal; dosen tetap memverifikasi identitas serta bukti kerja pada repositori.

| Informasi | Data Mahasiswa |
|---|---|
| **Nama Lengkap** | Mahasiswa TRPL Poliwangi *(Ganti dengan Nama Lengkap Anda)* |
| **NIM** | 362458302000 *(Ganti dengan NIM Asli Anda)* |
| **Kelas / Angkatan** | TRPL 5A / 2024 |
| **Dosen Pengampu** | Sepyan Purnama Kristanto, M.Kom. |

---

## 2. Peta Kemajuan Modul Praktikum

Aplikasi starter memuat contoh layar setiap modul. Gunakan tabel ini sebagai peta kerja dan jalankan self-test lokal sebelum mengumpulkan repositori:

| Modul | Topik & Arsitektur | Perintah Self-Test Lokal |
|:---:|---|:---:|---|:---:|
| **#01** | Mobile Ecosystem, Toolchain & Profile App | `flutter test test/modul_01_test.dart` |
| **#02** | Declarative UI, BoxConstraints & Responsive Dashboard | `flutter test test/modul_02_test.dart` |
| **#03** | Navigation (go_router), Riverpod & 4-State KRS App | `flutter test test/modul_03_test.dart` |
| **#04** | Networking, REST API Dio & Repository Pattern | `flutter test test/modul_04_test.dart` |
| **Dok** | Verifikasi identitas dan laporan | `flutter test test/verify_documentation_test.dart` |
| **Semua** | Analisis statis dan seluruh test | `flutter analyze && flutter test` |

> [!NOTE]
> Penguncian tampilan pada starter hanya alat bantu alur belajar di kelas, bukan mekanisme keamanan atau penilaian. Gunakan instruksi pertemuan dan bukti commit/README sebagai dasar pengumpulan.

---

## 3. Panduan Menjalankan & Menguji Kode

### A. Persiapan Lingkungan (Setup)
```bash
# 1. Unduh seluruh dependensi paket Flutter
flutter pub get

# 2. Jalankan aplikasi pada emulator atau perangkat fisik Android/iOS/Web
flutter run
```

### B. Pengujian Mandiri Sebelum Push (Self-Testing)
Sebelum mengumpulkan tautan repositori tugas, pastikan seluruh pengujian lulus di mesin lokal:

```bash
# 1. Periksa aturan kode linter Dart
flutter analyze

# 2. Jalankan unit & widget test modul yang sedang Anda kerjakan
flutter test test/modul_01_test.dart
flutter test test/modul_02_test.dart

# 3. Jalankan seluruh test suite sekaligus
flutter test
```

---

## 4. Konvensi Pesan Commit (Conventional Commits)

Mahasiswa **wajib** menggunakan format pesan commit terstruktur:
- `feat(w01): complete profile screen and identity info card`
- `feat(w02): implement layoutbuilder responsive grid for tablet`
- `fix(w02): resolve renderflex overflow in course card`
- `feat(w03): setup gorouter declarative routes and krs notifier`
- `feat(w04): integrate dio remote datasource and repository pattern`
- `docs(readme): update student identity and ai reflection table`

---

## 5. Catatan Penggunaan AI (Responsible AI Disclosure)

Sesuai prinsip **Responsible AI** di lingkungan akademik Politeknik Negeri Banyuwangi, mahasiswa diperbolehkan menggunakan AI coding assistant (GitHub Copilot, Gemini Code Assist, ChatGPT) sebagai akselerator belajar, dengan kewajiban mencatat penggunaannya secara transparan pada tabel berikut:

| Modul / File Kode | Alat AI yang Digunakan | Tujuan Penggunaan | Validasi Teknis yang Dilakukan Mahasiswa |
|---|---|---|---|
| *Contoh: lib/modul_02/widgets/course_card.dart* | *GitHub Copilot* | *Saran styling Elevation & BoxDecoration* | *Memeriksa contrast ratio WCAG AA dan padding antarmuka* |
| *Contoh: lib/modul_04/models/announcement.dart* | *Gemini Code Assist* | *Pengecekan null-safety pada fromJson* | *Menambahkan fallback default string kosong untuk mencegah error runtime* |

---

*Hak Cipta © 2026 Jurusan Bisnis dan Informatika (JBI), Politeknik Negeri Banyuwangi.*
