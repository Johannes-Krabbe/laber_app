import 'package:flutter/material.dart';
import 'package:laber_app/screens/auth/security.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  late AuthBloc authBloc;
  late AuthFlowBloc authFlowBloc;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.read<AuthBloc>();
    authFlowBloc = context.watch<AuthFlowBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthFlowBloc, AuthFlowState>(
      listener: (context, state) {
        if (state.state == AuthFlowStateEnum.successUsername) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: authFlowBloc,
                child: const Security(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Welcome to Laber!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Create a username so your friends can find you. You can also add a display name.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Display name',
                  ),
                ),
              ),
              const Spacer(),
              Text(authFlowBloc.state.error),
              TextButton(
                onPressed: () {
                  if (usernameController.text.isNotEmpty) {
                    authFlowBloc.add(EnterUserdataAuthFlowEvent(
                      usernameController.text,
                      nameController.text,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a username'),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
