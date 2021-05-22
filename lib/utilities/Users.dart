import 'dart:convert';

List<User> modelUserFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String modelUserToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String id;
  String booking_status;
  String date;
  String weight;
  String is_cancelled;
  String charges;
  String weight_description;

  User({
    required this.id,
    required this.booking_status,
    required this.date,
    required this.weight,
    required this.is_cancelled,
    required this.charges,
    required this.weight_description,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["booking_id"],
        booking_status: json["booking_status"],
        date: json["date"],
        weight: json["weight"],
        is_cancelled: json["is_cancelled"],
        charges: json["charges"],
        weight_description: json["weight_description"],
      );

  Map<String, dynamic> toJson() => {
        "booking_id": id,
        "booking_status": booking_status,
        "date": date,
        "charges": weight,
        "is_cancelled": is_cancelled,
        "weight": charges,
        "weight_description": weight_description
      };
}

class Reasons {
  String id;
  String reason;

  Reasons({required this.id, required this.reason});

  factory Reasons.fromJson(Map<String, dynamic> json) =>
      Reasons(id: json["id"], reason: json["reason"]);

  Map<String, dynamic> toJson() => {"id": id, "reason": reason};
}

class dtpl {
  String id;
  String heading;
  String description;
  List<Data> homedata;
  dtpl({
    required this.id,
    required this.heading,
    required this.description,
    required this.homedata,
  });

  factory dtpl.fromJson(Map<String, dynamic> json) => dtpl(
        id: json["id"],
        heading: json["heading"],
        description: json["description"],
        homedata:
            List<Data>.from(json["sub_data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "sub_data": List<dynamic>.from(homedata.map((x) => x.toJson())),
      };
}

class Address {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        suite: json["suite"],
        city: json["city"],
        zipcode: json["zipcode"],
        geo: Geo.fromJson(json["geo"]),
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "suite": suite,
        "city": city,
        "zipcode": zipcode,
        "geo": geo.toJson(),
      };
}

class Geo {
  String lat;
  String lng;

  Geo({
    required this.lat,
    required this.lng,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Data {
  String id;
  String image;
  String doctor_name;
  String experience;
  String doctor_category_name;

  Data({
    required this.id,
    required this.image,
    required this.doctor_name,
    required this.experience,
    required this.doctor_category_name,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        image: json["image"],
        doctor_name: json["doctor_name"],
        experience: json["experience"],
        doctor_category_name: json["doctor_category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "doctor_name": doctor_name,
        "experience": experience,
        "doctor_category_name": doctor_category_name,
      };
}
