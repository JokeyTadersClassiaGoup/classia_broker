import 'package:classia_broker/core/router/routes.dart';
import 'package:classia_broker/features/home/data/datasource/home_datasource.dart';
import 'package:classia_broker/features/home/data/repositories/home_repository_impl.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:classia_broker/features/order/0_data/datasource/order_datasource.dart';
import 'package:classia_broker/features/order/0_data/repositories/order_repository_impl.dart';
import 'package:classia_broker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/order/1_domian/repository/order_repository.dart';

const String accessken =
    'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI4NEFHOU4iLCJqdGkiOiI2NmZlNjdmMmFiOGNiYzI1MmFlOGQwMGIiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzI3OTQ4Nzg2LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3Mjc5OTI4MDB9._s2pWl0AyfR3K4iIhHPZLAjUtHl_YJ__f4Cuukuh3EI';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(
        create: (context) => AuthRepositoryImpl(
          remoteDataSourceInterface: AuthRemoteDatasource(),
        ),
      ),
      RepositoryProvider<HomeRepository>(
        create: (context) =>
            HomeRepositoryImpl(remoteDataSourceInterface: HomeDatasourceImpl()),
      ),
      RepositoryProvider<OrderRepository>(
        create: (context) =>
            OrderRepositoryImpl(remoteDataSourceInterface: OrderDataSource()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: OKToast(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: appTheme,
          routerConfig: route,
        ),
      ),
    );
  }
}
