import 'package:flutter/material.dart';

import 'main_screen.dart';

/// Tài khoản cố định (khai báo bằng hằng số).
const String kUsername = 'admin';
const String kPassword = '123456';

/// Màn hình đăng nhập (màn hình khởi động).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // null = chưa có lỗi -> ẩn dòng báo lỗi
  String? _errorMessage;

  // Chặn bấm liên tục gây điều hướng nhiều lần
  bool _isNavigating = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_isNavigating) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Bỏ trống -> báo lỗi, không cho đăng nhập
    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên đăng nhập và mật khẩu');
      return;
    }

    // Sai thông tin -> ở lại màn hình
    if (username != kUsername || password != kPassword) {
      setState(() => _errorMessage = 'Sai tên đăng nhập hoặc mật khẩu');
      return;
    }

    // Đúng -> pushReplacement để nút Back không quay lại màn hình đăng nhập
    _isNavigating = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Cuộn được để không tràn khi xoay ngang / bật bàn phím
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.contacts_rounded, size: 72, color: scheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Quản lý danh bạ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  // Chỉ hiện khi có lỗi
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Đăng nhập'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
