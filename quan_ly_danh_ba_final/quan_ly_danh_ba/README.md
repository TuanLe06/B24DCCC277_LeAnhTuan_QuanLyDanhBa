# Quản lý danh bạ liên hệ (quan_ly_danh_ba)

Ứng dụng Flutter (Material 3) quản lý danh bạ, dữ liệu chỉ lưu trong bộ nhớ khi app chạy.
Tính năng: đăng nhập, xem danh sách + thống kê, thêm liên hệ (có kiểm tra hợp lệ),
xem chi tiết, đánh dấu yêu thích, gọi điện, xóa liên hệ.

## Tài khoản đăng nhập
- Tên đăng nhập: `admin`
- Mật khẩu: `123456`

## Cài đặt và chạy
```bash
flutter create quan_ly_danh_ba     # tạo khung dự án (android/, ios/...)
# chép đè thư mục lib/ và pubspec.yaml của bộ mã này vào dự án vừa tạo
cd quan_ly_danh_ba
flutter pub get
flutter run
```

## Cấu hình url_launcher
- Android: thêm khối `<queries>` trong `android_snippet/AndroidManifest.xml`
  vào `android/app/src/main/AndroidManifest.xml` (bên trong `<manifest>`, ngang hàng `<application>`).
- iOS: thêm `LSApplicationQueriesSchemes` với `tel` theo `ios_snippet/Info.plist.txt`.
- Lưu ý: máy ảo thường không có ứng dụng gọi điện nên sẽ hiện SnackBar báo lỗi; hãy thử trên máy thật.

## Ghi chú phiên bản Flutter
Mã dùng `RadioGroup` và `DropdownButtonFormField(initialValue: ...)` của Flutter mới
(từ 3.32/3.33). Nếu dùng Flutter cũ hơn, đổi sang `groupValue`/`onChanged` trên từng `Radio`
và `value:` cho Dropdown.
