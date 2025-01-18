import 'package:dio/dio.dart';
import 'package:user_profile_management/model/dio_response.dart';

class Connection {
  static final Dio _dio = Dio();
  static Connection? _connectionInstance;

  Connection._();

  static Connection get instance => _connectionInstance ??= Connection._();

  Future<DioResponse> get({required String url}) async {
    try {
      final response = await _dio.get(url);
      // SharedPreference.setString(
      //     key: "users", value: jsonEncode(response.data));
      return DioResponse.success(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return DioResponse.failure(
            'Conflict: The request conflicts with the server state.');
      }
      return DioResponse.failure(e.message ?? "DioException occurred");
    } catch (e) {
      return DioResponse.failure('An unexpected error occurred: $e');
    }
  }
  Future<DioResponse> post({required String url, dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return DioResponse.success([response.data]);
    } on DioException catch (e) {
      return DioResponse.failure(e.message ?? "DioException occurred");
    } catch (e) {
      return DioResponse.failure('An unexpected error occurred: $e');
    }
  }
}
