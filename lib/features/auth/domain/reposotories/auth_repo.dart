
import 'package:dio/dio.dart';
import 'package:app_delivary_task/features/auth/domain/models/delivery_man_body_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_delivary_task/data/datasource/remote/dio/dio_client.dart';
import 'package:app_delivary_task/data/datasource/remote/exception/api_error_handler.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/utill/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> login({String? emailAddress, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"email": emailAddress, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> updateToken({String? token}) async {
    try {
      String? deviceToken = await _saveDeviceToken();
      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: {"_method": "put", "fcm_token": token ?? deviceToken, "token": sharedPreferences!.get(AppConstants.token)},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    debugPrint('--------Device Token---------- $deviceToken');
      return deviceToken;
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    return sharedPreferences!.remove(AppConstants.token);
    //return sharedPreferences.clear();
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.userPassword, password);
      await sharedPreferences!.setString(AppConstants.userEmail, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserEmail() {
    return sharedPreferences!.getString(AppConstants.userEmail) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.userPassword) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.userPassword);
    return await sharedPreferences!.remove(AppConstants.userEmail);
  }

  Future<http.Response> registerDeliveryMan(DeliveryManBodyModel deliveryManBody, List<MultipartBody> multiParts) async {
    http.Response response = await dioClient!.postMultipartData(
      AppConstants.register,
      deliveryManBody.toJson(),
      multiParts,
    );
    return response;
  }

  Future<ApiResponse> deleteUser() async {
    try{
      Response response = await dioClient!.delete('${AppConstants.removeAccount}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponse.withSuccess(response);
    }catch(e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }
}
