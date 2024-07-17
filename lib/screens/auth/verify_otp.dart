import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

const Color primaryColor = Color(0xFF121212);
const Color accentPurpleColor = Color(0xFF6A53A1);
const Color accentPinkColor = Color(0xFFF99BBD);
const Color accentDarkGreenColor = Color(0xFF115C49);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);

class _VerifyOtpState extends State<VerifyOtp> {
  late AuthBloc authBloc;
  late AuthFlowBloc authFlowBloc;
  late List<TextEditingController?> controls;
  bool clearText = false;

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
        if (state.state == AuthFlowStateEnum.successOtp &&
            state.token?.isNotEmpty == true) {
          authBloc.add(
              LoggedInAuthEvent(state.phoneNumber!.phoneNumber!, state.token!));
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                'Code send to ${authFlowBloc.state.phoneNumber?.phoneNumber}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF512DA8),
                focusedBorderColor: const Color(0xFF512DA8),
                clearText: clearText,
                showFieldAsBox: false,
                textStyle: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onCodeChanged: (String value) {
                  //Handle each value
                },
                handleControllers: (controllers) {
                  //get all textFields controller, if needed
                  controls = controllers;
                },
                onSubmit: (String verificationCode) {
                  //set clear text to clear text from all fields
                  setState(() {
                    clearText = true;
                  });
                  //navigate to different screen code goes here
                  authFlowBloc.add(VerifyOtpAuthFlowEvent(verificationCode));
                }, // end onSubmit
              ),
              const SizedBox(height: 30),
              Builder(
                builder: (context) {
                  if (authFlowBloc.state.error != null) {
                    return Text(
                      authFlowBloc.state.error!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Change phone number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  print('pressed');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Resend SMS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
