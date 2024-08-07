import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:laber_app/screens/auth/verify_otp.dart';
import 'package:laber_app/state/bloc/auth_flow_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'DE';
  PhoneNumber number = PhoneNumber(isoCode: 'DE');
  late AuthFlowBloc authFlowBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authFlowBloc = context.watch<AuthFlowBloc>(); // Add the line here
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthFlowBloc, AuthFlowState>(
      listener: (context, state) {
        if (state.state == AuthFlowStateEnum.successPhone &&
            (state.error.isEmpty)) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: authFlowBloc,
                child: const VerifyOtp(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {},
                    onInputValidated: (bool value) {},
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      useBottomSheetSafeArea: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.white),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputBorder: null,
                    onSaved: (PhoneNumber number) {
                      var isValid = formKey.currentState?.validate();
                      if (isValid == true) {
                        authFlowBloc.add(EnterPhoneNumberAuthFlowEvent(number));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Builder(
                  builder: (context) {
                    if (authFlowBloc.state.error.isNotEmpty) {
                      return Text(
                        authFlowBloc.state.error,
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
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    await SecureStorageRepository().deleteAll();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      'Reset secure storage',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    formKey.currentState?.save();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: const Text(
                      'Request code',
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
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
