import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';
import 'package:net_carbons/data/core/mapper/mapper.dart';
import 'package:net_carbons/data/home_products/repository/repository.dart';
import 'package:net_carbons/domain/home_products/modal/models.dart';
import 'package:net_carbons/presentation/home-products/widgets/sort_sheet_widget.dart';

import '../../../app/dependency.dart';
import '../../../data/all_countries/hive_modal/country_hive_modal.dart';
import '../../../data/all_countries/repository/repository.dart';
import '../../../domain/countries/model/country_modal.dart';

part 'products_bloc.freezed.dart';
part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;
  final repository = getIt<CountriesRepository>();
  final AppControllerBloc appControllerBloc;

  late AppControllerState appControllerState;
  String currency = 'USD';

  ProductsBloc(
      {required this.appControllerBloc, required this.productsRepository})
      : super(ProductsState.initial()) {
    appControllerState = appControllerBloc.state;
    currency = appControllerState.currency;

    appControllerBloc.stream.listen((event) {
      appControllerState = event;
      currency = event.currency;
      if (event.appControllerEventsType ==
          AppControllerEventsType.appControllerEventUpdateCurrency) {
        add(const ProductsEvent.fetchProducts());
      }
    });
    on<Started>((event, emit) {
      if (state.products.isNotEmpty) {
        return;
      }
      add(const ProductsEvent.fetchProducts());
    });

    on<ProductsEventfetchProducts>((event, emit) async {
      print("Has more ${state.hasMore}");
      if(!state.hasMore){
        return;
      }
      state.currentPage == 1
          ? emit(state.copyWith(isLoading: true))
          : emit(state.copyWith(isMoreLoading: true));

      final result =
          await productsRepository.getProducts(currency, '', state.currentPage);

      emit(await result.fold(
        (failure) {
          return state.copyWith(
              hasError: true,
              isLoading: false,
              isMoreLoading: false,
              products: [],
              countryModal:
                  appControllerState.countryModal ?? CountryModal.empty(),
              countryAvailable:
                  appControllerState.countryModal?.countryCode != null,
              sortMode: ProductSortModes.defaultSort);
        },
        (products) {
          print("${state.currentPage}=====state.currentPage");
          print("${products.length}=====products.length");
          return state.copyWith(
              currentPage:products.length < 4 ? state.currentPage: state.currentPage + 1,
              isLoading: false,
              isMoreLoading: false,
              hasMore: products.length < 4 ? false : true,
              products: [...state.products, ...products],
              hasError: false,
              countryModal:
                  appControllerState.countryModal ?? CountryModal.empty(),
              countryAvailable:
                  appControllerState.countryModal?.countryCode != null,
              sortMode: ProductSortModes.defaultSort);
        },
      ));
    });
    on<SortProducts>((event, emit) async {
      List<ProductModal> products = [...state.products];
      if (event.sortMode == ProductSortModes.defaultSort) {
        products.sort((a, b) => a.id.compareTo(b.id));
      } else if (event.sortMode == ProductSortModes.lowToHigh) {
        products.sort((a, b) =>
            a.priceList.first.price.compareTo(b.priceList.first.price));
      } else if (event.sortMode == ProductSortModes.highToLow) {
        products.sort((a, b) =>
            b.priceList.first.price.compareTo(a.priceList.first.price));
      }
      emit(state.copyWith(sortMode: event.sortMode, products: products));
    });
  }
}
