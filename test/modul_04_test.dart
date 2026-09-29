import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../lib/modul_04/models/announcement.dart';
import '../lib/modul_04/modul_04_app.dart';
import '../lib/modul_04/screens/announcement_list_screen.dart';
import '../lib/modul_04/services/announcement_api.dart';

List<Map<String, dynamic>> _payload({
  int jumlah = 10,
}) {
  return List<Map<String, dynamic>>.generate(
    jumlah,
    (int index) => <String, dynamic>{
      'id': index + 1,
      'title': 'Pengumuman ${index + 1}',
      'body': 'Isi pengumuman ${index + 1}',
    },
  );
}

Widget _buildApp(AnnouncementApi api) {
  return MaterialApp(
    home: AnnouncementListScreen(
      api: api,
    ),
  );
}

void main() {
  group('Modul 04 Fase A', () {
    test(
      '1. Model memiliki fallback dariJson',
      () {
        final Announcement announcement =
            Announcement.fromJson(
          <String, dynamic>{
            'id': '5',
          },
        );

        expect(announcement.id, 5);
        expect(
          announcement.title,
          'Tanpa Judul',
        );
        expect(
          announcement.author,
          'Admin Jurusan',
        );
        expect(
          announcement.category,
          'Akademik',
        );
      },
    );

    test(
      '2. GET mengambil sepuluh data',
      () async {
        final MockClient client = MockClient(
          (_) async => http.Response(
            jsonEncode(_payload()),
            200,
            headers: <String, String>{
              'content-type': 'application/json',
            },
          ),
        );

        final AnnouncementApi api =
            AnnouncementApi(
          client: client,
        );

        final List<Announcement> data =
            await api.ambilPengumuman();

        expect(data, hasLength(10));
        expect(
          data.first.title,
          'Pengumuman 1',
        );
      },
    );

    test(
      '3. Status selain 200 menghasilkan error',
      () async {
        final MockClient client = MockClient(
          (_) async => http.Response(
            'Server error',
            500,
          ),
        );

        final AnnouncementApi api =
            AnnouncementApi(
          client: client,
        );

        expect(
          api.ambilPengumuman(),
          throwsException,
        );
      },
    );

    testWidgets(
      '4. Menampilkan loading state',
      (WidgetTester tester) async {
        final MockClient client = MockClient(
          (_) async {
            await Future<void>.delayed(
              const Duration(milliseconds: 100),
            );

            return http.Response(
              jsonEncode(_payload()),
              200,
            );
          },
        );

        await tester.pumpWidget(
          _buildApp(
            AnnouncementApi(client: client),
          ),
        );

        expect(
          find.text(
            'Memuat pengumuman dari server...',
          ),
          findsOneWidget,
        );

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      '5. Error state memiliki tombol Coba Lagi',
      (WidgetTester tester) async {
        int requestCount = 0;

        final MockClient client = MockClient(
          (_) async {
            requestCount++;

            return http.Response(
              'error',
              500,
            );
          },
        );

        await tester.pumpWidget(
          _buildApp(
            AnnouncementApi(client: client),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Gagal Memuat Data'),
          findsOneWidget,
        );

        expect(
          find.text('Coba Lagi'),
          findsOneWidget,
        );

        await tester.tap(
          find.text('Coba Lagi'),
        );

        await tester.pumpAndSettle();

        expect(requestCount, 2);
      },
    );

    testWidgets(
      '6. Filter kategori tidak membuat request baru',
      (WidgetTester tester) async {
        int requestCount = 0;

        final MockClient client = MockClient(
          (_) async {
            requestCount++;

            return http.Response(
              jsonEncode(
                <Map<String, dynamic>>[
                  <String, dynamic>{
                    'id': 1,
                    'title': 'Beasiswa',
                    'body': 'Isi beasiswa',
                  },
                ],
              ),
              200,
            );
          },
        );

        await tester.pumpWidget(
          _buildApp(
            AnnouncementApi(client: client),
          ),
        );

        await tester.pumpAndSettle();

        expect(requestCount, 1);

        await tester.tap(
          find.text('Beasiswa'),
        );

        await tester.pumpAndSettle();

        expect(requestCount, 1);

        expect(
          find.text(
            'Beasiswa',
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      '7. Kartu dapat membuka layar detail',
      (WidgetTester tester) async {
        final MockClient client = MockClient(
          (_) async => http.Response(
            jsonEncode(
              _payload(jumlah: 1),
            ),
            200,
            headers: <String, String>{
              'content-type': 'application/json',
            },
          ),
        );

        await tester.pumpWidget(
          _buildApp(
            AnnouncementApi(client: client),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Pengumuman 1'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Detail Pengumuman'),
          findsOneWidget,
        );

        expect(
          find.text('Isi pengumuman 1'),
          findsOneWidget,
        );

        await tester.pageBack();

        await tester.pumpAndSettle();

        expect(
          find.text('Portal Pengumuman TRPL'),
          findsOneWidget,
        );
      },
    );
  });
}