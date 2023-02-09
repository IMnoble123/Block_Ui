// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    UserProfileResponse(
      user: json['data'] == null
          ? null
          : UserModelResponse.fromJson(json['data'] as Map<String, dynamic>),
      billingAddress: json['billingAddress'] == null
          ? null
          : BillingAddressResponse.fromJson(
              json['billingAddress'] as Map<String, dynamic>),
      calculationsResponse: json['carbonCalculations'] == null
          ? null
          : CarbonCalculationsResponse.fromJson(
              json['carbonCalculations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileResponseToJson(
        UserProfileResponse instance) =>
    <String, dynamic>{
      'data': instance.user,
      'billingAddress': instance.billingAddress,
      'carbonCalculations': instance.calculationsResponse,
    };

BillingAddressResponse _$BillingAddressResponseFromJson(
        Map<String, dynamic> json) =>
    BillingAddressResponse(
      id: json['_id'] as String?,
      customerProfile: json['customerProfile'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      contactNo: json['contactNo'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      pincode: json['pincode'] as String?,
      stateCode: json['stateCode'] as String?,
      countryCode: json['countryCode'] as String?,
      isBilling: json['isBilling'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$BillingAddressResponseToJson(
        BillingAddressResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'customerProfile': instance.customerProfile,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'contactNo': instance.contactNo,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
      'stateCode': instance.stateCode,
      'countryCode': instance.countryCode,
      'isBilling': instance.isBilling,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
