String? validateAndCleanPhoneNumber(String phoneNumber) {
  // Regular expression to match the phone number format
  final phoneRegex = RegExp(r'^\+(\d{1,3})(\d+)$');

  // Remove any whitespace from the input
  final cleanedNumber = phoneNumber.replaceAll(RegExp(r'\s'), '');

  // Test the cleaned number against the regex
  final match = phoneRegex.firstMatch(cleanedNumber);

  if (match != null) {
    // If the number is valid, return the cleaned number
    return cleanedNumber;
  } else {
    // If the number is invalid, return null
    return null;
  }
}
