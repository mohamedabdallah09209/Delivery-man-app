import 'package:app_delivary_task/data/datasource/remote/dio/dio_client.dart';
import 'package:app_delivary_task/data/datasource/remote/exception/api_error_handler.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences!.containsKey(AppConstants.theme)) {
      return sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      return sharedPreferences!.setString(AppConstants.countryCode, 'US');
    }
    if(!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      return sharedPreferences!.setString(AppConstants.languageCode, 'en');
    }
    if(!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }
}