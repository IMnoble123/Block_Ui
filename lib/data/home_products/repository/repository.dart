import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:net_carbons/app/dependency.dart';
import 'package:net_carbons/data/core/general/failiure.dart';
import 'package:net_carbons/data/core/mapper/mapper.dart';
import 'package:net_carbons/data/home_products/responses/product_list/product_list.dart';

import '../../../domain/home_products/i_repository.dart';
import '../../../domain/home_products/modal/models.dart';
import '../../core/network/dio.dart';

class ProductsRepository implements IProductHomeRepository {
  final dio = getIt<DioManager>();
  @override
  Future<Either<Failure, List<ProductModal>>> getProducts(
      String? currency, String? keyWord, int page) async {
    try {
      final resp = await dio.get('/v1/products', queryParameters: {
        "search": keyWord,
        "page": page,
        "size": 4,
        "shouldPaginate": 1
      });

      if (resp.statusCode == 200) {
        final response = ProductList.fromJson(resp.data);

        return Right(response.toDomain(currency ?? 'USD'));
      } else {
        return Left(ServerFailure(message: resp.data['message'])
            .orGeneric("Something went wrong. Please try again later."));
      }
    } on DioError catch (e) {
      print(e);
      return Left(ClientFailure(message: e.response?.data['message'] ?? 'Error in getting products')
          .orGeneric("Something went wrong. Please try again later."));
    } catch (e) {
      print(e);
      return Left(ClientFailure(message: 'Unknown error in products')
          .orGeneric("Something went wrong. Please try again later."));
    }
  }
}
