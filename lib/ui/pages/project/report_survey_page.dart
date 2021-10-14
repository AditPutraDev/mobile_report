part of '../pages.dart';

enum Type { aktivitas, report }

class ReportSurveyPage extends StatefulWidget {
  final Type type;
  ReportSurveyPage(this.type);
  @override
  _ReportSurveyPageState createState() => _ReportSurveyPageState();
}

class _ReportSurveyPageState extends State<ReportSurveyPage> {
  SurveyShcedulePicker? shcedulePicker;
  ServiceCategory? service;
  Cabang? cabang;

  @override
  Widget build(BuildContext context) {
    String title = (widget.type == Type.report) ? 'Laporan' : 'Jadwal';
    String order = (widget.type == Type.report) ? 'Pesanan' : 'Subjek Jadwal';

    final controller = Get.put(SurveyController());

    return Scaffold(
      appBar: AppBar(
        title: Text('$title Survey'),
      ),
      body: Obx(
        () => ListView(
          //controller: controller.scrollController,
          children: [
            Container(
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: controller.search,
                    onChanged: (text) {
                      controller.onSearch(controller.search.text);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        suffixIcon: (controller.isTyping.value)
                            ? IconButton(
                                onPressed: () => controller.onTyping(),
                                icon: Icon(Icons.close_rounded,
                                    color: Colors.black),
                              )
                            : SizedBox(),
                        filled: true,
                        contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: 'Search'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Colors.white),
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text((service == null)
                          ? 'Unit Bisnis'
                          : service!.title ?? ''),
                      onTap: () {
                        Get.bottomSheet(Container(
                                height: Get.height * 0.5,
                                color: Colors.white,
                                child: (controller.listService.isEmpty)
                                    ? loadingMainIndicator
                                    : ListView.builder(
                                        controller: controller.scrollController,
                                        itemCount:
                                            controller.listService.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.back(
                                                  result: controller
                                                      .listService[index]);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(12),
                                              height: 45,
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: Text(controller
                                                      .listService[index]
                                                      .title ??
                                                  ''),
                                            ),
                                          );
                                        },
                                      )))
                            .then((value) {
                          if (value != null && value is ServiceCategory) {
                            service = value;
                            controller.box.write('unit_id', '${service!.id}');
                            setState(() {});
                            cabang = null;
                            print(controller.box.read('unit_id'));
                            controller.getSurveyReport();
                            controller.getCabang();

                            //showBotToastText('waiting...');
                          }
                        });
                      },
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35), color: Colors.white),
              child: ListTile(
                leading: Icon(Icons.pin_drop_rounded),
                trailing: (cabang == null)
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            cabang = null;
                            controller.box.write('cabang', '');
                            controller.getSurveyReport();
                          });
                        },
                        child: Icon(Icons.close, color: mainColor, size: 20)),
                title: Text(
                    (cabang == null) ? 'Cabang' : 'Cabang : ${cabang!.name}'),
                onTap: (controller.listCabang.isEmpty)
                    ? () {}
                    : () {
                        Get.bottomSheet(Container(
                                height: Get.height * 0.5,
                                color: Colors.white,
                                child: (controller.isLoading.value)
                                    ? loadingMainIndicator
                                    : (controller.listCabang.isEmpty)
                                        ? SizedBox()
                                        : ListView.builder(
                                            controller:
                                                controller.scrollController,
                                            itemCount:
                                                controller.listCabang.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Get.back(
                                                      result: controller
                                                          .listCabang[index]);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(12),
                                                  height: 45,
                                                  color: Colors.white,
                                                  width: double.infinity,
                                                  child: Text(controller
                                                          .listCabang[index]
                                                          .name ??
                                                      ''),
                                                ),
                                              );
                                            },
                                          )))
                            .then((value) {
                          if (value != null && value is Cabang) {
                            cabang = value;
                            controller.box.write(
                                'cabang', '${cabang!.serviceCategoryId}');
                            setState(() {});
                            print(controller.box.read('cabang'));
                            controller.getSurveyReport();
                          }
                        });
                      },
              ),
            ),
            (controller.isLoading.value ||
                    controller.indexSurvey.value.data == null)
                ? Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.35),
                    child: loadingCircleRed,
                  )
                : controller.indexSurvey.value.total == 0
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.35),
                        child: labelText('Data Kosong'),
                      ))
                    : Column(
                        children: [
                          ...controller.indexSurvey.value.data!.map(
                            (item) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      rowWidget(
                                        TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.group_outlined,
                                              color: Colors.blue),
                                          label: Text(
                                            order,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.group_outlined,
                                              color: Colors.blue),
                                          label: Text(
                                            'Dibuat oleh',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12),
                                        child: rowWidget(
                                          Expanded(
                                              child: Text(
                                                  '${item.nameConsument}')),
                                          Expanded(
                                              child: Text(
                                                  item.createdByName ?? '-')),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue),
                                            onPressed: () => Get.to(() =>
                                                DetailReportPage(
                                                    item,
                                                    (widget.type == Type.report)
                                                        ? Type.report
                                                        : Type.aktivitas)),
                                            child: Text('Detail',
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: (widget.type == Type.report)
                                                ? ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.blue),
                                                    onPressed: () {
                                                      controller
                                                          .getPdf(item.id!);
                                                    },
                                                    child: Text('Download',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                  )
                                                : SizedBox(),
                                          ),
                                          (widget.type == Type.report)
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.blue),
                                                  onPressed: () => Get.to(() =>
                                                      ReportSurveyForm(
                                                          isEdit: true,
                                                          data: item)),
                                                  child: Text('Edit',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      // Column(
                                      //     children: item.jobs!.map((e) {
                                      //   return Column(
                                      //       children: e.image!
                                      //           .map((e) => Image.network(e.src!))
                                      //           .toList());
                                      // }).toList()),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => ReportSurveyForm()),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget rowWidget(Widget right, left) {
    return Row(
        mainAxisAlignment: (widget.type == Type.report)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [right, left]);
  }
}
// part of '../pages.dart';

// enum Type { aktivitas, report }

// class ReportSurveyPage extends StatefulWidget {
//   final Type type;
//   ReportSurveyPage(this.type);
//   @override
//   _ReportSurveyPageState createState() => _ReportSurveyPageState();
// }

// class _ReportSurveyPageState extends State<ReportSurveyPage> {
//   SurveyShcedulePicker? shcedulePicker;
//   ServiceCategory? service;
//   Cabang? cabang;

//   @override
//   Widget build(BuildContext context) {
//     String title = (widget.type == Type.report) ? 'Laporan' : 'Jadwal';
//     String order = (widget.type == Type.report) ? 'Pesanan' : 'Subjek Jadwal';

//     final controller = Get.put(SurveyController());

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$title Survey'),
//       ),
//       body: Obx(
//         () => ListView(
//           children: [
//             Container(
//               child: Row(children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.search,
//                     onChanged: (text) {
//                       controller.onSearch(controller.search.text);
//                     },
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(35),
//                           borderSide: BorderSide.none,
//                         ),
//                         prefixIcon: Icon(Icons.search),
//                         fillColor: Colors.white,
//                         suffixIcon: (controller.isTyping.value)
//                             ? IconButton(
//                                 onPressed: () => controller.onTyping(),
//                                 icon: Icon(Icons.close_rounded,
//                                     color: Colors.black),
//                               )
//                             : SizedBox(),
//                         filled: true,
//                         contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
//                         hintStyle: TextStyle(color: Colors.grey),
//                         hintText: 'Search'),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(35),
//                         color: Colors.white),
//                     child: ListTile(
//                       leading: Icon(Icons.settings),
//                       title: Text((service == null)
//                           ? 'Unit Bisnis'
//                           : service!.title ?? ''),
//                       onTap: () {
//                         Get.bottomSheet(Container(
//                                 height: Get.height * 0.5,
//                                 color: Colors.white,
//                                 child: (controller.listService.isEmpty)
//                                     ? loadingMainIndicator
//                                     : ListView.builder(
//                                         controller: controller.scrollController,
//                                         itemCount:
//                                             controller.listService.length,
//                                         itemBuilder: (context, index) {
//                                           return GestureDetector(
//                                             onTap: () {
//                                               Get.back(
//                                                   result: controller
//                                                       .listService[index]);
//                                             },
//                                             child: Container(
//                                               margin: EdgeInsets.all(12),
//                                               height: 45,
//                                               color: Colors.white,
//                                               width: double.infinity,
//                                               child: Text(controller
//                                                       .listService[index]
//                                                       .title ??
//                                                   ''),
//                                             ),
//                                           );
//                                         },
//                                       )))
//                             .then((value) {
//                           if (value != null && value is ServiceCategory) {
//                             service = value;
//                             controller.box.write('unit_id', '${service!.id}');
//                             setState(() {});
//                             cabang = null;
//                             print(controller.box.read('unit_id'));
//                             controller.getSurveyReport();
//                             controller.getCabang();

//                             //showBotToastText('waiting...');
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//             SizedBox(height: 8),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(35), color: Colors.white),
//               child: ListTile(
//                 leading: Icon(Icons.pin_drop_rounded),
//                 trailing: (cabang == null)
//                     ? SizedBox()
//                     : GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             cabang = null;
//                             controller.box.write('cabang', '');
//                             controller.getSurveyReport();
//                           });
//                         },
//                         child: Icon(Icons.close, color: mainColor, size: 20)),
//                 title: Text(
//                     (cabang == null) ? 'Cabang' : 'Cabang : ${cabang!.name}'),
//                 onTap: (controller.listCabang.isEmpty)
//                     ? () {}
//                     : () {
//                         Get.bottomSheet(Container(
//                                 height: Get.height * 0.5,
//                                 color: Colors.white,
//                                 child: (controller.isLoading.value)
//                                     ? loadingMainIndicator
//                                     : (controller.listCabang.isEmpty)
//                                         ? SizedBox()
//                                         : ListView.builder(
//                                             controller:
//                                                 controller.scrollController,
//                                             itemCount:
//                                                 controller.listCabang.length,
//                                             itemBuilder: (context, index) {
//                                               return GestureDetector(
//                                                 onTap: () {
//                                                   Get.back(
//                                                       result: controller
//                                                           .listCabang[index]);
//                                                 },
//                                                 child: Container(
//                                                   margin: EdgeInsets.all(12),
//                                                   height: 45,
//                                                   color: Colors.white,
//                                                   width: double.infinity,
//                                                   child: Text(controller
//                                                           .listCabang[index]
//                                                           .name ??
//                                                       ''),
//                                                 ),
//                                               );
//                                             },
//                                           )))
//                             .then((value) {
//                           if (value != null && value is Cabang) {
//                             cabang = value;
//                             controller.box.write(
//                                 'cabang', '${cabang!.serviceCategoryId}');
//                             setState(() {});
//                             print(controller.box.read('cabang'));
//                             controller.getSurveyReport();
//                           }
//                         });
//                       },
//               ),
//             ),
//             (controller.isLoading.value ||
//                     controller.indexSurvey.value.data == null)
//                 ? Padding(
//                     padding: EdgeInsets.only(top: Get.height * 0.35),
//                     child: loadingCircleRed,
//                   )
//                 : controller.indexSurvey.value.total == 0
//                     ? Center(
//                         child: Padding(
//                         padding: EdgeInsets.only(top: Get.height * 0.35),
//                         child: labelText('Data Kosong'),
//                       ))
//                     : Column(
//                         children: [
//                           ...controller.indexSurvey.value.data!.map(
//                             (item) {
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       rowWidget(
//                                         TextButton.icon(
//                                           onPressed: () {},
//                                           icon: Icon(Icons.group_outlined,
//                                               color: Colors.blue),
//                                           label: Text(
//                                             order,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         TextButton.icon(
//                                           onPressed: () {},
//                                           icon: Icon(Icons.group_outlined,
//                                               color: Colors.blue),
//                                           label: Text(
//                                             'Dibuat oleh',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.all(12),
//                                         child: rowWidget(
//                                           Expanded(
//                                               child: Text(
//                                                   '${item.nameConsument}')),
//                                           Expanded(
//                                               child: Text(
//                                                   item.createdByName ?? '-')),
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                                 primary: Colors.blue),
//                                             onPressed: () => Get.to(() =>
//                                                 DetailReportPage(
//                                                     item,
//                                                     (widget.type == Type.report)
//                                                         ? Type.report
//                                                         : Type.aktivitas)),
//                                             child: Text('Detail',
//                                                 style: TextStyle(fontSize: 12)),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 12),
//                                             child: (widget.type == Type.report)
//                                                 ? ElevatedButton(
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                             primary:
//                                                                 Colors.blue),
//                                                     onPressed: () {
//                                                       controller
//                                                           .getPdf(item.id!);
//                                                     },
//                                                     child: Text('Download',
//                                                         style: TextStyle(
//                                                             fontSize: 12)),
//                                                   )
//                                                 : SizedBox(),
//                                           ),
//                                           (widget.type == Type.report)
//                                               ? ElevatedButton(
//                                                   style:
//                                                       ElevatedButton.styleFrom(
//                                                           primary: Colors.blue),
//                                                   onPressed: () => Get.to(() =>
//                                                       ReportSurveyForm(
//                                                           isEdit: true,
//                                                           data: item)),
//                                                   child: Text('Edit',
//                                                       style: TextStyle(
//                                                           fontSize: 12)),
//                                                 )
//                                               : SizedBox(),
//                                         ],
//                                       ),
//                                       // Column(
//                                       //     children: item.jobs!.map((e) {
//                                       //   return Column(
//                                       //       children: e.image!
//                                       //           .map((e) => Image.network(e.src!))
//                                       //           .toList());
//                                       // }).toList()),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.to(
//           () => ReportSurveyForm(isEdit: false),
//         ),
//         backgroundColor: Colors.blue,
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   Widget rowWidget(Widget right, left) {
//     return Row(
//         mainAxisAlignment: (widget.type == Type.report)
//             ? MainAxisAlignment.spaceBetween
//             : MainAxisAlignment.center,
//         children: [right, left]);
//   }
// }
