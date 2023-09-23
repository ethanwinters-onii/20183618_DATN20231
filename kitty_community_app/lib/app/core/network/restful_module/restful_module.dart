import '../common/option.dart';
import '../common/response.dart';

abstract class RestfulModule {
  
  Future<CommonResponse<T>> get<T>(
    String uri, {
    Map<String, dynamic>? query,
    CommonRequestOptions? options,
  });

  Future<CommonResponse<T>> post<T>(
    String uri,
    data, {
    Map<String, dynamic>? query,
    CommonRequestOptions? options,
  });

  Future<CommonResponse<T>> put<T>(
    String uri, {
    data,
    Map<String, dynamic>? query,
    CommonRequestOptions? options,
  });

  Future<CommonResponse<T>> delete<T>(
    String uri, {
    data,
    Map<String, dynamic>? query,
    CommonRequestOptions? options,
  });
  Future<CommonResponse<T>> patch<T>(
    String uri,
    data, {
    Map<String, dynamic>? query,
    CommonRequestOptions? options,
  });
}