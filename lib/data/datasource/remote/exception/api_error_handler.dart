import 'package:dio/dio.dart';
import 'package:app_delivary_task/commons/models/error_response.dart';
import 'package:app_delivary_task/localization/language_constrants.dart';
import 'package:app_delivary_task/main.dart';
import 'package:flutter/foundation.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {

          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;

            case DioExceptionType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 500:
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  ErrorResponse? errorResponse;
                  try {
                    errorResponse = ErrorResponse.fromJson(error.response!.data);
                  }catch(e) {
                    
                  }

                  if (errorResponse != null && errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
                    
                    errorDescription = errorResponse.toJson();
                  } else {
                    errorDescription =
                    "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = getTranslated('send_timeout_with_server', Get.context!);
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = getTranslated('send_timeout_with_server', Get.context!);
          
              break;
            case DioExceptionType.badCertificate:
              errorDescription = getTranslated('incorrect_certificate', Get.context!);
             
              break;
            case DioExceptionType.connectionError:
              errorDescription = '${getTranslated('unavailable_to_process_data', Get.context!)} ${  error.response!.statusCode}' ;
              
              break;
            case DioExceptionType.unknown:
              errorDescription = getTranslated('unavailable_to_process_data', Get.context!);
              
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
