import 'package:flutter/material.dart';

import '../models/contact.dart';
import 'avatar_initial.dart';

/// Một dòng liên hệ trong danh sách.
class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const ContactTile({super.key, required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: AvatarInitial(name: contact.fullName),
        title: Text(
          contact.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${contact.phone} • ${contact.group}'),
        // Hiện ngôi sao nếu là liên hệ yêu thích
        trailing: contact.isFavorite
            ? const Icon(Icons.star, color: Colors.amber)
            : null,
      ),
    );
  }
}
