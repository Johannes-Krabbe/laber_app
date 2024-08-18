import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/loading.dart';
import 'package:laber_app/home/home.dart';
import 'package:laber_app/screens/auth/login.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';
import 'package:laber_app/state/types/auth_state.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        lazy: false,
        create: (_) => AuthBloc(),
      ),
      BlocProvider(
        lazy: false,
        create: (_) => ContactsBloc(),
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
  late AuthBloc authBloc;

  @override
  void initState() {
    var authBloc = context.read<AuthBloc>();
    authBloc.add(AppStartedAuthEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.watch<AuthBloc>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget currentRenderedPage;
    switch (authBloc.state.state) {
      case AuthStateEnum.none:
        currentRenderedPage = BlocProvider(
          create: (_) => AuthFlowBloc(),
          child: const Login(),
        );
        break;
      case AuthStateEnum.loggedIn:
        currentRenderedPage = const Home();
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
      home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.state == AuthStateEnum.loggedIn) {
              context.read<ContactsBloc>().add(
                    LoadContactsContactsEvent(
                      authBloc.state.meUser!.id,
                    ),
                  );
            }
          },
          child: currentRenderedPage),
    );
  }
}
