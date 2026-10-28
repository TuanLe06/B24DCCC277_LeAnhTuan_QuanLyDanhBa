/// Model một liên hệ trong danh bạ.
class Contact {
  final String fullName;
  final String phone;
  final String group;
  final String gender;
  final String note;

  /// Trạng thái yêu thích - có thể thay đổi sau khi tạo.
  bool isFavorite;

  Contact({
    required this.fullName,
    required this.phone,
    required this.group,
    required this.gender,
    required this.isFavorite,
    required this.note,
  });
}
