class DioResponse {
  final int status;
  final String? error;
  final List<dynamic>? data;

  DioResponse._({required this.status, this.error, this.data});

  factory DioResponse.success(List<dynamic> data) {
    return DioResponse._(status: 1, data: data);
  }

  factory DioResponse.failure(String msg) {
    return DioResponse._(status: 0, error: msg);
  }
  @override
  String toString() => "DioResponse status: $status with data: $data";
}
