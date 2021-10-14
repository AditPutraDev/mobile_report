part of 'models.dart';

IndexSurvey indexSurveyFromJson(String str) =>
    IndexSurvey.fromJson(json.decode(str));

class IndexSurvey {
  IndexSurvey({
    this.data,
    this.htmlLinks,
    this.total,
    this.hasMorePage,
    this.currentPage,
  });

  List<Datum>? data;
  String? htmlLinks;
  int? total;
  bool? hasMorePage;
  int? currentPage;

  factory IndexSurvey.fromJson(Map<String, dynamic> json) => IndexSurvey(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        htmlLinks: json["html_links"],
        total: json["total"],
        hasMorePage: json["has_more_page"],
        currentPage: json["current_page"],
      );
}

class Datum {
  Datum({
    this.id,
    this.surveyScheduleId,
    this.existingLandArea,
    this.existingBuildingArea,
    this.landArea,
    this.buildingArea,
    this.budget,
    this.requestDate,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.createdByName,
    this.nameConsument,
    this.subjekJadwal,
    this.dateEnd,
    this.dateStart,
    this.deskripsi,
    this.order,
    this.workType,
    this.locatioanAccesses,
    this.accessRoad,
    this.landContours,
    this.foot,
    this.materials,
    this.uPrice,
    this.jobs,
    this.workMethod,
    this.structure,
    this.wall,
  });

  int? id;
  int? surveyScheduleId;
  String? existingLandArea;
  String? existingBuildingArea;
  String? landArea;
  String? buildingArea;
  String? budget;
  DateTime? requestDate;
  String? note;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdByName;
  String? nameConsument;
  String? subjekJadwal;
  String? dateStart;
  String? dateEnd;
  String? deskripsi;
  List<Order>? order;
  List<WorkType>? workType;
  List<LocationAccesses>? locatioanAccesses;
  List<Road>? accessRoad;
  List<LandContours>? landContours;
  List<FootprintCircumstances>? foot;
  List<Materials>? materials;
  List<Uprice>? uPrice;
  List<JobsX>? jobs;
  List<WorkMethodX>? workMethod;
  List<StructureConditionX>? structure;
  List<WallConditionX>? wall;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        surveyScheduleId: json["survey_schedule_id"],
        existingLandArea: json["existing_land_area"],
        existingBuildingArea: json["existing_building_area"],
        landArea: json["land_area"],
        buildingArea: json["building_area"],
        budget: json["budget"],
        requestDate: json["request_date"] == null
            ? null
            : DateTime.parse(json["request_date"]),
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdByName: json["created_by_name"],
        nameConsument: json["survey_schedule"]["order"]["customer_name"],
        subjekJadwal: json["survey_schedule"]["name"],
        dateEnd: json["survey_schedule"]["from_date"],
        dateStart: json["survey_schedule"]["to_date"],
        deskripsi: json["survey_schedule"]["description"],
        order: List<Order>.from(json["services"].map((x) => Order.fromJson(x))),
        workType: List<WorkType>.from(
            json["work_types"].map((x) => WorkType.fromJson(x))),
        locatioanAccesses: List<LocationAccesses>.from(
            json["location_accesses"].map((x) => LocationAccesses.fromJson(x))),
        accessRoad:
            List<Road>.from(json["access_roads"].map((x) => Road.fromJson(x))),
        landContours: List<LandContours>.from(
            json["land_contours"].map((x) => LandContours.fromJson(x))),
        foot: List<FootprintCircumstances>.from(json["footprint_circumstances"]
            .map((x) => FootprintCircumstances.fromJson(x))),
        materials: List<Materials>.from(
            json["materials"].map((x) => Materials.fromJson(x))),
        uPrice: List<Uprice>.from(
            json["unit_prices"].map((x) => Uprice.fromJson(x))),
        jobs: List<JobsX>.from(
            json["job_summaries"].map((x) => JobsX.fromJson(x))),
        workMethod: List<WorkMethodX>.from(
            json["work_methods"].map((x) => WorkMethodX.fromJson(x))),
        structure: List<StructureConditionX>.from(json["structure_condition"]
            .map((x) => StructureConditionX.fromJson(x))),
        wall: List<WallConditionX>.from(
            json["wall_condition"].map((x) => WallConditionX.fromJson(x))),
      );
}

class JobsX {
  int? id;
  String? name;
  String? cases;
  String? suggestion;
  int? totalPrice;
  String? price;
  List<ImageSourceX>? image;
  List<ImageX>? imageJob;

  JobsX(
      {this.id,
      this.name,
      this.cases,
      this.suggestion,
      this.totalPrice,
      this.price,
      this.image,
      this.imageJob});
  factory JobsX.fromJson(Map<String, dynamic> map) {
    return JobsX(
      id: map['id'],
      name: map['unit_price'] == null ? null : map['unit_price']['name'],
      cases: map['case'],
      suggestion: map['suggestion'],
      totalPrice: map['total_prices'],
      price: map['unit_price'] == null
          ? null
          : map['unit_price']['prices'].toString(),
      image: List<ImageSourceX>.from(
          map["image_sources"].map((x) => ImageSourceX.fromJson(x))),
      imageJob: map['unit_price'] == null
          ? null
          : List<ImageX>.from(
              map['unit_price']["image_sources"].map((x) => ImageX.fromJob(x))),
    );
  }
}

class ImageSourceX {
  String? src;
  String? fullname;
  ImageSourceX({this.src, this.fullname});
  factory ImageSourceX.fromJson(Map<String, dynamic> map) {
    return ImageSourceX(src: map['src'],fullname: map['fullname']);
  }
}

class Uprice {
  int? id;
  String? name;
  int? totalPrice;
  String? volume;

  Uprice({this.id, this.name, this.totalPrice, this.volume});
  factory Uprice.fromJson(Map<String, dynamic> map) {
    return Uprice(
        id: map['id'],
        name: map['name'],
        totalPrice: map['total_prices'],
        volume: map['pivot']['volume']);
  }
}

class Materials {
  int? id;
  String? name;

  Materials({this.id, this.name});
  factory Materials.fromJson(Map<String, dynamic> map) {
    return Materials(id: map['id'], name: map['name']);
  }
}

class FootprintCircumstances {
  int? id;
  String? name;

  FootprintCircumstances({this.id, this.name});
  factory FootprintCircumstances.fromJson(Map<String, dynamic> map) {
    return FootprintCircumstances(id: map['id'], name: map['name']);
  }
}

class LandContours {
  int? id;
  String? name;

  LandContours({this.id, this.name});
  factory LandContours.fromJson(Map<String, dynamic> map) {
    return LandContours(id: map['id'], name: map['name']);
  }
}

class Road {
  int? id;
  String? name;

  Road({this.id, this.name});
  factory Road.fromJson(Map<String, dynamic> map) {
    return Road(id: map['id'], name: map['name']);
  }
}

class WorkType {
  int? id;
  String? name;

  WorkType({this.id, this.name});
  factory WorkType.fromJson(Map<String, dynamic> map) {
    return WorkType(id: map['id'], name: map['name']);
  }
}

class LocationAccesses {
  int? id;
  String? name;

  LocationAccesses({this.id, this.name});
  factory LocationAccesses.fromJson(Map<String, dynamic> map) {
    return LocationAccesses(id: map['id'], name: map['name']);
  }
}

class Order {
  int id;
  String title;
  Order({this.id = 0, this.title = ''});
  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      title: map['title'],
    );
  }
}

class SurveyShcedulePicker {
  int? id;
  String? text;
  String? businessCategory;

  SurveyShcedulePicker({this.id, this.text, this.businessCategory});
  factory SurveyShcedulePicker.fromJson(Map<String, dynamic> map) {
    return SurveyShcedulePicker(
        id: map['id'],
        text: map['text'],
        businessCategory: map['business_category']);
  }
}

class ServicePicker {
  int? id;
  String? text;

  ServicePicker({this.id, this.text});
  factory ServicePicker.fromJson(Map<String, dynamic> map) {
    return ServicePicker(id: map['id'], text: map['text']);
  }
}

class WorkTypePicker {
  int? id;
  String? text;

  WorkTypePicker({this.id, this.text});
  factory WorkTypePicker.fromJson(Map<String, dynamic> map) {
    return WorkTypePicker(id: map['id'], text: map['text']);
  }
}

class WorkMethodX {
  int? id;
  String? name;
  WorkMethodX({this.id, this.name});
  factory WorkMethodX.fromJson(Map<String, dynamic> map) {
    return WorkMethodX(id: map['id'], name: map['name']);
  }
}

class WorkMethodPicker {
  int? id;
  String? name;
  WorkMethodPicker({this.id, this.name});
  factory WorkMethodPicker.fromJson(Map<String, dynamic> map) {
    return WorkMethodPicker(id: map['id'], name: map['text']);
  }
}

class MaterialPicker {
  int? id;
  String? text;

  MaterialPicker({this.id, this.text});
  factory MaterialPicker.fromJson(Map<String, dynamic> map) {
    return MaterialPicker(id: map['id'], text: map['text']);
  }
}

class LocationPicker {
  int? id;
  String? text;

  LocationPicker({this.id, this.text});
  factory LocationPicker.fromJson(Map<String, dynamic> map) {
    return LocationPicker(id: map['id'], text: map['text']);
  }
}

class AccessRoad {
  int? id;
  String? text;

  AccessRoad({this.id, this.text});
  factory AccessRoad.fromJson(Map<String, dynamic> map) {
    return AccessRoad(id: map['id'], text: map['text']);
  }
}

class LandContour {
  int? id;
  String? text;

  LandContour({this.id, this.text});
  factory LandContour.fromJson(Map<String, dynamic> map) {
    return LandContour(id: map['id'], text: map['text']);
  }
}

class FootprintCircumstance {
  int? id;
  String? text;

  FootprintCircumstance({this.id, this.text});
  factory FootprintCircumstance.fromJson(Map<String, dynamic> map) {
    return FootprintCircumstance(id: map['id'], text: map['text']);
  }
}

class UnitPrice {
  int? id;
  String? text;
  int? totalPrice;

  UnitPrice({this.id, this.text, this.totalPrice});
  factory UnitPrice.fromJson(Map<String, dynamic> map) {
    return UnitPrice(
        id: map['id'], text: map['text'], totalPrice: map['total_prices']);
  }
}

class ImageX {
  String? name;
  String? image;

  ImageX({this.name, this.image});
  factory ImageX.fromJson(Map<String, dynamic> map) {
    return ImageX(name: map['name'], image: map['image']);
  }

  factory ImageX.fromJob(Map<String, dynamic> map) {
    return ImageX(name: map['filename'], image: map['src']);
  }
}

class ServiceCategory {
  int? id;
  String? title;

  ServiceCategory({this.id, this.title});
  factory ServiceCategory.fromJson(Map<String, dynamic> map) {
    return ServiceCategory(id: map['id'], title: map['title']);
  }
}

class Cabang {
  int? id;
  String? name;
  int? serviceCategoryId;
  Cabang({this.id, this.name, this.serviceCategoryId});
  factory Cabang.fromJson(Map<String, dynamic> map) {
    return Cabang(
      id: map['id'],
      name: map['name'],
      serviceCategoryId: map['id'],
    );
  }
}

class StructureConditionX {
  int? id;
  String? name;

  StructureConditionX({this.id, this.name});
  factory StructureConditionX.fromJson(Map<String, dynamic> map) {
    return StructureConditionX(id: map['id'], name: map['name']);
  }
}

class StructureCondition {
  int? id;
  String? text;

  StructureCondition({this.id, this.text});
  factory StructureCondition.fromJson(Map<String, dynamic> map) {
    return StructureCondition(id: map['id'], text: map['text']);
  }
}

class WallConditionX {
  int? id;
  String? name;

  WallConditionX({this.id, this.name});
  factory WallConditionX.fromJson(Map<String, dynamic> map) {
    return WallConditionX(id: map['id'], name: map['name']);
  }
}

class WallCondition {
  int? id;
  String? text;

  WallCondition({this.id, this.text});
  factory WallCondition.fromJson(Map<String, dynamic> map) {
    return WallCondition(id: map['id'], text: map['text']);
  }
}
