

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/data/pkg.dart';
import 'package:geji_music_client/data/servers.dart';
import 'package:geji_music_client/model/upload.dart';

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
        onRequest: (options, handler) {
          // 统一加鉴权
          String? token = _getToken();
          if (token != null) {
            options.headers["token"] = token;
          }

          // 统一加公共参数
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
    Map<String, dynamic>? queryParameters,
    Options? options, 
    JsonParser<T>? parser}) async{
    
    // print("params :${params} ${params?.length}");
    final response = await _dio.post(path,
      data: params,
      queryParameters: queryParameters,
      options: options,
    );

    return _parseResponse<T>(response.statusCode??-1,response.data, parser);
  }

  UploadResp parseUploadFun(dynamic json) => UploadResp.fromJson(json);

  Future<Resp<UploadResp?>> uploadFile(String path,{
    String? filePath,
    String? fileName,
    Uint8List? fileBytes,
    dynamic data,
    Options? options}) async{
      FormData formData;
      if(fileBytes != null){
        formData = FormData.fromMap({
          "file":MultipartFile.fromBytes(
            fileBytes,
            filename: fileName, // 指定文件名
          ),
        });
      }else if(filePath != null){
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            filePath,
            filename: fileName, // 指定文件名
          ),
        });
      } else{
        return Future.value(Resp());
      }

      final response = await _dio.post(path,
        data: formData,
        options: options,
      );
    return _parseResponse<UploadResp?>(response.statusCode??-1,response.data, parseUploadFun);
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

  String? _getToken() {
    return Account.instance().getToken();
  }

  Future<void> _handleUnauthorized() async {
  }
}