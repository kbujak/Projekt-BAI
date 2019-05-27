class LocationInfo {
  final String formatted;


  LocationInfo({this.formatted});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      formatted: json['results'][0]['formatted'],
    );
  }

}