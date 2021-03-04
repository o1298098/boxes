import 'package:boxes/models/model_factory.dart';
import 'package:boxes/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';

class Request {
  final String baseUrl;
  Dio _dio;
  Dio _tokenDio;
  DioCacheManager _manager;
  String _token;
  AsyncValueGetter<String> onRefreshToken;
  Request(this.baseUrl, {this.onRefreshToken}) {
    _dio = new Dio(BaseOptions(baseUrl: baseUrl));
    _tokenDio = new Dio(BaseOptions(baseUrl: baseUrl));
    _refreshtoken();
  }

  Future<ResponseModel<T>> request<T>(String host,
      {String method = 'GET',
      dynamic data,
      dynamic queryParameters,
      bool cached = false,
      Map<String, Object> headers,
      List<Interceptor> interceptors,
      Duration cacheDuration = const Duration(days: 1),
      Duration maxStale = const Duration(days: 30)}) async {
    try {
      if (_manager != null) _dio.interceptors.remove(_manager.interceptor);
      if (cached) {
        _manager = DioCacheManager(
          CacheConfig(
            baseUrl: baseUrl,
            defaultMaxAge: cacheDuration,
            defaultMaxStale: maxStale,
          ),
        );
        _dio.interceptors.add(_manager.interceptor);
      }
      _dio.options.headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "GET,POST,OPTIONS,HEAD",
        "Access-Control-Allow-Credentials": "true"
      };
      if (headers != null) _dio.options.headers.addAll(headers);
      _dio.options.method = method;
      final response = await _dio.request(
        host,
        data: data,
        queryParameters: queryParameters,
      );
      return ResponseModel<T>(
          statusCode: response.statusCode,
          message: response.statusMessage,
          result: ModelFactory.generate(response.data));
    } on DioError catch (_) {
      print(_.message);
      return ResponseModel(
          statusCode: _.response?.statusCode ?? _.type.index,
          message: _.message);
    }
  }

  Future<ResponseModel<T>> tokenRequest<T>(String host,
      {String method = 'GET',
      dynamic data,
      dynamic queryParameters,
      Map<String, Object> headers,
      List<Interceptor> interceptors}) async {
    try {
      _tokenDio.options.headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "GET,POST,OPTIONS,HEAD",
        "Access-Control-Allow-Credentials": "true"
      };
      if (headers != null) _tokenDio.options.headers.addAll(headers);
      _tokenDio.options.method = method;
      final response = await _tokenDio.request(
        host,
        data: data,
        queryParameters: queryParameters,
      );
      return ResponseModel<T>(
          statusCode: response.statusCode,
          message: response.statusMessage,
          result: ModelFactory.generate(response.data));
    } on DioError catch (_) {
      print(_.message);
      return ResponseModel(
          statusCode: _.response?.statusCode ?? _.type.index,
          message: _.message);
    }
  }

  _refreshtoken() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (opt) {
      _token = opt.headers['Authorization'];
    }, onError: (DioError error) async {
      // Assume 401 stands for token expired
      if (error.response?.statusCode == 401) {
        if (onRefreshToken == null) return error;
        final options = error.response?.request;
        // If the token has been updated, repeat directly.
        if (_token != options.headers['Authorization']) {
          options.headers['Authorization'] = _token;
          //repeat
          return _dio.request(options.path, options: options);
        }
        // update token and repeat
        // Lock to block the incoming request until the token updated
        _dio.lock();
        _dio.interceptors.responseLock.lock();
        _dio.interceptors.errorLock.lock();
        return onRefreshToken().then((d) {
          options.headers['Authorization'] = _token = 'Bearer $d';
        }).whenComplete(() {
          _dio.unlock();
          _dio.interceptors.responseLock.unlock();
          _dio.interceptors.errorLock.unlock();
        }).then((e) {
          return _dio.request(options.path, options: options);
        });
      }
      return error;
    }));
  }
}
