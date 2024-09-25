import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:laber_app/api/api_provider.dart';

ApiRepositoryResponse<T> parseError<T>(dynamic e) {
  if (e is DioException) {
    if (e.response != null) {
      final error = e.response!;
      final statusCode = error.statusCode;
      final errorData = error.data;

      return ApiRepositoryResponse(
        status: statusCode!,
        error: getReadableErrorFromJsonString(errorData),
      );
    }
  }

  return ApiRepositoryResponse(
    status: 500,
    error: 'An error occurred',
  );
}

String getReadableErrorFromJsonString(Map<String, dynamic> error) {
  print(error.runtimeType);

  String? readableError;
  readableError = parseZodError(error);
  readableError ??= parseCustomError(error);
  readableError ??= 'An error occurred';

  return readableError;
}

String? parseZodError(Map<String, dynamic> jsonData) {
  try {
    final error = jsonData['error'];
    if (error.containsKey('issues') && error['issues'] is List) {
      final List<dynamic> issues = error['issues'];
      if (issues.isNotEmpty) {
        final List<String> errorMessages = issues.map((issue) {
          final String message = issue['message'];
          return message;
        }).toList();
        return errorMessages.join('\n');
      }
    }
  } catch (e) {
    // If JSON parsing fails or the structure is not as expected, it's not a Zod error
    return null;
  }

  // If we reach here, it's either not a Zod error or doesn't contain any issues
  return null;
}

String? parseCustomError(Map<String, dynamic> jsonData) {
  try {
    if (jsonData.containsKey('code')) {
      final String errorCode = jsonData['code'];

      switch (errorCode) {
        // Auth
        case 'USER_NOT_FOUND':
          return 'User not found.';
        case 'INVALID_OTP':
          return 'Invalid one-time password.';
        case 'OTP_EXPIRED':
          return 'One-time password has expired.';
        case 'NO_TOKEN_PROVIDED':
          return 'No authentication token provided.';
        case 'INVALID_TOKEN':
          return 'Invalid authentication token.';
        case 'USER_ALREADY_DELETED':
          return 'User has already been deleted.';

        // Device
        case 'DEVICE_ALREADY_EXISTS':
          return 'Device already exists.';
        case 'DEVICE_NOT_FOUND':
          return 'Device not found.';

        // Message
        case 'MAILBOX_NOT_FOUND':
          return 'Mailbox not found.';

        // General
        case 'UNAUTHORIZED':
          return 'Unauthorized access.';

        default:
          return 'Unknown error occurred. Code: $errorCode,';
      }
    }
  } catch (e) {
    // If JSON parsing fails or the structure is not as expected
    return null;
  }

  // If we reach here, it's either not a custom error or doesn't contain a code
  return null;
}
