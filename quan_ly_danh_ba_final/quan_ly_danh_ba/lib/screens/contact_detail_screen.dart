import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/contact_repository.dart';
import '../models/contact.dart';
import '../widgets/avatar_initial.dart';

/// Màn hình chi tiết liên hệ. Nhận Contact và index qua constructor.
class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  final int index;

  const ContactDetailScreen({
    super.key,
    required this.contact,
    required this.index,
  });

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final ContactRepository _repository = ContactRepository.instance;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Mở màn hình quay số bằng url_launcher.
  Future<void> _callPhone() async {
    final uri = Uri(scheme: 'tel', path: widget.contact.phone);
    try {
      final opened = await launchUrl(uri);
      if (!opened && mounted) {
        _showMessage('Không thể mở màn hình quay số');
      }
    } catch (_) {
      // Thiết bị không hỗ trợ (máy ảo, máy tính bảng không có SIM...)
      if (mounted) _showMessage('Không thể mở màn hình quay số');
    }
  }

  /// Hỏi xác nhận rồi xóa liên hệ.
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa liên hệ'),
        content: Text('Bạn có chắc muốn xóa "${widget.contact.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _repository.removeAt(widget.index);
      // Quay về danh sách, MainScreen sẽ cập nhật thống kê
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    final scheme = Theme.of(context).colorScheme;
    final note = contact.note.trim().isEmpty ? 'Không có ghi chú' : contact.note;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết liên hệ'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: AvatarInitial(name: contact.fullName, radius: 44)),
              const SizedBox(height: 12),
              Text(
                contact.fullName,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(contact.phone),
                      subtitle: const Text('Số điện thoại'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(contact.group),
                      subtitle: const Text('Nhóm'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.wc),
                      title: Text(contact.gender),
                      subtitle: const Text('Giới tính'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.notes),
                      title: Text(note),
                      subtitle: const Text('Ghi chú'),
                    ),
                  ],
                ),
              ),
              // Đổi trạng thái được lưu thẳng vào đối tượng trong danh sách
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Yêu thích'),
                value: contact.isFavorite,
                onChanged: (value) {
                  setState(() => contact.isFavorite = value ?? false);
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _callPhone,
                icon: const Icon(Icons.call),
                label: const Text('Gọi điện'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _confirmDelete,
                icon: Icon(Icons.delete, color: scheme.error),
                label: Text('Xóa liên hệ', style: TextStyle(color: scheme.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
