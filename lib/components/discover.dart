/*
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'DE');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contacts'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const ListTile(
              title: Text('Add by username'),
            ),
            const ListTile(
              title: Text('Add by phone number'),
            ),
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
                    print('saved valid');
                  }
                },
              ),
            ),
            const Spacer(),
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
                  'hello',
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
    );
  }
}
*/
