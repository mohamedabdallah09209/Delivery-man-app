import 'package:flutter/material.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/commons/models/config_model.dart';
import 'package:app_delivary_task/features/splash/domain/reposotories/splash_repo.dart';
import 'package:app_delivary_task/helper/api_checker_helper.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;

  Future<bool> initConfig(BuildContext context) async {
    ApiResponse apiResponse = await splashRepo.getConfig();
    bool isSuccess;
    if (apiResponse.response?.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response?.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }
    return isSuccess;
  }

  Future<bool> initSharedData()=> splashRepo.initSharedData();

  Future<bool> removeSharedData()=> splashRepo.removeSharedData();


}