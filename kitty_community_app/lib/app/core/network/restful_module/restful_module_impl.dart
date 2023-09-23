import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/global_widgets/custom_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../utils/extensions/logger_extension.dart';
import '../common/option.dart';
import '../common/response.dart';
import '../network_connection_checker.dart';
import 'restful_module.dart';

class RestfulModuleImpl implements RestfulModule {
  final GetConnect getConnect =
      GetConnect(timeout: const Duration(seconds: 120), allowAutoSignedCert: true);

  @override
  Future<CommonResponse<T>> get<T>(String uri,
      {Map<String, dynamic>? query, CommonRequestOptions? options}) async {
    if (!(await NetworkChecker.isConnected)) {
      CustomSnackBar.showSnackBar(
          title: KeyLanguage.error.tr, message: KeyLanguage.c408.tr);
      return CommonResponse();
    }
    var result = await getConnect.get<T>(
      uri,
      query: query,
      headers: options?.headers,
      contentType: options?.contentType ?? "application/xml",
    );
    _logger(result, query: query);
    return CommonResponse(
      body: result.body,
      headers: result.headers,
      statusCode: result.statusCode,
      statusMessage: result.statusText,
    );
  }

  @override
  Future<CommonResponse<T>> post<T>(String uri, data,
      {Map<String, dynamic>? query, CommonRequestOptions? options}) async {
    if (!(await NetworkChecker.isConnected)) {
      CustomSnackBar.showSnackBar(
          title: KeyLanguage.error.tr, message: KeyLanguage.c408.tr);
      return CommonResponse();
    }
    // logger.w(options?.contentType);
    var result = await getConnect.post<T>(
      uri,
      data,
      query: query,
      headers: options?.headers,
      contentType: options?.contentType ?? "application/xml",
    );
    _logger(result, query: data);
    return CommonResponse(
      body: result.body,
      headers: result.headers,
      statusCode: result.statusCode,
      statusMessage: result.statusText,
    );
  }

  @override
  Future<CommonResponse<T>> patch<T>(String uri, data,
      {Map<String, dynamic>? query, CommonRequestOptions? options}) async {
    if (!(await NetworkChecker.isConnected)) {
      CustomSnackBar.showSnackBar(
          title: KeyLanguage.error.tr, message: KeyLanguage.c408.tr);
      return CommonResponse();
    }
    var result = await getConnect.patch<T>(
      uri,
      data,
      query: query,
      headers: options?.headers,
      contentType: options?.contentType ?? "application/xml",
    );
    _logger(result, query: data);
    return CommonResponse(
      body: result.body,
      headers: result.headers,
      statusCode: result.statusCode,
      statusMessage: result.statusText,
    );
  }

  @override
  Future<CommonResponse<T>> put<T>(String uri,
      {data,
      Map<String, dynamic>? query,
      CommonRequestOptions? options}) async {
    if (!(await NetworkChecker.isConnected)) {
      CustomSnackBar.showSnackBar(
          title: KeyLanguage.error.tr, message: KeyLanguage.c408.tr);
      return CommonResponse();
    }
    var result = await getConnect.put<T>(
      uri,
      data,
      query: query,
      headers: options?.headers,
      contentType: options?.contentType ?? "application/xml",
    );
    _logger(result, query: data);

    return CommonResponse(
      body: result.body,
      headers: result.headers,
      statusCode: result.statusCode,
      statusMessage: result.statusText,
    );
  }

  @override
  Future<CommonResponse<T>> delete<T>(String uri,
      {data,
      Map<String, dynamic>? query,
      CommonRequestOptions? options}) async {
    if (!(await NetworkChecker.isConnected)) {
      CustomSnackBar.showSnackBar(
          title: KeyLanguage.error.tr, message: KeyLanguage.c408.tr);
      return CommonResponse();
    }
    var result = await getConnect.delete<T>(
      uri,
      query: query,
      headers: options?.headers,
      contentType: options?.contentType ?? "application/xml",
    );
    _logger(result, query: data);

    return CommonResponse(
      body: result.body,
      headers: result.headers,
      statusCode: result.statusCode,
      statusMessage: result.statusText,
    );
  }

  void _logger(Response result, {dynamic query}) {
    if (kDebugMode) {
      logger.i('Path: ${result.request?.url}');
      logger.i('Request query/body:\n$query');
      logger.i('Status code: ${result.statusCode}');
      // logger.d('Response Body:\n${result.body}');
    }
  }
}