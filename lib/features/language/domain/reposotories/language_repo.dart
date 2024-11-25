import 'package:flutter/material.dart';
import 'package:app_delivary_task/features/language/domain/models/language_model.dart';
import 'package:app_delivary_task/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
