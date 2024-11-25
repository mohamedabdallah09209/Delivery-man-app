import 'package:flutter/material.dart';
import 'package:app_delivary_task/localization/app_localization.dart';

String? getTranslated(String? key, BuildContext context) {
  String? text = key;
  try{
    text = AppLocalization.of(context)!.translate(key);
  }catch (error){
    debugPrint('not localized --- $error');

}
  return text;
}