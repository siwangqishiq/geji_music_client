

import 'package:dio/dio.dart';
import 'package:geji_music_client/data/pkg.dart';
import 'package:geji_music_client/data/servers.dart';

typedef JsonParser<T> = T Function(dynamic json);

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  late final Dio _dio;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: GetBaseUrl(), 
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 45),
      headers: {
        "Content-Type": "application/json",
      },
    );
    _dio = Dio(options);
    _initInterceptors();
  }

  Dio get dio => _dio;

  void _initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 统一加鉴权
          String? token = await _getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          // 可以统一加公共参数
          // options.queryParameters["app_version"] = "1.0";
          return handler.next(options);
        },

        onResponse: (response, handler) {
          // 统一处理返回数据（例如 code != 0）
          return handler.next(response);
        },

        onError: (DioException e, handler) async {
          //统一错误处理
          if (e.response?.statusCode == 401) {
            // token 失效
            await _handleUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Resp<T>> post<T>(String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options, 
    JsonParser<T>? parser}) async{
    
    final response = await _dio.post(path,
      data: data,
      queryParameters: params,
      options: options,
    );

    return _parseResponse<T>(response.statusCode??-1,response.data, parser);
  }


  Future<Resp<T>> get<T>(String path, {
    Map<String, dynamic>? params,
    Options? options, 
    JsonParser<T>? parser}) async{
    
    final response = await _dio.get(path,
      queryParameters: params,
      options: options,
    );

    return _parseResponse<T>(response.statusCode??-1,response.data, parser);
  }

  Resp<T> _parseResponse<T>(int httpCode,dynamic json,JsonParser<T>? parser) {
    if(httpCode != 200){
      return Resp<T>(
        code: httpCode,
        msg: null,
        data: null,
      );
    }

    final resp = Resp<T?>(
      code: json["code"],
      msg: json["msg"],
      data: null,
    );


    if (resp.code == 200) {
      if (parser != null && json["data"] != null) {
        resp.data = parser(json["data"]);
      } else {
        resp.data = json["data"]; // 基础类型
      }
    }

    return resp as Resp<T>;
  }

  // Future<Response<T>> put<T>(
  //   String path, {
  //   dynamic data,
  //   Map<String, dynamic>? params,
  // }) {
  //   return _dio.put<T>(
  //     path,
  //     data: data,
  //     queryParameters: params,
  //   );
  // }

  // Future<Response<T>> delete<T>(
  //   String path, {
  //   dynamic data,
  //   Map<String, dynamic>? params,
  // }) {
  //   return _dio.delete<T>(
  //     path,
  //     data: data,
  //     queryParameters: params,
  //   );
  // }

  Future<String?> _getToken() async {
    return null;
  }

  Future<void> _handleUnauthorized() async {
  }
}