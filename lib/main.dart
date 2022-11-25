
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/layout/todo_app/home_layout.dart';

import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';
import 'shared/cubit/states.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';


void main() async {
  // for be sure to done all of things in method and run the app
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();
  // bool? isDark = CacheHelper.getData(key: 'isDark');
  // bool? onBoarding  = CacheHelper.getData(key: 'onBoarding');

  BlocOverrides.runZoned(
        () {
      runApp(MyApp(
        // isDark: isDark!,
        // onBoarding: onBoarding!,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // final bool isDark;
  // final bool onBoarding;

  // MyApp(
  //     {
  //        // required this.isDark,
  //       // required this.onBoarding,
  //     });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              // fromShared: isDark,
            ),
        ),

      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: lightTheme,
            // darkTheme: darkTheme,
            // themeMode:
            //     AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: HomeLayout(),
          );
        },
      ),
    );
    // throw UnimplementedError();
  }
}
