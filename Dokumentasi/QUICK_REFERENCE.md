# 🎯 GoRouter Quick Reference Card

**Cetak/Bookmark file ini untuk referensi cepat!**

---

## 🔥 Most Used Commands

```dart
import 'router/navigation_helpers.dart';

// Navigasi ke halaman lain
context.toSplash();
context.toLogin();
context.toRegister();
context.toHome(email: 'user@example.com');
context.toDetail(cake: myCake);
context.toCart();
context.toCart(items: itemList);
context.toCart(buyNowItem: cake);
context.toCategory(category: 'Chocolate', cakes: cakeList);
context.toProfile(email: 'user@example.com');
context.toApiCakes();

// Kembali
context.back();
```

---

## 📱 Parameter Cheat Sheet

| Route | Parameter | Contoh |
|-------|-----------|--------|
| `/home` | `email: String?` | `context.toHome(email: 'user@email.com')` |
| `/detail` | `cake: Cake` | `context.toDetail(cake: myCake)` |
| `/cart` | `items?: List<Cake>`, `buyNowItem?: Cake` | `context.toCart(buyNowItem: cake)` |
| `/category` | `category: String`, `cakes: List<Cake>` | `context.toCategory(category: 'Choco', cakes: list)` |
| `/profile` | `email: String?` | `context.toProfile(email: 'user@email.com')` |

---

## 🔄 Common Navigation Patterns

### Pattern 1: Login Flow
```dart
// Dari LoginPage
context.toHome(email: email);

// Dari HomePage (logout)
context.toLogin();
```

### Pattern 2: Product Detail Flow
```dart
// Dari HomePage (click product)
context.toDetail(cake: product);

// Dari DetailPage (back)
context.back();

// Dari DetailPage (buy now)
context.toCart(buyNowItem: widget.cake);
```

### Pattern 3: Cart Checkout
```dart
// Dari CartPage (checkout success)
context.toHome();
```

### Pattern 4: Multiple Back Navigation
```dart
// Back 1 step
context.back();

// Custom back ke halaman spesifik
// Gunakan: context.go('/home') atau context.replace('/home')
```

---

## ⚠️ Common Mistakes & Fixes

| ❌ Salah | ✅ Benar | Alasan |
|---------|--------|--------|
| `Navigator.push(...)` | `context.toXxx()` | GoRouter otomatis |
| `Navigator.pop(context)` | `context.back()` | GoRouter compatible |
| Hardcode path string | Gunakan extension | Type-safe |
| Pass parameters via constructor | Pass via `extra` | Cleaner code |
| Mix Navigator dan GoRouter | Hanya gunakan GoRouter | Avoid conflicts |

---

## 🚀 One-Liner Navigation

```dart
// Navigation dalam satu baris
GestureDetector(
  onTap: () => context.toDetail(cake: cake),
  child: CakeCard(cake: cake),
)

// Button navigation
ElevatedButton(
  onPressed: () => context.toCart(),
  child: Text('Go to Cart'),
)

// IconButton navigation
IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: () => context.back(),
)
```

---

## 📋 Setup Checklist (First Time)

- [ ] `go_router: ^17.0.0` sudah di pubspec.yaml
- [ ] `lib/router/app_router.dart` sudah dibuat
- [ ] `lib/router/navigation_helpers.dart` sudah dibuat
- [ ] `lib/main.dart` di-update ke `MaterialApp.router`
- [ ] Import `navigation_helpers.dart` di page yang perlu navigasi
- [ ] Aplikasi bisa di-run tanpa error

---

## 🔍 Debugging Tips

```dart
// Lihat route yang sedang aktif
// Tambahkan di app_router.dart:
redirect: (context, state) {
  debugPrint('Location: ${state.location}');
  return null;
}

// Atau di page:
@override
void initState() {
  final location = GoRouter.of(context).location;
  debugPrint('Current page: $location');
  super.initState();
}
```

---

## 📊 Navigation Methods Comparison

```
┌──────────┬───────────────────┬─────────────────┐
│ Method   │ Use Case          │ Example         │
├──────────┼───────────────────┼─────────────────┤
│ toXxx()  │ Replace current   │ Go to home      │
│          │ (no back)         │                 │
├──────────┼───────────────────┼─────────────────┤
│ push()   │ Add to stack      │ Open modal      │
│          │ (can back)        │                 │
├──────────┼───────────────────┼─────────────────┤
│ back()   │ Go previous page  │ Back button     │
│          │                   │                 │
├──────────┼───────────────────┼─────────────────┤
│ replace()│ Replace without   │ Switch tab      │
│          │ clearing history  │                 │
└──────────┴───────────────────┴─────────────────┘
```

---

## 💡 Pro Tips

1. **Always use BuildContext** - Jangan gunakan state yang sudah disposed
```dart
// ✅ Good - dalam build method
context.toHome();

// ❌ Bad - setelah widget disposed
if (mounted) {
  Navigator.push(...);
}
```

2. **Check if can pop** - Sebelum back di root page
```dart
if (GoRouter.of(context).canPop()) {
  context.back();
} else {
  // Already at root, maybe close app
}
```

3. **Delayed navigation** - Jika perlu delay
```dart
Future.delayed(Duration(seconds: 1), () {
  if (mounted) {
    context.toHome();
  }
});
```

4. **Parameter null safety**
```dart
// Aman untuk parameter optional
context.toHome(); // email: null
context.toHome(email: 'user@email.com');
```

---

## 🎓 Learning Path

### Level 1: Beginner (15 min)
- [ ] Baca file ini sepenuhnya
- [ ] Coba `context.toHome()` di satu page
- [ ] Test navigasi

### Level 2: Intermediate (1 hour)
- [ ] Update semua page sesuai `STEP_BY_STEP_UPDATE_GUIDE.md`
- [ ] Coba parameter passing
- [ ] Test back button di semua page

### Level 3: Advanced (Optional)
- [ ] Baca `GO_ROUTER_GUIDE.md`
- [ ] Implementasi named routes
- [ ] Setup middleware/guards

---

## 🆘 Quick Troubleshoot

```
❓ Error: Undefined name 'context'
💡 Solusi: context hanya tersedia di build method atau dalam widget

❓ Error: Cannot navigate from initState
💡 Solusi: Gunakan Future.delayed atau addPostFrameCallback

❓ Navigasi tidak bekerja
💡 Solusi: 
  1. Check import navigation_helpers
  2. Check MaterialApp.router di main.dart
  3. Check app_router.dart config

❓ Back button tidak bekerja
💡 Solusi: 
  1. Gunakan context.back() bukan pop()
  2. Check GoRouter.of(context).canPop()
  3. Check navigator state

❓ Parameter tidak ter-pass
💡 Solusi:
  1. Check type parameter sesuai
  2. Check setState/build rebuild
  3. Check null safety
```

---

## 📞 Support Resources

| Resource | Link |
|----------|------|
| GoRouter Docs | `pub.dev/packages/go_router` |
| GitHub | `github.com/flutter/packages/go_router` |
| Our Guide | `GO_ROUTER_GUIDE.md` |
| Examples | `IMPLEMENTATION_EXAMPLES.dart` |
| Diagrams | `GOROUTER_DIAGRAMS.md` |

---

## ✨ Remember

```
GoRouter = Cleaner Navigation

Before:  Navigator.push(context, MaterialPageRoute(...))
After:   context.toHome()

Simple. Clean. Consistent. 🚀
```

---

**Happy Coding! 🎉**

**Last Updated:** 12 November 2025
