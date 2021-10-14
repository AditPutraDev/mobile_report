part of '../pages.dart';

class HomeAktivitasPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    final userId = controller.getUserRoleProject();
    print('data : $userId');
    return GeneralMenu(
      'Aktivitas',
      child: ListView(
        children: [
          if (userId == 12 ||
              userId == 3 ||
              userId == 24 ||
              userId == 22 ||
              userId == 21 ||
              userId == 23 ||
              userId != 0)
            Obx(
              () => Column(children: [
                GeneralContent('Aktivitas CRM', Icons.group_rounded,
                    onTap: controller.aktivCRM),
                controller.aktivitasCRM.value
                    ? Padding(
                        padding: EdgeInsets.only(left: 34),
                        child: Column(children: [
                          GeneralContent(
                            'Jadwal Survey',
                            Icons.group_rounded,
                            onTap: () => Get.to(
                              () => ReportSurveyPage(Type.aktivitas),
                            ),
                          ),
                          GeneralContent(
                            'Tugas',
                            Icons.group_rounded,
                            onTap: () {},
                          ),
                          GeneralContent(
                            'Rapat',
                            Icons.group_rounded,
                            onTap: () {},
                          ),
                          GeneralContent(
                            'Panggilan',
                            Icons.group_rounded,
                            onTap: () {},
                          ),
                        ]),
                      )
                    : SizedBox(),
                GeneralContent(
                  'Aktivitas Proyek',
                  Icons.business_center_rounded,
                  onTap: () {},
                ),
              ]),
            )
        ],
      ),
    );
  }
}
// part of '../pages.dart';

// class HomeAktivitasPage extends GetView<AuthController> {
//   @override
//   Widget build(BuildContext context) {
//     final userId = controller.getUserRoleProject();
//     print('data : $userId');
//     return GeneralMenu(
//       'Aktivitas',
//       child: ListView(
//         children: [
//           if (userId == 12 ||
//               userId == 3 ||
//               userId == 24 ||
//               userId == 22 ||
//               userId == 21 ||
//               userId == 23 ||
//               userId != 0)
//             Obx(
//               () => Column(children: [
//                 GeneralContent('Aktivitas CRM', Icons.groups_rounded,
//                     onTap: controller.aktivCRM),
//                 controller.aktivitasCRM.value
//                     ? Padding(
//                         padding: EdgeInsets.only(left: 34),
//                         child: Column(children: [
//                           GeneralContent(
//                             'Jadwal Survey',
//                             Icons.groups_rounded,
//                             onTap: () => Get.to(
//                               () => ReportSurveyPage(Type.aktivitas),
//                             ),
//                           ),
//                           GeneralContent(
//                             'Tugas',
//                             Icons.groups_rounded,
//                             onTap: () {},
//                           ),
//                           GeneralContent(
//                             'Rapat',
//                             Icons.groups_rounded,
//                             onTap: () {},
//                           ),
//                           GeneralContent(
//                             'Panggilan',
//                             Icons.groups_rounded,
//                             onTap: () {},
//                           ),
//                         ]),
//                       )
//                     : SizedBox(),
//                 GeneralContent(
//                   'Aktivitas Proyek',
//                   Icons.business_center_rounded,
//                   onTap: () {},
//                 ),
//               ]),
//             )
//         ],
//       ),
//     );
//   }
// }
