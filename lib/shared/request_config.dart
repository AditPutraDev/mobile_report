import 'package:http/http.dart' as http;

const firstUrl = 'https://hr.bintorocorp.co.id/api/';
const baseUrl = 'https://hr.bintorocorp.co.id/api/mob/';
const baseDevProjUrl = 'https://dev-proj.bintorocorp.co.id/api/';
const baseProjUrl = 'https://project.bintorocorp.co.id/api/';

class Request {
  String? url;
  dynamic body;
  Map<String, String>? headers;
  bool isFirst;
  bool isDevProj;

  Request({
    this.url,
    this.body,
    this.headers,
    this.isFirst = false,
    this.isDevProj = false,
  });

  Future<http.Response> get() {
    return http.get(Uri.parse('${isFirst ? firstUrl : baseUrl}$url'),
        headers: headers);
  }

  Future<http.Response> post() {
    return http.post(Uri.parse('${isFirst ? firstUrl : baseUrl}$url'),
        body: body, headers: headers);
  }

  //Config for project
  Future<http.Response> postPro() {
    print('dev $isDevProj');
    String urls = '${isDevProj ? baseDevProjUrl : baseProjUrl}$url';
    print('dev url: $urls');
    return http.post(
        Uri.parse('${isDevProj ? baseDevProjUrl : baseProjUrl}$url'),
        body: body,
        headers: headers);
  }

  Future<http.Response> getPro() {
    print('dev $isDevProj');
    String urls = '${isDevProj ? baseDevProjUrl : baseProjUrl}$url';
    print('dev url: $urls');
    return http.get(
        Uri.parse('${isDevProj ? baseDevProjUrl : baseProjUrl}$url'),
        headers: headers);
  }
}
