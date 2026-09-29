import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dokumentasi starter', () {
    test('1. File README.md menyediakan bagian identitas dan self-test', () {
      final file = File('README.md');
      expect(file.existsSync(), isTrue,
          reason: 'File README.md wajib ada di root repositori.');

      final content = file.readAsStringSync();

      expect(content, contains('## 1. Identitas Mahasiswa'));
      expect(content, contains('## 3. Panduan Menjalankan & Menguji Kode'));
      expect(content, contains('flutter test'));
    });
  });
}
