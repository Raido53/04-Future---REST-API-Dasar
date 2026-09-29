import 'package:dio/dio.dart';
import '../models/announcement.dart';

// Remote Data Source: Menangani panggilan langsung ke REST API via HTTP Dio
class AnnouncementRemoteDataSource {
  final Dio _dio;

  AnnouncementRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://jsonplaceholder.typicode.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Accept': 'application/json',
                  'User-Agent': 'PoliwangiMobileApp/1.0',
                },
              ),
            ) {
    // Menambahkan Interceptor untuk logging request/response saat debug
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  // Mengambil daftar pengumuman dari REST API
  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final response = await _dio.get('/posts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        // Mengonversi response API menjadi list model Announcement
        // Kita ambil 10 data teratas dan sesuaikan dengan kategori kampus
        final categories = ['Akademik', 'Beasiswa', 'Kegiatan', 'Prestasi'];
        return data.take(10).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value as Map<String, dynamic>;

          return Announcement(
            id: item['id'] as int? ?? (index + 1),
            title: item['title'] as String? ?? 'Pengumuman Kampus',
            content: item['body'] as String? ?? 'Konten pengumuman akademik.',
            author: 'Bagian Akademik Poliwangi',
            category: categories[index % categories.length],
            date: '2026-09-${(index % 28 + 1).toString().padLeft(2, '0')}',
            readCount: (index + 1) * 37,
          );
        }).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Server merespons dengan status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Jika error koneksi atau timeout, lemparkan kembali untuk ditangani repository
      rethrow;
    }
  }

  // Mengirim pengumuman baru (HTTP POST)
  Future<Announcement> createAnnouncement(Announcement announcement) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: announcement.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return announcement;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Gagal membuat pengumuman baru',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
