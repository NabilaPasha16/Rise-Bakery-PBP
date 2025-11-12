import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cakes_cubit.dart';
import 'bloc/cart_cubit.dart';
import 'bloc/home_cubit.dart';
import 'bloc/category_cubit.dart';
import 'bloc/profile_cubit.dart';
import 'services/api_service.dart';
import 'pages/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            BlocProvider(create: (context) => CakesCubit(apiService: ApiService())),
            BlocProvider(create: (context) => CartCubit()),
            BlocProvider(create: (context) => HomeCubit(apiService: ApiService())),
            BlocProvider(create: (context) => CategoryCubit(apiService: ApiService())),
            BlocProvider(create: (context) => ProfileCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}