import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zeerac_flutter/dio_networking/log_interceptor.dart';

import '../utils/helpers.dart';
import '../utils/user_defaults.dart';
import 'api_response.dart';
import 'api_route.dart';
import 'app_apis.dart';
import 'decodable.dart';

abstract class BaseAPIClient {
  Future<ResponseWrapper<T>> request<T extends Decodeable>({
    @required APIRouteConfigurable? route,
    @required Create<T> create,
  });
}

class APIClient implements BaseAPIClient {
  Dio? instance;
  bool isCache;
  String baseUrl;
  String contentType;
  bool isDialoigOpen;

  APIClient(
      {this.isCache = false,
      this.baseUrl = ApiConstants.baseUrl,
      this.isDialoigOpen = true,
      this.contentType = 'application/json'}) {
    instance = Dio();

    if (instance != null) {
      instance!.interceptors.add(MyLogInterceptor());
      if (isCache) {
        List<String> allowedSHa = [];
      } else {}
    }
  }

  Map<String, dynamic> headers = {'Accept': '*/*'};

  @override
  Future<ResponseWrapper<T>> request<T extends Decodeable>({
    @required APIRouteConfigurable? route,
    @required Create<T>? create,
    Function? apiFunction,
    bool needToAuthenticate = true,
  }) async {
    final config = route!.getConfig();
    config.baseUrl = baseUrl;
    if (needToAuthenticate && (UserDefaults.getApiToken() != null)) {
      headers['Authorization'] = UserDefaults.getApiToken() ?? "";
    }
    config.headers = headers;
    config.sendTimeout = 100000;
    config.connectTimeout = 60000;
    config.receiveTimeout = 60000;
    config.followRedirects = false;
    config.validateStatus = (status) {
      return status! <= 500;
    };
    final response = await instance?.fetch(config).catchError((error) {
      printWrapped("error in response ${config.path} ${error.toString()}");

      if ((error as DioError).type == DioErrorType.connectTimeout) {
        throw 'No Internet Connection';
      }
      throw 'Something went wrong';
    });

    final responseData = response?.data;

    int statusCode = response?.statusCode ?? -1;

    switch (statusCode) {
      case 422:
        final errorResponse = ErrorResponse.fromJson(responseData);
        throw errorResponse;

      case (200):
      case (201):
        var finalResponse =
            ResponseWrapper.init(create: create, json: responseData);
        if (finalResponse.error != null) {
          final errorResponse = finalResponse.error!;
          throw errorResponse;
        } else {
          return ResponseWrapper.init(create: create, json: responseData);
        }
      default:
        final errorResponse = ErrorResponse.fromJson(responseData);
        throw errorResponse;
    }
  }
}
