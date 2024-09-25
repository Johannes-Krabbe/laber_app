import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:laber_app/components/button.dart';
import 'package:laber_app/screens/auth/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/store/secure/secure_storage_service.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late AuthFlowBloc authFlowBloc;
  late AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authFlowBloc = context.watch<AuthFlowBloc>();
    authBloc = context.watch<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Welcome to LaberApp!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(70),
            child: const Icon(
              IconoirIconsBold.chatLines,
              size: 50,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () async {
              authBloc.add(LogoutAuthEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Reset local storage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Button(
            text: 'Login or Create Account',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: authFlowBloc,
                    child: const Login(),
                  ),
                ),
              );
            },
          )
        ],
      ),
    ));
  }
}
