import 'package:flutter/material.dart';

import '../data/contact_repository.dart';
import '../models/contact.dart';
import '../widgets/contact_tile.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';

/// Màn hình danh sách liên hệ + thống kê.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ContactRepository _repository = ContactRepository.instance;

  // Chặn bấm liên tục mở nhiều màn hình chồng nhau
  bool _isBusy = false;

  /// Mở màn hình chi tiết, đợi quay lại rồi làm mới danh sách + thống kê.
  Future<void> _openDetail(int index, Contact contact) async {
    if (_isBusy) return;
    _isBusy = true;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailScreen(contact: contact, index: index),
      ),
    );
    _isBusy = false;
    if (mounted) setState(() {});
  }

  /// Mở màn hình thêm liên hệ, quay lại thì làm mới.
  Future<void> _openAdd() async {
    if (_isBusy) return;
    _isBusy = true;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddContactScreen()),
    );
    _isBusy = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _repository.getAll();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ liên hệ'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        // Màn hình chính sau đăng nhập: không hiện nút Back
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.person_add),
        label: const Text('Thêm liên hệ'),
      ),
      body: Column(
        children: [
          // Khối thống kê
          Card(
            color: scheme.primaryContainer,
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Tổng: ${_repository.countAll()} liên hệ | '
                  'Yêu thích: ${_repository.countFavorites()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: contacts.isEmpty
                ? const Center(child: Text('Chưa có liên hệ nào'))
                : ListView.builder(
                    // chừa chỗ cho FAB để không che dòng cuối
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ContactTile(
                        contact: contact,
                        onTap: () => _openDetail(index, contact),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
