// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carbol_calculations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarbonCalculationsResponse _$CarbonCalculationsResponseFromJson(
        Map<String, dynamic> json) =>
    CarbonCalculationsResponse(
      houseHoldMembers: json['houseHoldMembers'] as int?,
      publicTransportationMembers: json['publicTransportationMembers'] as int?,
      income: json['income'] as String?,
      houseSize: json['houseSize'] as String?,
      airTravel: json['airTravel'] as String?,
      meatConsumption: json['meatConsumption'] as String?,
      totalCarbonEmissions: (json['totalCarbonEmissions'] as num?)?.toDouble(),
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$CarbonCalculationsResponseToJson(
        CarbonCalculationsResponse instance) =>
    <String, dynamic>{
      'houseHoldMembers': instance.houseHoldMembers,
      'publicTransportationMembers': instance.publicTransportationMembers,
      'income': instance.income,
      'houseSize': instance.houseSize,
      'airTravel': instance.airTravel,
      'meatConsumption': instance.meatConsumption,
      'totalCarbonEmissions': instance.totalCarbonEmissions,
      'countryCode': instance.countryCode,
    };
