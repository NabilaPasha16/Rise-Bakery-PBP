# 📋 Step-by-Step Update Guide untuk Setiap Page

## 🎯 Overview
Panduan ini menunjukkan persis apa yang harus diubah di setiap page untuk menggunakan GoRouter.

---

## 1️⃣ Update Login Page

**File:** `lib/pages/login_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di tombol "Login"
```dart
// SEBELUM:
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomePage(email: email)),
);

// SESUDAH:
context.toHome(email: email);
```

#### C. Di tombol "Belum punya akun?"
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => RegisterPage(onRegister: _handleRegister)),
);

// SESUDAH:
context.toRegister();
```

---

## 2️⃣ Update Register Page

**File:** `lib/pages/register_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di tombol "Register"
```dart
// SEBELUM:
widget.onRegister(email, password);

// SESUDAH:
widget.onRegister(email, password);
// Atau jika tidak perlu callback:
context.toLogin();
```

#### C. Di tombol "Kembali"
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

---

## 3️⃣ Update Home Page

**File:** `lib/pages/home_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di setiap cake item (GestureDetector/Card)
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailPage(cake: cake)),
);

// SESUDAH:
context.toDetail(cake: cake);
```

#### C. Di tombol Cart (bottom navigation atau floating button)
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const CartPage()),
);

// SESUDAH:
context.toCart();
```

#### D. Di tombol Profile
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ProfilePage(email: widget.email)),
);

// SESUDAH:
context.toProfile(email: widget.email);
```

#### E. Di tombol Logout atau kembali ke login
```dart
// SEBELUM:
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const LoginPage()),
);

// SESUDAH:
context.toLogin();
```

---

## 4️⃣ Update Detail Page

**File:** `lib/pages/detail_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di back button (AppBar)
```dart
// SEBELUM:
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => Navigator.pop(context),
),

// SESUDAH:
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => context.back(),
),
```

#### C. Di tombol "Buy Now" atau "Add to Cart"
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CartPage(buyNowItem: widget.cake),
  ),
);

// SESUDAH:
context.toCart(buyNowItem: widget.cake);
```

#### D. Di tombol "Continue Shopping"
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

---

## 5️⃣ Update Cart Page

**File:** `lib/pages/cart_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di back button
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

#### C. Di tombol "Continue Shopping"
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

#### D. Di tombol "Checkout"
```dart
// SEBELUM:
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomePage(email: email)),
);

// SESUDAH:
context.toHome(email: email);
```

---

## 6️⃣ Update Category Page

**File:** `lib/pages/category_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di setiap cake item dalam kategori
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailPage(cake: cake)),
);

// SESUDAH:
context.toDetail(cake: cake);
```

#### C. Di back button
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

---

## 7️⃣ Update Profile Page

**File:** `lib/pages/profile_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di back button
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

#### C. Di tombol "Logout"
```dart
// SEBELUM:
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const LoginPage()),
);

// SESUDAH:
context.toLogin();
```

---

## 8️⃣ Update API Cakes Page

**File:** `lib/pages/api_cakes_page.dart`

### Perubahan yang diperlukan:

#### A. Tambahkan Import
```dart
import '../router/navigation_helpers.dart';
```

#### B. Di setiap cake item
```dart
// SEBELUM:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailPage(cake: cake)),
);

// SESUDAH:
context.toDetail(cake: cake);
```

#### C. Di back button
```dart
// SEBELUM:
Navigator.pop(context);

// SESUDAH:
context.back();
```

---

## 🔄 Quick Reference Chart

| Operasi | Sebelum | Sesudah |
|---------|--------|--------|
| Kembali ke halaman sebelumnya | `Navigator.pop(context)` | `context.back()` |
| Ke halaman baru (push) | `Navigator.push(context, MaterialPageRoute(...))` | `context.toXxx()` atau `context.pushRoute()` |
| Replace halaman (tidak bisa kembali) | `Navigator.pushReplacement(...)` | `context.toXxx()` atau `context.replaceRoute()` |
| Ke halaman dengan parameter | Harus buat MaterialPageRoute manually | `context.toXxx(param: value)` |
| Ke halaman home (clear stack) | `Navigator.pushAndRemoveUntil(...)` | `context.toHome()` |

---

## ✅ Checklist Verifikasi

Setelah melakukan update, pastikan:

- [ ] Splash → Login berfungsi
- [ ] Login → Home berfungsi
- [ ] Login → Register berfungsi
- [ ] Home → Detail berfungsi
- [ ] Detail → Cart berfungsi
- [ ] Cart → Home berfungsi
- [ ] Home → Profile berfungsi
- [ ] Profile → Logout (ke Login) berfungsi
- [ ] Semua back button berfungsi
- [ ] Tidak ada error di console
- [ ] Aplikasi smooth tanpa lag

---

## 📌 Catatan Penting

1. **Jangan lupa import** - Setiap file yang menggunakan GoRouter harus import `navigation_helpers.dart`

2. **Konsistensi** - Gunakan satu style di seluruh aplikasi (extension methods recommended)

3. **Testing** - Test setiap navigasi setelah update

4. **Hot Reload** - GoRouter mendukung hot reload dengan baik

5. **Nullable Parameters** - Pastikan parameter yang optional ditandai dengan `?`

---

## 🚀 Urutan Update (Recommended)

1. ✅ Splash Screen (sudah diupdate)
2. ✅ Main (sudah diupdate)
3. Login Page
4. Register Page
5. Home Page
6. Detail Page
7. Cart Page
8. Category Page
9. Profile Page
10. API Cakes Page

---

## 💡 Tips

- Mulai dari yang paling sering digunakan (Login → Home → Detail)
- Test setiap navigasi langsung setelah update
- Gunakan code search (Ctrl+F) untuk mencari `Navigator.push`, `Navigator.pop`, dll
- Jika ada yang error, check import di file tersebut

---

**Selamat! Sekarang Anda siap mengupdate setiap page! 🎉**
