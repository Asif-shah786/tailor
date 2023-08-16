import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../config/translations/strings_enum.dart';
import '../REST/api_exceptions.dart';
import '../helper/dialog_helper.dart';

mixin class ExceptionHandler {
  RxBool isError = false.obs;

  /// FOR REST API
  void handleError(error) {
    isError.value = true;
    hideLoading();

    var errorText = DioExceptions.fromDioError(error).toString();

    showErrorDialog(Strings.oops.tr, errorText);
    Logger().e(errorText);
  }


  showLoading() {
    isError.value = false;
    DialogHelper.showLoading();
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }

  showErrorDialog(String title, String message) {
    DialogHelper.showErrorDialog(title, message);
  }
}
