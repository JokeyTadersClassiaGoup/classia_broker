import 'package:classia_broker/features/home/data/datasource/home_datasource.dart';
import 'package:classia_broker/features/home/data/repositories/home_repository_impl.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_page.dart';

void main() {
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<HomeRepository>(
        create: (context) =>
            HomeRepositoryImpl(remoteDatasourceInterface: HomeDatasourceImpl()),
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
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: appTheme,
        home: const HomePageProvider(),
      ),
    );
  }
}
