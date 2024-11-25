import 'dart:async';

import 'package:app_delivary_task/commons/models/response_model.dart';
import 'package:app_delivary_task/helper/api_checker_helper.dart';
import 'package:flutter/material.dart';
import 'package:app_delivary_task/features/order/domain/models/track_data_model.dart';
import 'package:app_delivary_task/commons/models/api_response.dart';
import 'package:app_delivary_task/features/order/domain/reposotories/tracker_repo.dart';

class TrackerProvider extends ChangeNotifier {
  final TrackerRepo? trackerRepo;
  TrackerProvider({required this.trackerRepo});

  bool _startTrack = false;
  Timer? timer;


  void updateTrackStart(bool status) {
    _startTrack = status;
    if (status == false && timer != null) {
      timer!.cancel();
    }
    notifyListeners();
  }

  Future<ResponseModel?> addTrackData({TrackDataModel? trackBody}) async {
    ResponseModel? responseModel;
    responseModel = await locationUpdate(trackBody: trackBody);

    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_startTrack) {
        responseModel = await locationUpdate(trackBody: trackBody);
        notifyListeners();
      } else {
        timer.cancel();
      }
    });

    return responseModel;
  }

  Future<ResponseModel?> locationUpdate({TrackDataModel? trackBody}) async{
    ResponseModel? responseModel;

    ApiResponse apiResponse = await trackerRepo!.addHistory(trackBody!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel('Successfully start track', true);
    } else {
      responseModel = ResponseModel(ApiCheckerHelper.getError(apiResponse).errors?.first.message, false);
    }
    return responseModel;

  }
}
