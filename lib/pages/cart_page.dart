import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/cake.dart';
import '../utils/formatters.dart';
import '../utils/cart_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.items, this.buyNowItem});

  final List<Cake>? items;
  final Cake? buyNowItem;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Cake> _items;
  late List<bool> _selected;
  late final CartManager _cartManager;

  double get totalPrice => widget.buyNowItem != null
      ? widget.buyNowItem!.price
      : _items.fold(0.0, (sum, item) => sum + item.price);

  @override
  void initState() {
    super.initState();
    _cartManager = CartManager();
    _items = widget.items != null ? List<Cake>.from(widget.items!) : <Cake>[];
    if (widget.items == null && widget.buyNowItem == null) {
      _items = List<Cake>.from(_cartManager.items);
      _cartManager.addListener(_onCartChanged);
    }
    _selected = List<bool>.filled(_items.length, true);
  }

  @override
  void dispose() {
    try {
      _cartManager.removeListener(_onCartChanged);
    } catch (_) {}
    super.dispose();
  }

  void _onCartChanged() {
    if (!mounted) return;
    setState(() {
      _items = List<Cake>.from(_cartManager.items);
      _selected = List<bool>.filled(_items.length, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBuyNow = widget.buyNowItem != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Keranjang Belanja 🛒',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.pink.shade700),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.pink.shade700),
        actions: [
          if (!isBuyNow && _items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "Kosongkan Keranjang",
              onPressed: () {
                _cartManager.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Keranjang dikosongkan."),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
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
    );
  }

  Widget _buildBuyNowBody(Cake item) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(item.description,
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
                            color: Colors.pink.shade800)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('x1', style: GoogleFonts.poppins()),
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
            const Icon(Icons.shopping_cart_outlined,
                size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              "Keranjang kamu masih kosong 🍰",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade400),
              child: const Text('Kembali Belanja'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imagePath,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(item.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(formatRupiah(item.price),
                    style: TextStyle(
                        color: Colors.pink.shade700,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
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
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      if (widget.items == null && widget.buyNowItem == null) {
                        _cartManager.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} dihapus')));
                        return;
                      }
                      setState(() {
                        _items.removeAt(index);
                        if (_selected.length > index) _selected.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item.name} dihapus')));
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.pink),
                    child: const Text('Hapus'),
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
            color: Colors.pink.shade400,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total:",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(formatRupiah(totalPrice),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Pembelian berhasil! Terima kasih.')));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
              child:
                  Text('Beli Sekarang', style: GoogleFonts.poppins(color: Colors.white)),
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
          color: Colors.pink.shade400,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total:",
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text(formatRupiah(selectedTotal),
                  style: GoogleFonts.poppins(
                      color: Colors.white,
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
                      if (widget.items == null && widget.buyNowItem == null) {
                        final remaining = <Cake>[];
                        for (var i = 0; i < _items.length; i++) {
                          if (!(_selected.length > i && _selected[i])) {
                            remaining.add(_items[i]);
                          }
                        }
                        _cartManager.clear();
                        for (final it in remaining) _cartManager.add(it);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Pembelian berhasil! Terima kasih.')));
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Pembelian berhasil! Terima kasih.')));
                    }
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
            child:
                Text('Beli Sekarang', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
