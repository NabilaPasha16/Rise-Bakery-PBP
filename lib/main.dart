import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ TAMBAHAN BARU: Import Firebase Core
import 'firebase_options.dart'; // ✅ TAMBAHAN BARU: Import Konfigurasi Firebase

// Import Cubit & Services (Punya kamu)
import 'bloc/cakes_cubit.dart';
import 'bloc/cart_cubit.dart';
import 'bloc/home_cubit.dart';
import 'bloc/category_cubit.dart';
import 'bloc/profile_cubit.dart';
import 'bloc/contact_cubit.dart'; 
import 'services/api_service.dart';
import 'router/app_router.dart';

// Ubah main menjadi 'async' agar bisa menunggu Firebase loading
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INI KUNCINYA: Inisialisasi Firebase sebelum aplikasi jalan
  // Tanpa ini, layar akan putih (blank) di Web
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CakesCubit(apiService: ApiService()),
            ),
            BlocProvider(create: (context) => CartCubit()),
            BlocProvider(
              create: (context) => HomeCubit(apiService: ApiService()),
            ),
            BlocProvider(
              create: (context) => CategoryCubit(apiService: ApiService()),
            ),
            BlocProvider(create: (context) => ProfileCubit()),
            
            // Provider ContactCubit
            BlocProvider(
              create: (context) => ContactCubit(ApiService()), 
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}