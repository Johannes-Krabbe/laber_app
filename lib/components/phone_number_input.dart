import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends StatelessWidget {
  final Function(PhoneNumber) onSaved;
  final PhoneNumber initialValue = PhoneNumber(isoCode: 'DE');
  final TextEditingController controller = TextEditingController();

  PhoneNumberInput({
    super.key,
    required this.onSaved,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
        initialValue: initialValue,
        textFieldController: controller,
        formatInput: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputBorder: null,
        onSaved: onSaved,
      ),
    );
  }
}
