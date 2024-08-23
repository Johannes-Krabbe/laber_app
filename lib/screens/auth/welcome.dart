import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:laber_app/components/button.dart';
import 'package:laber_app/screens/auth/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late AuthFlowBloc authFlowBloc;
  late AuthBloc authBloc;

  @override
  void initState() {
    var authFlowBloc = context.read<AuthFlowBloc>();
    authFlowBloc.add(InitAuthFlowEvent());
    super.initState();
  }

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
          Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            child: ListView(
              children: authFlowBloc.state.authStateStoreList?.map((element) {
                    return GestureDetector(
                      onTap: () {
                        authBloc.add(SelectSignedInUserAuthEvent(element.meUser.id));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                "https://randomuser.me/api/portraits/med/men/99.jpg",
                              ),
                            ),
                            Text(element.meUser.name ??
                                element.meUser.phoneNumber),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
          Button(
            text: 'Login or Create Account',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          )
        ],
      ),
    ));
  }
}
