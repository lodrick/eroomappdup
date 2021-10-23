import 'package:flutter/cupertino.dart';

class Province {
  @required
  final String city;
  @required
  final String lat;
  @required
  final String lng;
  @required
  final String country;
  @required
  final String iso2;
  @required
  final String adminName;
  @required
  final String capital;
  @required
  final String population;
  @required
  final String populationProper;

  Province({
    this.city,
    this.lat,
    this.lng,
    this.country,
    this.iso2,
    this.adminName,
    this.capital,
    this.population,
    this.populationProper,
  });

  Province copyWith({
    String city,
    String lat,
    String lng,
    String country,
    String iso2,
    String adminName,
    String capital,
    String population,
    String populationProper,
  }) =>
      Province(
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        country: country ?? this.country,
        iso2: iso2 ?? this.iso2,
        adminName: adminName ?? this.adminName,
        capital: capital ?? this.capital,
        population: population ?? this.population,
        populationProper: populationProper ?? this.populationProper,
      );

  static Province fromJson(Map<String, dynamic> json) => Province(
        city: json['city'],
        lat: json['lat'],
        lng: json['lng'],
        country: json['country'],
        iso2: json['iso2'],
        adminName: json['admin_name'],
        capital: json['capital'],
        population: json['population'],
        populationProper: json['population_proper'],
      );

  Map<String, dynamic> toJson() => {
        'city': city,
        'lat': lat,
        'lng': lng,
        'country': country,
        'iso2': iso2,
        'admin_name': adminName,
        'capital': capital,
        'population': population,
        'population_proper': populationProper,
      };
}
