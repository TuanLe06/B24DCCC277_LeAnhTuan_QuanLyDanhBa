import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/contact_repository.dart';
import '../models/contact.dart';

/// Màn hình thêm liên hệ mới.
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  static const List<String> _groups = ['Gia đình', 'Bạn bè', 'Công việc', 'Khác'];
  static const List<String> _genders = ['Nam', 'Nữ', 'Khác'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ContactRepository _repository = ContactRepository.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _group = _groups.first;
  String _gender = 'Nam'; // mặc định Nam
  bool _isFavorite = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Họ và tên không được để trống';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Vui lòng nhập số điện thoại';
    // Đúng 10 chữ số và bắt đầu bằng 0
    if (!RegExp(r'^0\d{9}$').hasMatch(phone)) {
      return 'Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 0';
    }
    // Không cho trùng số đã có
    if (_repository.isPhoneExists(phone)) {
      return 'Số điện thoại đã tồn tại';
    }
    return null;
  }

  void _save() {
    // validate() gọi các validator và hiện lỗi dưới từng ô nhập
    if (!_formKey.currentState!.validate()) return;

    final contact = Contact(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      group: _group,
      gender: _gender,
      isFavorite: _isFavorite,
      note: _noteController.text.trim(),
    );
    _repository.add(contact);
    // Quay về danh sách, MainScreen sẽ setState để cập nhật
    Navigator.pop(context, contact);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm liên hệ'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  // Chỉ cho nhập chữ số
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _group,
                  decoration: const InputDecoration(
                    labelText: 'Nhóm',
                    prefixIcon: Icon(Icons.group),
                  ),
                  items: _groups
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _group = value);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.w600)),
                // RadioGroup quản lý giá trị đang chọn cho 3 Radio bên trong
                RadioGroup<String>(
                  groupValue: _gender,
                  onChanged: (value) {
                    if (value != null) setState(() => _gender = value);
                  },
                  child: Wrap(
                    children: [
                      for (final g in _genders)
                        InkWell(
                          onTap: () => setState(() => _gender = g),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(value: g),
                              Text(g),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Yêu thích'),
                  value: _isFavorite,
                  onChanged: (value) => setState(() => _isFavorite = value ?? false),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú (không bắt buộc)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu liên hệ'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
