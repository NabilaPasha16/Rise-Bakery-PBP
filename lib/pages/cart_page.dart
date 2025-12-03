import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/cake.dart';
import '../utils/formatters.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import 'receipt_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.items, this.buyNowItem});

  final List<Cake>? items;
  final Cake? buyNowItem;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  late List<Cake> _items;
  late List<bool> _selected;
  StreamSubscription<CartState>? _cartSub;

  double get totalPrice => widget.buyNowItem != null
      ? widget.buyNowItem!.price
      : _items.fold(0.0, (sum, item) => sum + item.price);

  @override
  void initState() {
    super.initState();
    _items = widget.items != null ? List<Cake>.from(widget.items!) : <Cake>[];
    if (widget.items == null && widget.buyNowItem == null) {
      final cubit = context.read<CartCubit>();
      _items = List<Cake>.from(cubit.items);
      _cartSub = cubit.stream.listen((state) {
        if (!mounted) return;
        setState(() {
          _items = List<Cake>.from(state.items);
          _selected = List<bool>.filled(_items.length, true);
        });
      });
    }
    _selected = List<bool>.filled(_items.length, true);
  }

  Widget _buildImage(Cake item, {double width = 56, double height = 56}) {
    final img = item.imagePath;
    if (img.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: width * 0.6),
      );
    }
    final isNetwork = img.startsWith('http://') || img.startsWith('https://');
    return SizedBox(
      width: width,
      height: height,
      child: isNetwork
          ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
          : Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image)),
    );
  }

  @override
  void dispose() {
    _cartSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBuyNow = widget.buyNowItem != null;

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text(
          isBuyNow ? 'Beli Langsung ⚡' : 'Keranjang Belanja 🛒',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: textChocolate),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textChocolate),
        actions: [
          if (!isBuyNow && _items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: accentPink, // Warna icon hapus
              tooltip: "Kosongkan Keranjang",
              onPressed: () {
                context.read<CartCubit>().clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Keranjang dikosongkan.", style: GoogleFonts.poppins()),
                    backgroundColor: textChocolate,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: Container(
        // BACKGROUND GRADIENT TEMA
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgCream, bgPeach],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isBuyNow
                    ? _buildBuyNowBody(widget.buyNowItem!)
                    : _buildCartContent(),
              ),
              _buildBottomBar(isBuyNow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyNowBody(Cake item) {
    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          elevation: 4,
          shadowColor: textChocolate.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(item, width: 80, height: 80),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: GoogleFonts.poppins(
                              color: textChocolate,
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(item.description,
                          style: GoogleFonts.poppins(color: textChocolate.withOpacity(0.7)),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatRupiah(item.price),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: accentPink)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: bgCream,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: buttonGold.withOpacity(0.5))),
                      child: Text('x1', style: GoogleFonts.poppins(color: textChocolate, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartContent() {
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: textChocolate.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              "Keranjang kamu masih kosong 🍰",
              style: GoogleFonts.poppins(fontSize: 16, color: textChocolate.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
              ),
              child: Text('Kembali Belanja', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shadowColor: textChocolate.withOpacity(0.15),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(item, width: 64, height: 64),
            ),
            title: Text(item.name,
                style: GoogleFonts.poppins(
                    color: textChocolate,
                    fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(item.description,
                    style: GoogleFonts.poppins(fontSize: 11, color: textChocolate.withOpacity(0.6)),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(formatRupiah(item.price),
                    style: GoogleFonts.poppins(
                        color: accentPink,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    activeColor: accentPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    value: _selected.length > index ? _selected[index] : true,
                    onChanged: (v) {
                      setState(() {
                        if (_selected.length <= index) {
                          _selected = List<bool>.from(_selected)
                            ..length = _items.length;
                        }
                        _selected[index] = v ?? true;
                      });
                    },
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.items == null && widget.buyNowItem == null) {
                        context.read<CartCubit>().removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} dihapus', style: GoogleFonts.poppins()),
                              backgroundColor: textChocolate,
                              duration: const Duration(milliseconds: 1500),
                            ));
                        return;
                      }
                      setState(() {
                        _items.removeAt(index);
                        if (_selected.length > index) _selected.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item.name} dihapus', style: GoogleFonts.poppins())));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.delete_outline, color: Colors.red[400], size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(bool isBuyNow) {
    if (isBuyNow) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, // Bottom bar putih lebih bersih
            boxShadow: [
              BoxShadow(color: textChocolate.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,-5))
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Pembayaran:",
                    style: GoogleFonts.poppins(
                        color: textChocolate.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                Text(formatRupiah(totalPrice),
                    style: GoogleFonts.poppins(
                        color: accentPink,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi Pembelian'),
                    content: Text(
                        'Total: ${formatRupiah(totalPrice)}. Lanjutkan pembayaran?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Batal')),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Bayar')),
                    ],
                  ),
                );
                if (confirm == true) {
                  if (!mounted) return;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReceiptPage(
                        items: [widget.buyNowItem!],
                        totalPrice: totalPrice,
                        paymentMethod: 'Transfer Bank',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: accentPink, // Tombol Pink
                  elevation: 5,
                  shadowColor: accentPink.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              child:
                  Text('Beli Sekarang', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) return const SizedBox.shrink();

    final anySelected = _selected.isNotEmpty && _selected.any((s) => s);
    final double selectedTotal = anySelected
        ? List.generate(_items.length,
                (i) => (_selected.length > i && _selected[i]) ? _items[i].price : 0.0)
            .fold(0.0, (a, b) => a + b)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, // Bottom bar putih
          boxShadow: [
              BoxShadow(color: textChocolate.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,-5))
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total:",
                  style: GoogleFonts.poppins(
                      color: textChocolate.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Text(formatRupiah(selectedTotal),
                  style: GoogleFonts.poppins(
                      color: accentPink, // Angka Pink
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: (!anySelected)
                ? null
                : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Konfirmasi Pembelian'),
                        content: Text(
                            'Total: ${formatRupiah(selectedTotal)}. Lanjutkan pembayaran?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Batal')),
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Bayar')),
                        ],
                      ),
                    );
                        if (confirm == true) {
                          if (!mounted) return;
                          // Collect selected items
                          final selectedItems = <Cake>[];
                          for (var i = 0; i < _items.length; i++) {
                            if (_selected.length > i && _selected[i]) {
                              selectedItems.add(_items[i]);
                            }
                          }
                          // Navigasi ke halaman struk pembayaran
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReceiptPage(
                                items: selectedItems,
                                totalPrice: selectedTotal,
                                paymentMethod: 'Transfer Bank',
                              ),
                            ),
                          );
                          // After receipt is closed, remove the paid items
                          if (widget.items == null && widget.buyNowItem == null) {
                            final remaining = <Cake>[];
                            for (var i = 0; i < _items.length; i++) {
                              if (!(_selected.length > i && _selected[i])) {
                                remaining.add(_items[i]);
                              }
                            }
                            // clear then re-add remaining
                            context.read<CartCubit>().clear();
                            for (final it in remaining) context.read<CartCubit>().add(it);
                            return;
                          }

                      setState(() {
                        final remaining = <Cake>[];
                        final remainingSelected = <bool>[];
                        for (var i = 0; i < _items.length; i++) {
                          if (!(_selected.length > i && _selected[i])) {
                            remaining.add(_items[i]);
                            remainingSelected.add(true);
                          }
                        }
                        _items = remaining;
                        _selected = remainingSelected;
                      });
                    }
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: accentPink, // Tombol Pink
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: accentPink.withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child:
                Text('Checkout', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}