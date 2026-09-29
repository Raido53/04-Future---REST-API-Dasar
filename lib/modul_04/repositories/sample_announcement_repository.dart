import '../models/announcement.dart';
import 'announcement_repository.dart';

/// Sumber data lokal untuk demo tanpa internet dan widget test.
/// Ini bukan cache produksi dan tidak menggantikan remote repository.
class SampleAnnouncementRepository implements AnnouncementRepository {
  final List<Announcement> _items = Announcement.getSampleAnnouncements();

  @override
  Future<List<Announcement>> getAnnouncements({String? category}) async {
    final items = List<Announcement>.unmodifiable(_items);
    if (category == null || category == 'Semua') return items;

    return items
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList(growable: false);
  }

  @override
  Future<Announcement> addAnnouncement(Announcement announcement) async {
    _items.add(announcement);
    return announcement;
  }
}
