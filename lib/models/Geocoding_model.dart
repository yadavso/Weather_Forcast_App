class Geocoding {
  List<Results>? results;
  double? generationtimeMs;

  Geocoding({this.results, this.generationtimeMs});

  Geocoding.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    generationtimeMs = json['generationtime_ms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['generationtime_ms'] = this.generationtimeMs;
    return data;
  }
}

class Results {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  double? elevation;
  String? featureCode;
  String? countryCode;
  int? admin1Id;
  int? admin2Id;
  String? timezone;
  int? population;
  int? countryId;
  String? country;
  String? admin1;
  String? admin2;
  int? admin3Id;
  String? admin3;
  int? admin4Id;
  String? admin4;

  Results(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.elevation,
      this.featureCode,
      this.countryCode,
      this.admin1Id,
      this.admin2Id,
      this.timezone,
      this.population,
      this.countryId,
      this.country,
      this.admin1,
      this.admin2,
      this.admin3Id,
      this.admin3,
      this.admin4Id,
      this.admin4});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    elevation = json['elevation'];
    featureCode = json['feature_code'];
    countryCode = json['country_code'];
    admin1Id = json['admin1_id'];
    admin2Id = json['admin2_id'];
    timezone = json['timezone'];
    population = json['population'];
    countryId = json['country_id'];
    country = json['country'];
    admin1 = json['admin1'];
    admin2 = json['admin2'];
    admin3Id = json['admin3_id'];
    admin3 = json['admin3'];
    admin4Id = json['admin4_id'];
    admin4 = json['admin4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['elevation'] = this.elevation;
    data['feature_code'] = this.featureCode;
    data['country_code'] = this.countryCode;
    data['admin1_id'] = this.admin1Id;
    data['admin2_id'] = this.admin2Id;
    data['timezone'] = this.timezone;
    data['population'] = this.population;
    data['country_id'] = this.countryId;
    data['country'] = this.country;
    data['admin1'] = this.admin1;
    data['admin2'] = this.admin2;
    data['admin3_id'] = this.admin3Id;
    data['admin3'] = this.admin3;
    data['admin4_id'] = this.admin4Id;
    data['admin4'] = this.admin4;
    return data;
  }
}
