import 'dart:convert';

import 'package:bdo_things/domain/entities/coupon.dart';
import 'package:http/http.dart' as http;


abstract class CouponRemoteDataSource {
  Future<List<Coupon>> getCoupons();
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final http.Client client;

  CouponRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Coupon>> getCoupons() async {
    final response = await client.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/bdothings/databases/(default)/documents/coupon'));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      final couponList = (decodedData['documents'] as List)
          .map((document) => Coupon.fromMap(document['fields']))
          .toList();
      return couponList;
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}