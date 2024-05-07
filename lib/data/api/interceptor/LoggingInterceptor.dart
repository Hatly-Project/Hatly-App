import 'package:http/http.dart';
import 'package:http/src/base_request.dart';
import 'package:http/src/base_response.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';

class LoggingInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    print('request: ${request.toString()}');
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response is Response) {
      print('${response.body}');
    }
    return response;
  }
  // @override
  // Future<RequestData> interceptRequest({required RequestData data}) async {
  // print('request: ${data.toString()}');
  // return data;
  // }

  // @override
  // Future<ResponseData> interceptResponse({required ResponseData data}) async {
  // print('response: ${data.toString()}');
  // return data;
  // }
}
