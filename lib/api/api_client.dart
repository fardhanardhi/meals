import "package:dio/dio.dart";

class Client {
  Dio init() {
    Dio _dio = Dio();
    // _dio.interceptors.add(ApiInterceptors());
    _dio.options.baseUrl = "https://www.themealdb.com/api/json/v1/1";
    return _dio;
  }
}

// class ApiInterceptors extends Interceptor {
//   @override
//   Future<dynamic> onRequest(RequestOptions options) async {
//     // do something before request is sent
//   }

//   @override
//   Future<dynamic> onError(DioError dioError) {
//     // do something to error
//   }

//   @override
//   Future<dynamic> onResponse(Response response) async {
//     // do something before response
//   }
// }