import 'package:flutter/material.dart';
import 'package:laber_app/screens/auth/create_device.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  late AuthBloc authBloc;
  late AuthFlowBloc authFlowBloc;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool _switchUsernameDiscoveryValue = true;
  bool _switchPhonenumberDiscoveryValue = true;

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
        if (state.state == AuthFlowStateEnum.successSecurity) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: authFlowBloc,
                child: const CreateDevice(),
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
              const SizedBox(height: 20),
              const Text(
                'Your security settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Select how othe users can find you on Laber. You can change these settings at any time.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Enable username discovery'),
                    Switch(
                      value: _switchUsernameDiscoveryValue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchUsernameDiscoveryValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Explanation: If you enable this other users can find you via your username. We will not show your phonenumber for people who only know your username.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Enable phonenumber discovery'),
                    Switch(
                      value: _switchPhonenumberDiscoveryValue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchPhonenumberDiscoveryValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Explanation: If you enable this other users can start a chat with you by entering your phonenumber.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const Spacer(),
              Text(authFlowBloc.state.error),
              TextButton(
                onPressed: () {
                  authFlowBloc.add(
                    EnterSecurityAuthFlowEvent(
                      _switchUsernameDiscoveryValue,
                      _switchPhonenumberDiscoveryValue,
                    ),
                  );
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
