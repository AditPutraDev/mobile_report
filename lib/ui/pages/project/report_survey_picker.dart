part of '../pages.dart';

class ListSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShceduleController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Referensi Jadwal Survey'),
      ),
      body: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.listShcedule.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.listShcedule.length) {
              return controller.isLoading.value
                  ? Center(
                      child: Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.red[900],
                        ),
                      ),
                    )
                  : (controller.listShcedule.isEmpty)
                      ? Center(child: labelText('Data tidak ditemukan'))
                      : Container();
            } else {
              return GestureDetector(
                onTap: () {
                  Get.back(result: controller.listShcedule[index]);
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(controller.listShcedule[index].text ?? ''),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Color setTextColor(List<bool> selected, int index) {
  return selected[index] ? Colors.white : Colors.black;
}

Color setColor(List<bool> selected, int index) {
  return selected[index] ? mainColor : Colors.white;
}

class ServicePickerPage extends StatefulWidget {
  @override
  _ServicePickerPageState createState() => _ServicePickerPageState();
}

class _ServicePickerPageState extends State<ServicePickerPage> {
  List<bool> listSelectedJasa = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Jasa'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listService.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.listService.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.listService.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<ServicePicker> servicePick = controller.listService;
                      servicePick.forEach((element) {
                        listSelectedJasa.add(false);
                      });

                      return GestureDetector(
                        onTap: () {
                          if (listSelectedJasa[index]) {
                            controller.removeJasa(servicePick[index]);
                          } else {
                            controller.addJasa(servicePick[index]);
                          }
                          setState(() {
                            listSelectedJasa[index] = !listSelectedJasa[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.listService[index].text}',
                          color: setColor(listSelectedJasa, index),
                          textColor: setTextColor(listSelectedJasa, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedJasa);
          },
        ));
  }
}

class WorkPickerPage extends StatefulWidget {
  @override
  _WorkPickerPageState createState() => _WorkPickerPageState();
}

class _WorkPickerPageState extends State<WorkPickerPage> {
  List<bool> listSelectedWork = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Jenis Pekerjaan'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listWork.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.listWork.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.listWork.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<WorkTypePicker> workPick = controller.listWork;
                      workPick.forEach((element) {
                        listSelectedWork.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelectedWork[index]) {
                            controller.removeWork(workPick[index]);
                          } else {
                            controller.addWork(workPick[index]);
                          }
                          setState(() {
                            listSelectedWork[index] = !listSelectedWork[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.listWork[index].text}',
                          color: setColor(listSelectedWork, index),
                          textColor: setTextColor(listSelectedWork, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedWork);
          },
        ));
  }
}

class WorkMethodPickerPage extends StatefulWidget {
  @override
  _WorkMethodPickerPageState createState() => _WorkMethodPickerPageState();
}

class _WorkMethodPickerPageState extends State<WorkMethodPickerPage> {
  List<bool> listSelectedWork = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkMethodController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Metode Kerja'),
        ),
        body: Obx(
          () => ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.listWorkMethod.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.listWorkMethod.length) {
                return controller.isLoading.value
                    ? Center(
                        child: Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.red[900],
                          ),
                        ),
                      )
                    : Container();
              } else if (controller.listWorkMethod.isEmpty) {
                return Center(child: labelText('Data tidak ditemukan'));
              } else {
                List<WorkMethodPicker> workPick = controller.listWorkMethod;
                workPick.forEach((element) {
                  listSelectedWork.add(false);
                });
                return GestureDetector(
                  onTap: () {
                    if (listSelectedWork[index]) {
                      controller.removeWork(workPick[index]);
                    } else {
                      controller.addWork(workPick[index]);
                    }
                    setState(() {
                      listSelectedWork[index] = !listSelectedWork[index];
                    });
                  },
                  child: ChooseCard(
                    text: '${controller.listWorkMethod[index].name}',
                    color: setColor(listSelectedWork, index),
                    textColor: setTextColor(listSelectedWork, index),
                  ),
                );
              }
            },
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedWorkMethod);
          },
        ));
  }
}

class MaterialPickerPage extends StatefulWidget {
  @override
  _MaterialPickerPageState createState() => _MaterialPickerPageState();
}

class _MaterialPickerPageState extends State<MaterialPickerPage> {
  List<bool> listSelectedMaterial = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaterialController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Material'),
        ),
        body: Obx(
          () => Column(children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.listMaterial.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.listMaterial.length) {
                    return controller.isLoading.value
                        ? Center(
                            child: Center(
                              child: SpinKitCircle(
                                size: 50,
                                color: Colors.red[900],
                              ),
                            ),
                          )
                        : Container();
                  } else if (controller.listMaterial.isEmpty) {
                    return Center(child: labelText('Data tidak ditemukan'));
                  } else {
                    List<MaterialPicker> workPick = controller.listMaterial;
                    workPick.forEach((element) {
                      listSelectedMaterial.add(false);
                    });
                    return GestureDetector(
                      onTap: () {
                        if (listSelectedMaterial[index]) {
                          controller.removeMaterial(workPick[index]);
                        } else {
                          controller.addMaterial(workPick[index]);
                        }
                        setState(() {
                          listSelectedMaterial[index] =
                              !listSelectedMaterial[index];
                        });
                      },
                      child: ChooseCard(
                        text: '${controller.listMaterial[index].text}',
                        color: setColor(listSelectedMaterial, index),
                        textColor: setTextColor(listSelectedMaterial, index),
                      ),
                    );
                  }
                },
              ),
            ),
          ]),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedMaterial);
          },
        ));
  }
}

//==================
class LocationPickerPage extends StatefulWidget {
  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  List<bool> listSelectedLoc = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Akses Lokasi'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listLocation.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.listLocation.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.listLocation.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<LocationPicker> pick = controller.listLocation;
                      pick.forEach((element) {
                        listSelectedLoc.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelectedLoc[index]) {
                            controller.removeLoc(pick[index]);
                          } else {
                            controller.addLoc(pick[index]);
                          }
                          setState(() {
                            listSelectedLoc[index] = !listSelectedLoc[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.listLocation[index].text}',
                          color: setColor(listSelectedLoc, index),
                          textColor: setTextColor(listSelectedLoc, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedLoc);
          },
        ));
  }
}

//==================
class LandPickerPage extends StatefulWidget {
  @override
  _LandPickerPageState createState() => _LandPickerPageState();
}

class _LandPickerPageState extends State<LandPickerPage> {
  List<bool> listSelectedLand = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Contur Tanah'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listLand.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.listLand.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.listLand.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<LandContour> pick = controller.listLand;
                      pick.forEach((element) {
                        listSelectedLand.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelectedLand[index]) {
                            controller.removeLand(pick[index]);
                          } else {
                            controller.addLand(pick[index]);
                          }
                          setState(() {
                            listSelectedLand[index] = !listSelectedLand[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.listLand[index].text}',
                          color: setColor(listSelectedLand, index),
                          textColor: setTextColor(listSelectedLand, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedLand);
          },
        ));
  }
}

//==================
class RoadPickerPage extends StatefulWidget {
  @override
  _RoadPickerPageState createState() => _RoadPickerPageState();
}

class _RoadPickerPageState extends State<RoadPickerPage> {
  List<bool> listSelectedRoad = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoadController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Akses Jalan'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listRoad.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.listRoad.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.listRoad.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<AccessRoad> pick = controller.listRoad;
                      pick.forEach((element) {
                        listSelectedRoad.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelectedRoad[index]) {
                            controller.removeRoad(pick[index]);
                          } else {
                            controller.addRoad(pick[index]);
                          }
                          setState(() {
                            listSelectedRoad[index] = !listSelectedRoad[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.listRoad[index].text}',
                          color: setColor(listSelectedRoad, index),
                          textColor: setTextColor(listSelectedRoad, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedRoad);
          },
        ));
  }
}

//==================
class FootPickerPage extends StatefulWidget {
  @override
  _FootPickerPageState createState() => _FootPickerPageState();
}

class _FootPickerPageState extends State<FootPickerPage> {
  List<bool> listSelected = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FootprintController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Keadaan Tapak'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listFootprint.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.listFootprint.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.listFootprint.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<FootprintCircumstance> pick =
                          controller.listFootprint;
                      pick.forEach((element) {
                        listSelected.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelected[index]) {
                            controller.remove(pick[index]);
                          } else {
                            controller.add(pick[index]);
                          }
                          setState(() {
                            listSelected[index] = !listSelected[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.listFootprint[index].text}',
                          color: setColor(listSelected, index),
                          textColor: setTextColor(listSelected, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selected);
          },
        ));
  }
}

class UnitPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnitController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Analisa Harga Satuan'),
      ),
      body: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.listAhs.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.listAhs.length) {
              return controller.isLoading.value
                  ? Center(
                      child: Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.red[900],
                        ),
                      ),
                    )
                  : Container();
            } else if (controller.listAhs.isEmpty) {
              return Center(child: labelText('Data tidak ditemukan'));
            } else {
              return GestureDetector(
                onTap: () {
                  Get.back(result: controller.listAhs[index]);
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(controller.listAhs[index].text ?? ''),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class StructurePage extends StatefulWidget {
  @override
  _StructurePageState createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {
  List<bool> listSelected = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StructureController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Keadaan Struktur'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.list.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.list.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else if (controller.list.isEmpty) {
                      return Center(child: labelText('Data tidak ditemukan'));
                    } else {
                      List<StructureCondition> pick = controller.list;
                      pick.forEach((element) {
                        listSelected.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelected[index]) {
                            controller.remove(pick[index]);
                          } else {
                            controller.add(pick[index]);
                          }
                          setState(() {
                            listSelected[index] = !listSelected[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.list[index].text}',
                          color: setColor(listSelected, index),
                          textColor: setTextColor(listSelected, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedStructure);
          },
        ));
  }
}

class WallPage extends StatefulWidget {
  @override
  _WallPageState createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  List<bool> listSelected = [];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WallController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Keadaan Dinding'),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.list.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.list.length) {
                      return controller.isLoading.value
                          ? Center(
                              child: Center(
                                child: SpinKitCircle(
                                  size: 50,
                                  color: Colors.red[900],
                                ),
                              ),
                            )
                          : Container();
                    } else {
                      List<WallCondition> pick = controller.list;
                      pick.forEach((element) {
                        listSelected.add(false);
                      });
                      return GestureDetector(
                        onTap: () {
                          if (listSelected[index]) {
                            controller.remove(pick[index]);
                          } else {
                            controller.add(pick[index]);
                          }
                          setState(() {
                            listSelected[index] = !listSelected[index];
                          });
                        },
                        child: ChooseCard(
                          text: '${controller.list[index].text}',
                          color: setColor(listSelected, index),
                          textColor: setTextColor(listSelected, index),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: mainColor),
          child: Text('Simpan'),
          onPressed: () {
            Get.back(result: controller.selectedWall);
          },
        ));
  }
}

class ChooseCard extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  ChooseCard(
      {this.color = Colors.white,
      this.textColor = Colors.black,
      this.text = ''});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      color: color,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          child: Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
        Icon(Icons.done_rounded, color: Colors.white),
      ]),
    );
  }
}
