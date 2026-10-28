import '../models/contact.dart';

/// Kho dữ liệu dùng chung (singleton), giữ danh sách liên hệ trong bộ nhớ.
class ContactRepository {
  ContactRepository._internal();

  /// Thể hiện duy nhất của repository.
  static final ContactRepository instance = ContactRepository._internal();

  /// factory để ContactRepository() cũng trả về cùng một thể hiện.
  factory ContactRepository() => instance;

  // Danh sách liên hệ, khởi tạo sẵn 3 dữ liệu mẫu
  final List<Contact> _contacts = [
    Contact(
      fullName: 'Nguyễn Văn An',
      phone: '0901234567',
      group: 'Bạn bè',
      gender: 'Nam',
      isFavorite: false,
      note: '',
    ),
    Contact(
      fullName: 'Trần Thị Bình',
      phone: '0912345678',
      group: 'Gia đình',
      gender: 'Nữ',
      isFavorite: true,
      note: '',
    ),
    Contact(
      fullName: 'Lê Minh Châu',
      phone: '0987654321',
      group: 'Công việc',
      gender: 'Nam',
      isFavorite: false,
      note: '',
    ),
  ];

  /// Lấy toàn bộ danh sách (chỉ đọc, thêm/xóa phải qua repository).
  /// Các phần tử Contact vẫn là đối tượng gốc nên đổi isFavorite có hiệu lực.
  List<Contact> getAll() => List<Contact>.unmodifiable(_contacts);

  /// Thêm một liên hệ mới.
  void add(Contact contact) {
    _contacts.add(contact);
  }

  /// Xóa liên hệ theo vị trí; bỏ qua nếu index không hợp lệ.
  void removeAt(int index) {
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
    }
  }

  /// Kiểm tra số điện thoại đã tồn tại chưa.
  bool isPhoneExists(String phone) {
    return _contacts.any((c) => c.phone == phone);
  }

  /// Tổng số liên hệ.
  int countAll() => _contacts.length;

  /// Số liên hệ yêu thích.
  int countFavorites() => _contacts.where((c) => c.isFavorite).length;
}
