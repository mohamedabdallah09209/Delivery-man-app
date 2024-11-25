import 'package:app_delivary_task/data/datasource/remote/dio/dio_client.dart';
import 'package:app_delivary_task/data/datasource/remote/exception/api_error_handler.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient!.get('${AppConstants.profileUri}${sharedPreferences!.getString(AppConstants.token)}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
