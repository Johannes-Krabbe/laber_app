// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';

class CreateDevice extends StatefulWidget {
  const CreateDevice({super.key});

  @override
  State<CreateDevice> createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  late AuthBloc authBloc;
  late AuthFlowBloc authFlowBloc;
  final TextEditingController controller = TextEditingController();

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
        if (state.state == AuthFlowStateEnum.successDevice &&
            state.token?.isNotEmpty == true &&
            state.meUser != null &&
            state.meDevice != null) {
          authBloc.add(
            LoggedInAuthEvent(
              state.phoneNumber!.phoneNumber!,
              state.token!,
              state.meUser!,
              state.meDevice!,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
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
                'Enter a name for this device',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Device name',
                  ),
                ),
              ),
              const Spacer(),
              Text(authFlowBloc.state.error ?? ''),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    authFlowBloc.add(CreateDeviceAuthFlowEvent(
                        authFlowBloc.state.token!, controller.text));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a device name'),
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
                    'Save',
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
