import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/announcement_api.dart';
import '../widgets/announcement_card.dart';
import 'announcement_detail_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({
    super.key,
    this.api,
  });

  /// Dapat disuntikkan dari luar untuk widget test atau demo offline.
  final AnnouncementApi? api;

  @override
  State<AnnouncementListScreen> createState() =>
      _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  static const List<String> _kategori = <String>[
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  late final AnnouncementApi _api = widget.api ?? AnnouncementApi();

  late Future<List<Announcement>> _futurePengumuman;

  String _kategoriTerpilih = 'Semua';

  @override
  void initState() {
    super.initState();

    // Future dibuat sekali saat State pertama kali dibuat.
    _futurePengumuman = _api.ambilPengumuman();
  }

  @override
  void dispose() {
    _api.tutup();
    super.dispose();
  }

  Future<void> _muatUlang() async {
    final Future<List<Announcement>> futureBaru =
        _api.ambilPengumuman();

    setState(() {
      _futurePengumuman = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error sudah ditangani FutureBuilder melalui snapshot.hasError.
      // Catch ini mencegah exception tidak tertangani saat refresh.
    }
  }

  void _pilihKategori(String kategori) {
    if (kategori == _kategoriTerpilih) {
      return;
    }

    setState(() {
      _kategoriTerpilih = kategori;
    });
  }

  void _bukaDetail(Announcement announcement) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AnnouncementDetailScreen(
          announcement: announcement,
        ),
      ),
    );
  }

  Widget _buildMemuat() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Memuat pengumuman dari server...',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGagal(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_rounded,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString().replaceFirst(
                    'Exception: ',
                    '',
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosong() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.inbox_outlined,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pengumuman untuk kategori '
              '"$_kategoriTerpilih".',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaftar(List<Announcement> items) {
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Announcement item = items[index];

          return AnnouncementCard(
            announcement: item,
            onTap: () => _bukaDetail(item),
          );
        },
      ),
    );
  }

  Widget _buildBarisFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: _kategori.map((String kategori) {
          final bool terpilih =
              kategori == _kategoriTerpilih;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(kategori),
              selected: terpilih,
              onSelected: (bool selected) {
                if (selected) {
                  _pilihKategori(kategori);
                }
              },
            ),
          );
        }).toList(growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portal Pengumuman TRPL',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildBarisFilter(),

          const Divider(height: 1),

          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _futurePengumuman,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Announcement>> snapshot,
              ) {
                // 1. STATE LOADING
                if (snapshot.connectionState !=
                    ConnectionState.done) {
                  return _buildMemuat();
                }

                // 2. STATE ERROR
                if (snapshot.hasError) {
                  return _buildGagal(
                    snapshot.error!,
                  );
                }

                // Data yang berhasil diterima.
                final List<Announcement> semua =
                    snapshot.data ??
                        const <Announcement>[];

                // Filter dilakukan di build menggunakan where().
                final List<Announcement> tampil =
                    _kategoriTerpilih == 'Semua'
                        ? semua
                        : semua
                            .where(
                              (Announcement item) =>
                                  item.category.toLowerCase() ==
                                  _kategoriTerpilih.toLowerCase(),
                            )
                            .toList(
                              growable: false,
                            );

                // 3. STATE EMPTY
                if (tampil.isEmpty) {
                  return _buildKosong();
                }

                // 4. STATE SUCCESS
                return _buildDaftar(tampil);
              },
            ),
          ),
        ],
      ),
    );
  }
}