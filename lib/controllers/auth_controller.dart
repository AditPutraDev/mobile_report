part of 'controllers.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxBool secureText = true.obs;
  RxBool isVisible = false.obs;
  RxBool aktivitasCRM = false.obs;
  RxBool reportProyek = false.obs;

  String? newVersionApp;
  String currentVersion = '${packageInfo!.version}';
  String? urlUpgrade;
  String? urlImage;
  String? message;
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  final emailCT =
      TextEditingController(text: kDebugMode ? 'nurulmutakin27@gmail.com' : '');
  final passwordCT = TextEditingController(text: kDebugMode ? 'bintoro' : '');
  final box = GetStorage();

  @override
  void onInit() {
    getVersion();
    super.onInit();
  }

  showReportProyek() => reportProyek.toggle();
  showHide() => secureText.toggle();
  void showWidget() => isVisible.toggle();

  void aktivCRM() {
    aktivitasCRM.toggle();
  }

  void splash() {
    Future.delayed(Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  checkLoginStatus() async {
    if (box.read('dataUser') == null) {
      Get.off(() => SignIn());
    } else if (currentVersion != newVersionApp) {
      Get.off(
        () => UpdateVersionPage(
            linkGoogle: urlUpgrade,
            newVersion: newVersionApp,
            linkImage: urlImage,
            message: message),
      );
    } else {
      Get.offAll(() => MainPage());
    }
  }

  void login() async {
    try {
      isLoading.toggle();
      Request request = Request(
        isFirst: true,
        url: 'token',
        body: {
          'email': emailCT.text,
          'password': passwordCT.text,
          'device_name': await getDeviceId(),
        },
        headers: {'Accept': 'application/json'},
      );

      await request.post().then((res) {
        logger.v(res.body);

        if (res.statusCode == 200) {
          var data = json.decode(res.body);
          //shared
          saveDataIn(data["data"][0]["_token"], data["data"][2]["id"]);
          isLoading.toggle();
          logger.i(data["data"][4]["status"]);
          //get storege
          saveDataUser(
            token: data["data"][0]["_token"],
            userRoleId: data["data"][1]["user_role_id"],
            userId: data["data"][2]["id"],
            status: data["data"][4]["status"],
          );
          Get.offAll(() => MainPage());
          storeAppId();
          loginProject();
        } else if (res.statusCode == 500) {
          isLoading.toggle();
          showBotToastText('Pastikan email dan password Anda benar');
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }

  Stream<DocumentSnapshot> getVersion() {
    CollectionReference version = firestore.collection('version');
    final data = version.doc('MOm9HLJUTikIsQ6EP3P1').snapshots();
    data.map((event) {
      logger.i((event.data() as dynamic)['version']);
      message = (event.data() as dynamic)['message'];
      urlImage = (event.data() as dynamic)['image_link'];
      newVersionApp = (event.data() as dynamic)['version'];
      urlUpgrade = (event.data() as dynamic)['android_link'];
    }).toList();
    return data;
  }

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      logger.i(build.androidId);
      return build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      return data.identifierForVendor;
    }
  }

  saveDataUser({String? token, String? status, int? userRoleId, int? userId}) {
    box.write('dataUser', {
      'token': token,
      'user_id': userId,
      'status': status,
      'user_role_id': userRoleId,
    });
  }

  saveDataIn(String token, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('id', id);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  String getStatusHead() {
    final data = box.read('dataUser') as Map<String, dynamic>;
    final status = data['status'];
    return status;
  }

  String getTokenHRIS() {
    final data = box.read('dataUser') as Map<String, dynamic>;
    final token = data['token'];
    return token;
  }

  String getOneSignalId() {
    final playerId = box.read('playerId');
    return playerId;
  }

  int getUserRoleID() {
    final data = box.read('dataUser') as Map<String, dynamic>;
    final userRole = data['user_role_id'];
    return userRole;
  }

  Future<bool> storeAppId() async {
    try {
      Request request = Request(url: 'employee/set-onesignal', body: {
        "onesignal_id": getOneSignalId()
      }, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${getTokenHRIS()}'
      });
      await request.post().then((res) {
        if (res.statusCode == 200) {
          Get.snackbar(
            "Berhasil",
            "Selamat datang di Keluarga Bintoro",
            icon: Icon(MdiIcons.rocketLaunchOutline, color: mainColor),
            backgroundColor: white,
            colorText: mainColor,
          );
          return true;
        }
      });
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  changePassword() async {
    try {
      isLoading.toggle();
      Request request = Request(
        url: 'employee/change-password',
        body: {
          "old_password": oldPassController.text,
          "new_password": newPassController.text,
          "confirm_new_password": confirmPassController.text,
        },
        headers: {'Authorization': 'Bearer ${getTokenHRIS()}'},
      );
      await request.post().then((res) {
        if (res.statusCode == 200) {
          final message = json.decode(res.body)['message'];
          final response = json.decode(res.body)['response'];
          showBotToastText(message != null ? message : response);
          if (response == 'success') Get.back();
        }
      });
    } catch (e) {
      logger.e(e);
    } finally {
      isLoading.toggle();
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    box.erase();
    Request request = Request(isFirst: true, url: 'revoke');
    await request.get();
    Get.offAll(() => SignIn());
  }

  tokenExpired(String message) {
    logout();
    showBotToastText('$message, Your token has expired please login again');
  }

  //AUTH project
  void loginProject() async {
    try {
      isLoading.toggle();
      Request request = Request(
        url: 'login_admin_mobile',
        body: {
          'email': emailCT.text,
          'password': passwordCT.text,
        },
      );
      await request.postPro().then((res) {
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          box.write('token_project', data['token']);
          box.write('user_role_id', data['data']['user_role']['role_id']);
          box.write('user_id_pro', data['data']['id']);
          //Get.to(() => HomeProjectPage());
          logger.v(data);
          isLoading.toggle();
        }
        logger.i(res.statusCode);
      });
    } catch (e) {
      logger.e(e);
    }
  }

  void splashProject() {
    Future.delayed(Duration(seconds: 3), () {
      checkLoginStatusProject();
    });
  }

  checkLoginStatusProject() async {
    if (box.read('token_project') != null) {
      Get.off(() => HomeProjectPage());
    }
  }

  String getTokenProject() {
    final data = box.read('token_project');
    return data;
  }

  String getUnitId() {
    final data = box.read('unit_id') ?? '1';
    return data;
  }

  String getCabangId() {
    final data = box.read('cabang') ?? '';
    return data;
  }

  int getUserRoleProject() {
    final data = box.read('user_role_id') ?? 0;
    return data;
  }

  int getUserIdProject() {
    final data = box.read('user_id_pro') ?? 0;
    return data;
  }
}
