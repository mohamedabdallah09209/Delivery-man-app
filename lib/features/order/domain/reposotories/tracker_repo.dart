
import 'package:dio/dio.dart';
import 'package:app_delivary_task/data/datasource/remote/dio/dio_client.dart';
import 'package:app_delivary_task/data/datasource/remote/exception/api_error_handler.dart';
import 'package:app_delivary_task/features/order/domain/models/track_data_model.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  TrackerRepo({required this.dioClient, required this.sharedPreferences});


  Future<ApiResponse> addHistory(TrackDataModel trackBody) async {
    try {
      Response response = await dioClient!.post(AppConstants.recordLocationUri, data: trackBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}