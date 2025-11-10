import 'package:dio/dio.dart';
import '../model/cake.dart';
import '../model/cake_category.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://www.themealdb.com/api/json/v1/1', // API publik khusus makanan
          connectTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
          responseType: ResponseType.json,
        ));

  /// 🔸 Ambil kategori kue (dummy lokal aja)
  Future<List<CakeCategory>> fetchCategories() async {
    return [
      CakeCategory(
        id: '1',
        name: 'Kue Coklat',
        description: 'Kue lembut dengan rasa coklat pekat',
        assetImage: 'assets/cakes/chocolate.png',
      ),
      CakeCategory(
        id: '2',
        name: 'Kue Tart',
        description: 'Kue tart manis dengan krim vanilla',
        assetImage: 'assets/cakes/tart.png',
      ),
      CakeCategory(
        id: '3',
        name: 'Kue Keju',
        description: 'Kue keju lembut dengan topping parutan keju',
        assetImage: 'assets/cakes/cheese.png',
      ),
    ];
  }

  /// 🔸 Ambil daftar kue dari TheMealDB (bisa cari juga)
  Future<List<Cake>> fetchCakes({String query = ''}) async {
    try {
      // kalo kosong, cari 'cake' biar hasil default-nya kue
      final q = query.isEmpty ? 'cake' : query;
      final response = await _dio.get('/search.php', queryParameters: {'s': q});

      final meals = response.data['meals'];
      if (meals == null) return [];

      return meals.map<Cake>((m) {
        return Cake(
          m['strMeal'] ?? 'Kue Tanpa Nama',
          0, // TheMealDB gak ada harga, kamu bisa isi manual nanti
          m['strMealThumb'] ?? '',
          description: m['strInstructions'] ?? '',
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e));
    }
  }

  /// 🔸 Pesan error lebih manusiawi
  String _dioErrorMessage(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return 'Koneksi timeout. Periksa jaringan Anda.';
    }
    if (err.type == DioExceptionType.badResponse) {
      final status = err.response?.statusCode;
      final msg = err.response?.statusMessage ?? err.message;
      return 'Server error: $status $msg';
    }
    if (err.type == DioExceptionType.connectionError) {
      return 'Gagal terhubung ke server. Periksa koneksi Anda.';
    }
    return 'Terjadi kesalahan jaringan: ${err.message}';
  }
}
