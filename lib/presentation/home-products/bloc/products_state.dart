part of 'products_bloc.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState(
      {required bool isLoading,

        required bool isMoreLoading,
        required int currentPage,
        required bool hasMore,

      required List<ProductModal> products,
      required ProductSortModes sortMode,
      required bool hasError,
      required bool countryAvailable,
      required CountryModal countryModal}) = _ProductsState;

  factory ProductsState.initial() => _ProductsState(
      isLoading: true,
      products: [],
      sortMode: ProductSortModes.defaultSort,
      hasError: false,
      countryAvailable: false,
      countryModal: CountryModal.empty(), isMoreLoading: false, currentPage: 1, hasMore: true);
}
