import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';
import 'package:task_manager/core/config.dart';
import 'package:task_manager/core/router/app_router.dart';
import 'package:task_manager/features/cubit/auth_cubit.dart';
import 'package:task_manager/features/cubit/auth_cubit_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCWaxMEX9pUpbXudtPJev4372zMQdpNvm8",
        authDomain: "ta-ma-49467.firebaseapp.com",
        projectId: "ta-ma-49467",
        storageBucket: "ta-ma-49467.firebasestorage.app",
        messagingSenderId: "258570770660",
        appId: "1:258570770660:web:ebfdaa29d43684d092f4f1",
        measurementId: "G-5LQTMP6QJ7",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppConfiguration()),
        BlocProvider(
          create: (context) => AuthCubit(
            firebaseAuth: AppConfiguration.i(context).state.authInstance,
          ),
        ),
      ],
      child: BlocListener<AuthCubit, AuthCubitState>(
        listener: (context, state) {
          if (state is AuthCubitUnauthorized && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ошибка: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          AppRouter.router.refresh();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', 'RU'),
          ],
          locale: const Locale('ru', 'RU'),
        ),
      ),
    );
  }
}
