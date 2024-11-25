import 'package:flutter/material.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/features/profile/domain/models/userinfo_model.dart';
import 'package:app_delivary_task/features/profile/domain/reposotories/profile_repo.dart';
import 'package:app_delivary_task/helper/api_checker_helper.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  void getUserInfo() async {
    ApiResponse apiResponse = await profileRepo!.getUserInfo();

    if (apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response?.data);

    } else {
      ApiCheckerHelper.checkApi(apiResponse);

    }
    notifyListeners();
  }
}
