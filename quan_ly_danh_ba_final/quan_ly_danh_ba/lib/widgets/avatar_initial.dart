import 'package:flutter/material.dart';

/// Avatar tròn hiển thị chữ cái đầu của tên.
class AvatarInitial extends StatelessWidget {
  final String name;
  final double radius;

  const AvatarInitial({super.key, required this.name, this.radius = 22});

  /// Lấy chữ cái đầu của "tên" (từ cuối trong họ tên theo cách gọi của người Việt).
  String _initial() {
    final words = name.trim().split(RegExp(r'\s+'));
    final last = words.isEmpty ? '' : words.last;
    if (last.isEmpty) return '?';
    return String.fromCharCode(last.runes.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      child: Text(
        _initial(),
        style: TextStyle(
          color: scheme.onPrimaryContainer,
          fontSize: radius * 0.9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
