import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poliwangi_mobile_starter/modul_03/models/krs_course.dart';
import 'package:poliwangi_mobile_starter/modul_03/providers/krs_provider.dart';
import 'package:poliwangi_mobile_starter/modul_03/screens/krs_list_screen.dart';
import 'package:poliwangi_mobile_starter/modul_03/screens/add_krs_screen.dart';
import 'package:poliwangi_mobile_starter/modul_03/screens/course_detail_screen.dart';

void main() {
  group(
      'Modul 03 Autograding: Navigation & State Management (Riverpod + GoRouter)',
      () {
    test(
        '1. KrsNotifier mengelola state secara immutable, mencegah duplikasi & menghitung SKS',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(krsProvider.notifier);

      // State awal
      expect(container.read(krsProvider).length, greaterThanOrEqualTo(3));
      final initialSks = notifier.totalSks;
      expect(initialSks, greaterThan(0));

      // Tambah mata kuliah baru
      const newCourse = KrsCourse(
        code: 'TEST901',
        name: 'Pengujian Perangkat Lunak',
        lecturer: 'Dosen Penguji',
        sks: 3,
      );
      final success = notifier.tambahMataKuliah(newCourse);
      expect(success, isTrue);
      expect(
          container.read(krsProvider).any((c) => c.code == 'TEST901'), isTrue);
      expect(notifier.totalSks, equals(initialSks + 3));

      // Coba tambah kode duplikat (harus ditolak)
      final duplicateSuccess = notifier.tambahMataKuliah(newCourse);
      expect(duplicateSuccess, isFalse);

      // Hapus mata kuliah
      notifier.hapusMataKuliah('TEST901');
      expect(
          container.read(krsProvider).any((c) => c.code == 'TEST901'), isFalse);
      expect(notifier.totalSks, equals(initialSks));
    });

    testWidgets(
        '2. KrsListScreen merender judul, badge SKS, dan daftar mata kuliah dengan ProviderScope',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: KrsListScreen(),
          ),
        ),
      );

      // Verifikasi AppBar & Badge SKS
      expect(find.text('Rencana Studi (KRS) TRPL'), findsOneWidget);
      expect(find.textContaining('SKS'), findsWidgets);

      // Verifikasi Kartu Mata Kuliah Ter-render
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
        '3. AddKrsScreen memvalidasi input wajib pada form menggunakan GlobalKey',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddKrsScreen(),
          ),
        ),
      );

      // Verifikasi judul form
      expect(find.text('Tambah Mata Kuliah KRS'), findsOneWidget);

      // Cari tombol simpan dan klik tanpa mengisi input
      final simpanButton = find.text('Simpan ke Rencana Studi');
      expect(simpanButton, findsOneWidget);

      await tester.tap(simpanButton);
      await tester.pumpAndSettle();

      // Verifikasi pesan error validasi muncul
      expect(find.text('Kode mata kuliah wajib diisi'), findsOneWidget);
      expect(find.text('Nama mata kuliah wajib diisi'), findsOneWidget);
    });

    testWidgets(
        '4. CourseDetailScreen mendukung simulasi Error State & Tombol Coba Lagi',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CourseDetailScreen(courseCode: 'TRPL501'),
          ),
        ),
      );

      // Tampilan awal (Success State)
      expect(find.text('Pemrograman Perangkat Bergerak'), findsOneWidget);
      expect(find.text('3 SKS'), findsOneWidget);

      // Pemicu tombol simulasi error
      final bugIcon = find.byIcon(Icons.bug_report);
      expect(bugIcon, findsOneWidget);

      await tester.tap(bugIcon);
      await tester.pump();

      // Verifikasi Error State & Tombol Retry muncul
      expect(find.text('Gagal Mengambil Data Silabus'), findsOneWidget);
      expect(find.text('Coba Lagi (Retry)'), findsOneWidget);
    });
  });
}
