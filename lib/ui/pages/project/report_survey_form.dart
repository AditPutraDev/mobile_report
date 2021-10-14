part of '../pages.dart';

class ReportSurveyForm extends StatefulWidget {
  final bool isEdit;
  final Datum? data;
  ReportSurveyForm({this.isEdit = false, this.data});
  @override
  _ReportSurveyFormState createState() => _ReportSurveyFormState();
}

class _ReportSurveyFormState extends State<ReportSurveyForm> {
  SurveyShcedulePicker? shcedulePicker;
  WorkTypePicker? workPicker;
  UnitPrice? unitPrice;
  ServiceCategory? service;
  Cabang? cabang;
  List<ServicePicker>? listServicePicker;
  List<WorkTypePicker>? listWorkPicker;
  List<WorkMethodPicker>? listWorkMethod;
  List<MaterialPicker>? listMaterial;
  List<LocationPicker>? listLoc;
  List<AccessRoad>? listRoad;
  List<LandContour>? listLand;
  List<WallCondition>? wall;
  List<StructureCondition>? structure;
  List<FootprintCircumstance>? listFootprint;
  TextEditingController budgetCT = TextEditingController();
  TextEditingController existingLandArea = TextEditingController();
  TextEditingController existingBuildingArea = TextEditingController();
  TextEditingController existingLandArealistFootprint = TextEditingController();
  TextEditingController buildingArea = TextEditingController();
  TextEditingController landArea = TextEditingController();
  TextEditingController note = TextEditingController();

  DateTime? _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  var formatter = DateFormat("yyyy-MM-dd");
  List<AHSform> vPekerjaan = [];
  List<JobSummariesForm> vJob = [];
  List<Map<String, dynamic>> dataAHS = [];
  List<Map<String, dynamic>> dataJob = [];
  List<Map<String, dynamic>> dataImage = [];
  String title = 'Tambah';
  var uuid = Uuid();
  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      title = 'Edit';
      budgetCT.text = widget.data!.budget!;
      existingBuildingArea.text = widget.data!.existingBuildingArea ?? '-';
      existingLandArea.text = widget.data!.existingLandArea ?? '-';
      buildingArea.text = widget.data!.buildingArea ?? '-';
      landArea.text = widget.data!.landArea ?? '-';
      note.text = widget.data!.note ?? '-';
      _selectedDay = widget.data!.requestDate ?? _focusedDay;
      _focusedDay = widget.data!.requestDate ?? _focusedDay;

      vPekerjaan = widget.data!.uPrice!.map((e) {
        var id = uuid.v1();
        var newAHS = AHS(id, title: e.name!, volume: e.volume!);
        return AHSform(
          id,
          user: newAHS,
          onDelete: () {
            return onDelete(id);
          },
          textEditingController: TextEditingController(),
        );
      }).toList();

      vJob = widget.data!.jobs!.map((e) {
        var id = uuid.v1();
        var newJobs = Jobs(id,
            idSummeries: e.id!,
            ahs: e.name ?? '',
            kasus: e.cases!,
            harga: e.totalPrice == null ? '' : e.totalPrice.toString(),
            saran: e.suggestion!,
            image: e.image!);
        return JobSummariesForm(id,
            job: newJobs, isDelete: () => onDeleteJob(newJobs));
      }).toList();
    }
  }

  @override
  void dispose() {
    budgetCT.dispose();
    existingBuildingArea.dispose();
    existingLandArea.dispose();
    buildingArea.dispose();
    landArea.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final survey = Get.find<SurveyController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text('$title Laporan Survey')),
      body: SingleChildScrollView(
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 12),
            children: [
              SizedBox(height: 24),
              labelText('Referensi Jadwal Survey'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Text(
                    (shcedulePicker == null)
                        ? (widget.isEdit == true && widget.data != null)
                            ? widget.data!.subjekJadwal ?? ''
                            : 'Pilih Referensi Jadwal Survey'
                        : shcedulePicker!.text ?? '',
                    style: TextStyle(
                        color: (shcedulePicker == null && widget.data == null)
                            ? Colors.grey
                            : Colors.black),
                  ),
                  onTap: () {
                    Get.to(() => ListSchedule())!.then((value) {
                      if (value != null && value is SurveyShcedulePicker) {
                        shcedulePicker = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Kategori Bisnis'),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                  hintStyle: TextStyle(
                      color: (shcedulePicker == null)
                          ? Colors.grey
                          : Colors.black),
                  hintText: shcedulePicker == null ||
                          shcedulePicker!.businessCategory == null
                      ? '-'
                      : shcedulePicker!.businessCategory,
                ),
              ),
              labelText('Jasa'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listServicePicker == null && widget.data == null)
                          Text(
                            'Pilih Jasa',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null &&
                            listServicePicker == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.order!
                                  .map((e) => Text('${e.title}, '))
                                  .toList())
                        else if (listServicePicker != null)
                          Text(
                              '${listServicePicker!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => ServicePickerPage())!.then((value) {
                      if (value != null && value is List<ServicePicker>) {
                        listServicePicker = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Jenis Pekerjaan'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listWorkPicker == null && widget.data == null)
                          Text(
                            'Pilih Jenis Pekerjaan',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listWorkPicker == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.workType!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listWorkPicker != null)
                          Text(
                              '${listWorkPicker!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => WorkPickerPage())!.then((value) {
                      if (value != null && value is List<WorkTypePicker>) {
                        listWorkPicker = value;
                        setState(() {});
                        print(listWorkPicker!.map((e) => e.id).toList());
                      }
                    });
                  },
                ),
              ),
              labelText('Metode Kerja'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listWorkMethod == null && widget.data == null)
                          Text(
                            'Pilih Metode Kerja',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listWorkMethod == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.workMethod!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listWorkMethod != null)
                          Text(
                              '${listWorkMethod!.map((e) => e.name).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => WorkMethodPickerPage())!.then((value) {
                      if (value != null && value is List<WorkMethodPicker>) {
                        listWorkMethod = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Material/Chemical'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listMaterial == null && widget.data == null)
                          Text(
                            'Pilih Material',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listMaterial == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.materials!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listMaterial != null)
                          Text('${listMaterial!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => MaterialPickerPage())!.then((value) {
                      if (value != null && value is List<MaterialPicker>) {
                        listMaterial = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Akses Lokasi'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listLoc == null && widget.data == null)
                          Text(
                            'Pilih Akses Lokasi',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listLoc == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.locatioanAccesses!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listLoc != null)
                          Text('${listLoc!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => LocationPickerPage())!.then((value) {
                      if (value != null && value is List<LocationPicker>) {
                        listLoc = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Akses  Jalan'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listRoad == null && widget.data == null)
                          Text(
                            'Pilih Akses  Jalan',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listRoad == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.accessRoad!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listRoad != null)
                          Text('${listRoad!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => RoadPickerPage())!.then((value) {
                      if (value != null && value is List<AccessRoad>) {
                        listRoad = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Contur Tanah'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listLand == null && widget.data == null)
                          Text(
                            'Pilih Contur Tanah',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listLand == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.landContours!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listLand != null)
                          Text('${listLand!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => LandPickerPage())!.then((value) {
                      if (value != null && value is List<LandContour>) {
                        listLand = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Keadaan Tapak'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (listFootprint == null && widget.data == null)
                          Text(
                            'Pilih Keadaan Tapak',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && listFootprint == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.foot!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (listFootprint != null)
                          Text(
                              '${listFootprint!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => FootPickerPage())!.then((value) {
                      if (value != null &&
                          value is List<FootprintCircumstance>) {
                        listFootprint = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Keadaan Struktur'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (structure == null && widget.data == null)
                          Text(
                            'Pilih Keadaan Struktur',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && structure == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.structure!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (structure != null)
                          Text('${structure!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => StructurePage())!.then((value) {
                      if (value != null && value is List<StructureCondition>) {
                        structure = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Keadaan Dinding'),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white),
                child: ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (wall == null && widget.data == null)
                          Text(
                            'Pilih Keadaan Dinding',
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (widget.data != null && wall == null)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.data!.wall!
                                  .map((e) => Text('${e.name}, '))
                                  .toList())
                        else if (wall != null)
                          Text('${wall!.map((e) => e.text).toString()}')
                      ]),
                  onTap: () {
                    Get.to(() => WallPage())!.then((value) {
                      if (value != null && value is List<WallCondition>) {
                        wall = value;
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              labelText('Luas Tanah Permintaan'),
              TextField(
                controller: landArea,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Luas Tanah Permintaan'),
              ),
              labelText('Luas Bangunan Permintaan'),
              TextField(
                controller: buildingArea,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Luas Bangunan Permintaan'),
              ),
              labelText('Luas Tanah Yang Sudah Ada'),
              TextField(
                controller: existingLandArea,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Luas Tanah Yang Sudah Ada'),
              ),
              labelText('Luas Bangunan Yang Sudah Ada'),
              TextField(
                controller: existingBuildingArea,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Luas Bangunan Yang Sudah Ada'),
              ),
              labelText('Budget'),
              TextField(
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    locale: 'id',
                    decimalDigits: 0,
                    symbol: '',
                  )
                ],
                controller: budgetCT,
                style: TextStyle(
                  color: Color(0xFF43A8FC),
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none,
                  ),
                  prefix: Text('Rp '),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: 'Budget',
                ),
              ),
              labelText('Request Tanggal Pekerjaan'),
              //Calender
              Container(
                padding: EdgeInsets.only(
                  bottom: 25,
                  left: 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: TableCalendar(
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay!,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    availableCalendarFormats: {
                      CalendarFormat.month: 'Months',
                    },
                    selectedDayPredicate: (day) {
                      // Use `selectedDayPredicate` to determine which day is currently selected.
                      // If this returns true, then `day` will be marked as selected.

                      // Using `isSameDay` is recommended to disregard
                      // the time-part of compared DateTime objects.
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        // Call `setState()` when updating the selected day
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          print(_selectedDay);
                          print(formatter.format(_selectedDay!.toLocal()));
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      // No need to call `setState()` here
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
              ),
              labelText('Volume Pekerjaan'),
              vPekerjaan.length <= 0
                  ? Center(child: labelText('Data masih kosong'))
                  : SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        addAutomaticKeepAlives: true,
                        itemCount: vPekerjaan.length,
                        itemBuilder: (ctx, i) => vPekerjaan[i],
                      ),
                    ),
              TextButton.icon(
                  onPressed: onAddForm,
                  icon: Icon(Icons.add),
                  label: Text('Tambah Volume Pekerjaan')),
              labelText('Daftar Ringkasan Pekerjaan'),
              vJob.length <= 0
                  ? Center(child: labelText('Data masih kosong'))
                  : SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        addAutomaticKeepAlives: true,
                        itemCount: vJob.length,
                        itemBuilder: (ctx, i) => vJob[i],
                      ),
                    ),
              TextButton.icon(
                  onPressed: onAddFormJob,
                  icon: Icon(Icons.add),
                  label: Text('Tambah Ringkasan Pekerjaan')),
              labelText('Catatan'),
              TextField(
                minLines: 1,
                maxLines: 10,
                controller: note,
                style: TextStyle(
                  color: Color(0xFF43A8FC),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(30, 16, 0, 16),
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: 'Catatan',
                ),
              ),
              SizedBox(height: 12),
              Obx(
                () => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: () async {
                    if (shcedulePicker == null && widget.isEdit != true) {
                      showBotToastText('Isian referensi jadwal wajib diisi');
                    } else if (listServicePicker == null &&
                        widget.isEdit != true) {
                      showBotToastText('Isian jasa wajib diisi');
                    } else if (listWorkPicker == null &&
                        widget.isEdit != true) {
                      showBotToastText('Isian jenis pekerjaan wajib diisi');
                    }
                    // } else if (listWorkMethodd == null) {
                    //   showBotToastText('Isian metode kerja wajib diisi');
                    // } else if (listLocd == null) {
                    //   showBotToastText(
                    //       'Isian location accesses wajib diisi');
                    // } else if (listRoadd == null) {
                    //   showBotToastText('Isian access roads wajib diisi');
                    // } else if (listLanddd == null) {
                    //   showBotToastText('Isian land contours wajib diisi');
                    // } else if (listFootprintdd == null) {
                    //   showBotToastText(
                    //       'Isian footprint circumstances wajib diisi');
                    // } else if (structuredd == null) {
                    //   showBotToastText(
                    //       'Isian structure condition wajib diisi');
                    // } else if (walldd == null) {
                    //   showBotToastText(
                    //       'Isian wall condition wajib diisi');
                    // } else if (landAreadd.text == '') {
                    //   showBotToastText('Isian land area wajib diisi');
                    // } else if (buildingAreadd.text == '') {
                    //   showBotToastText('Isian building area wajib diisi');
                    // } else if (existingLandAreadd.text == '') {
                    //   showBotToastText(
                    //       'Isian existing land area wajib diisi');
                    // } else if (existingBuildingAreadd.text == '') {
                    //   showBotToastText(
                    //       'Isian existing building area wajib diisi');
                    // } else if (budgetCTdd.text == '') {
                    //   showBotToastText('Isian budget wajib diisi');
                    // } else if (_selectedDay == null) {
                    //   showBotToastText('Isian request date wajib diisi');
                    // }
                    dataAHS.clear();
                    dataJob.clear();
                    dataImage.clear();
                    await onSave();
                    await onSaveJob();
                    setState(() {});

                    Map<String, dynamic> data = {
                      if (widget.isEdit == true) "_method": "put",
                      "origin": "android",
                      "survey_schedule_id": (shcedulePicker == null)
                          ? widget.data!.surveyScheduleId!
                          : shcedulePicker!.id,
                      "site_project_id": authController.getCabangId(),
                      "existing_land_area": existingLandArea.text,
                      "existing_building_area": existingBuildingArea.text,
                      "land_area": landArea.text,
                      "building_area": buildingArea.text,
                      "budget": budgetCT.text.replaceAll(".", ""),
                      "request_date": (_selectedDay == null)
                          ? ""
                          : formatter.format(_selectedDay!.toLocal()),
                      "note": note.text,
                      "work_types": (listWorkPicker != null)
                          ? listWorkPicker!.map((e) => e.id).toList()
                          : (listWorkPicker == null && widget.isEdit == true)
                              ? widget.data!.workType!.map((e) => e.id).toList()
                              : null,
                      "services": (listServicePicker != null)
                          ? listServicePicker!.map((e) => e.id).toList()
                          : widget.data!.order!.map((e) => e.id).toList(),
                      "work_methods": (listWorkMethod != null)
                          ? listWorkMethod!.map((e) => e.id).toList()
                          : (listWorkMethod == null && widget.isEdit == true)
                              ? widget.data!.workMethod!
                                  .map((e) => e.id)
                                  .toList()
                              : null,
                      "materials": (listMaterial != null)
                          ? listMaterial!.map((e) => e.id).toList()
                          : (listMaterial == null && widget.isEdit == true)
                              ? widget.data!.materials!
                                  .map((e) => e.id)
                                  .toList()
                              : null,
                      "job_summaries": dataJob,
                      "location_accesses": (listLoc != null)
                          ? listLoc!.map((e) => e.id).toList()
                          : (listLoc == null && widget.isEdit == true)
                              ? widget.data!.locatioanAccesses!
                                  .map((e) => e.id)
                                  .toList()
                              : null,
                      "access_roads": (listRoad != null)
                          ? listRoad!.map((e) => e.id).toList()
                          : (listRoad == null && widget.isEdit == true)
                              ? widget.data!.accessRoad!
                                  .map((e) => e.id)
                                  .toList()
                              : null,
                      "land_contours": (listLand != null)
                          ? listLand!.map((e) => e.id).toList()
                          : (listLand == null && widget.isEdit == true)
                              ? widget.data!.landContours!
                                  .map((e) => e.id)
                                  .toList()
                              : null,
                      "footprint_circumstances": (listFootprint != null)
                          ? listFootprint!.map((e) => e.id).toList()
                          : (listFootprint == null && widget.isEdit == true)
                              ? widget.data!.foot!.map((e) => e.id).toList()
                              : null,
                      "structure_condition": (structure != null)
                          ? structure!.map((e) => e.id).toList()
                          : (structure == null && widget.isEdit == true)
                              ? widget.data!.structure!
                                  .map((e) => e.id)
                                  .toList()
                              : null,
                      "wall_condition": (wall != null)
                          ? wall!.map((e) => e.id).toList()
                          : (wall == null && widget.isEdit == true)
                              ? widget.data!.wall!.map((e) => e.id).toList()
                              : null,
                      "unit_prices": (dataAHS.isNotEmpty) ? dataAHS : [],
                    };
                    (widget.isEdit == true)
                        ? survey.updateSurvey(data, widget.data!.id!)
                        : survey.createSurvey(data);
                  },
                  icon: Icon(Icons.done),
                  label: survey.isLoading.value
                      ? loadingBounceIndicator
                      : Text('Simpan'),
                ),
              ),
              SizedBox(height: 12),
            ]),
      ),
    );
  }

  ///on form user deleted
  void onDelete(String id) {
    var find = vPekerjaan.firstWhere(
      (it) => it.id == id,
    );
    print(find);

    vPekerjaan.removeWhere((element) => element.id == find.id);

    vPekerjaan.remove(find.user);

    print(vPekerjaan);
    setState(() {});
  }

  void onDeleteJob(Jobs _job) {
    setState(() {
      var find = vJob.firstWhere(
        (it) => it.id == _job.id,
      );
      vJob.removeWhere((element) {
        return element.id == find.id;
      });
    });
  }

  ///on add form
  void onAddForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      var _id = uuid.v1();
      var _user = AHS(_id);
      vPekerjaan.add(AHSform(_id,
          user: _user,
          onDelete: () => onDelete(_id),
          textEditingController: TextEditingController()));
    });
  }

  void onAddFormJob() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      var _id = uuid.v1();
      var _job = Jobs(_id);
      vJob.add(JobSummariesForm(_id,
          job: _job,
          isDelete: () => onDeleteJob(_job),
          kasus: TextEditingController(),
          saran: TextEditingController(),
          hargaJual: TextEditingController()));
    });
  }

  ///on save forms
  onSaveJob() {
    if (vJob.length > 0) {
      var allValids = true;
      vJob.forEach((form) => allValids = allValids && form.isValid());
      if (allValids) {
        //var data = vPekerjaan.map((it) => it.user).toList();
        vJob.forEach((element) {
          element.job!.image!.forEach((e) {
            return dataImage.add({
              "name": e.fullname,
              "image": e.src,
            });
          });
          return dataJob.add({
            "images": dataImage,
            "case": element.job!.kasus,
            "suggestion": element.job!.saran,
            "unit_price_id": element.job!.id,
            if (widget.isEdit == true) "removed_images": [],
          });
        });
        print(dataJob);
        logger.v(dataJob);
      }
    }
  }

  onSave() {
    if (vPekerjaan.length > 0) {
      var allValid = true;
      vPekerjaan.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        //var data = vPekerjaan.map((it) => it.user).toList();
        vPekerjaan.forEach((element) {
          return dataAHS.add({
            "unit_price_id": element.user!.id,
            "volume": element.user!.volume,
          });
        });
        print(dataAHS);
      }
    }
  }
}

Widget labelText(String label) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      label,
      style: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );
}
