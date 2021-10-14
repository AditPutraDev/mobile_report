part of '../controllers.dart';

class ShceduleController extends GetxController {
  final authController = Get.find<AuthController>();

  RxList<SurveyShcedulePicker> listShcedule = <SurveyShcedulePicker>[].obs;
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();

  var more = true;
  var hasMore = true;
  var page = 1;
  @override
  void onInit() {
    this.getShcedule();
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (more == true && isLoading(true)) {
          print("reached end");
          page++;
          getShcedule(page: page);
        }
      }
    });
  }

  void getShcedule({int? page}) {
    try {
      isLoading.toggle();
      print('page : $page');
      Request request = Request(
        url:
            '${authController.getUnitId()}/survey_schedule/select2?search=&page=$page&not_have_report=1&site_project_id=${authController.getCabangId()}',
        headers: {
          'Authorization': 'Bearer ${authController.getTokenProject()}'
        },
      );
      request.getPro().then((res) {
        if (res.statusCode == 200) {
          final data =
              jsonDecode(res.body)['results'].cast<Map<String, dynamic>>();
          final paginate = jsonDecode(res.body)['pagination']['more'];
          final v = (data as List)
              .map((e) => SurveyShcedulePicker.fromJson(e))
              .toList();
          if (v is List<SurveyShcedulePicker>) {
            listShcedule.addAll(v);
            more = paginate;
            isLoading.toggle();
            print('page : $paginate');
            if (paginate == false) {
              isLoading(false);
            }
          }
          logger.v(data);
        } else if (res.statusCode == 500) {
          isLoading.toggle();
          showBotToastText('Internal Server Error');
        } else {
          isLoading.toggle();
          showBotToastText('Terjasi Kesalahan');
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }
}
