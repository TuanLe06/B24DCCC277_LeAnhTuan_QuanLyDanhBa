import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const QuanLyDanhBaApp());
}

/// Widget gốc của ứng dụng: cấu hình theme Material 3 màu xanh dương.
class QuanLyDanhBaApp extends StatelessWidget {
  const QuanLyDanhBaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý danh bạ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      // Màn hình khởi động là màn hình đăng nhập
      home: const LoginScreen(),
    );
  }
}
