import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/loading.dart';
import 'package:laber_app/screens/auth/login.dart';
import 'package:laber_app/screens/chat_list.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:laber_app/state/types/auth_state.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        lazy: false,
        create: (_) => AuthBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    var authBloc = context.read<AuthBloc>();
    authBloc.add(AppStartedAuthEvent());

    super.initState();
  }

/*
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Respond to lifecycle changes by checking the state
    print("Current state: $state");
  }
*/

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();

    Widget currentRenderedPage;

    authBloc.add(LoggedInAuthEvent("1234", "1234"));

    switch (authBloc.state.state) {
      case AuthStateEnum.none:
        currentRenderedPage = BlocProvider(
          create: (_) => AuthFlowBloc(),
          child: const Login(),
        );
        break;
      case AuthStateEnum.loggedIn:
        currentRenderedPage = const ChatList();
        break;
      default:
        // AuthStateEnum.loading
        currentRenderedPage = const Loading();
    }

    return MaterialApp(
      title: 'Machen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(primary: Colors.blue),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      themeMode: ThemeMode.dark,
      home: currentRenderedPage,
    );
  }
}
