import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';

import '../../../app/dependency.dart';
import '../../../data/all_countries/repository/repository.dart';
import '../../../data/home_products/repository/repository.dart';
import '../../../domain/home_products/modal/models.dart';
import '../../home-products/widgets/sort_sheet_widget.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductsRepository productsRepository;
  final AppControllerBloc appControllerBloc;
  final repository = getIt<CountriesRepository>();
  SearchBloc(
      {required this.appControllerBloc, required this.productsRepository})
      : super(SearchState.initial()) {
    on<Search>((event, emit) async {
      if (!state.hasMore) {
        return;
      }
      state.currentPage == 1
          ? emit(state.copyWith(isLoading: true, keyWord: event.keyWord))
          : emit(state.copyWith(isMoreLoading: true, keyWord: event.keyWord));

      ///TODO change currency
      final result = await productsRepository.getProducts(appControllerBloc.state.currency, event.keyWord, 1);
      emit(result.fold(
        (failure) => state.copyWith(
            hasError: true,
            isLoading: false,
            products: [],

            sortMode: ProductSortModes.defaultSort,
            isMoreLoading: false),
        (products) => state.copyWith(
            currentPage:products.length < 4 ? state.currentPage: state.currentPage + 1,
            isMoreLoading: false,
            hasMore: products.length < 4 ? false : true,

            isLoading: false,
            products: [...state.products, ...products],

            hasError: false,
            sortMode: ProductSortModes.defaultSort),
      ));
    });
  }
}
