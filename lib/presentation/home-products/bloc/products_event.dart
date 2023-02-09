part of 'products_bloc.dart';

@freezed
class ProductsEvent with _$ProductsEvent {
  const factory ProductsEvent.started() = Started;
  const factory ProductsEvent.fetchProducts() = ProductsEventfetchProducts;
  const factory ProductsEvent.sortProducts(ProductSortModes sortMode) =
      SortProducts;
}
