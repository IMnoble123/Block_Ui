// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'products_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProductsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchProducts,
    required TResult Function(ProductSortModes sortMode) sortProducts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(ProductsEventfetchProducts value) fetchProducts,
    required TResult Function(SortProducts value) sortProducts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsEventCopyWith<$Res> {
  factory $ProductsEventCopyWith(
          ProductsEvent value, $Res Function(ProductsEvent) then) =
      _$ProductsEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$ProductsEventCopyWithImpl<$Res>
    implements $ProductsEventCopyWith<$Res> {
  _$ProductsEventCopyWithImpl(this._value, this._then);

  final ProductsEvent _value;
  // ignore: unused_field
  final $Res Function(ProductsEvent) _then;
}

/// @nodoc
abstract class _$$StartedCopyWith<$Res> {
  factory _$$StartedCopyWith(_$Started value, $Res Function(_$Started) then) =
      __$$StartedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedCopyWithImpl<$Res> extends _$ProductsEventCopyWithImpl<$Res>
    implements _$$StartedCopyWith<$Res> {
  __$$StartedCopyWithImpl(_$Started _value, $Res Function(_$Started) _then)
      : super(_value, (v) => _then(v as _$Started));

  @override
  _$Started get _value => super._value as _$Started;
}

/// @nodoc

class _$Started implements Started {
  const _$Started();

  @override
  String toString() {
    return 'ProductsEvent.started()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchProducts,
    required TResult Function(ProductSortModes sortMode) sortProducts,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(ProductsEventfetchProducts value) fetchProducts,
    required TResult Function(SortProducts value) sortProducts,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class Started implements ProductsEvent {
  const factory Started() = _$Started;
}

/// @nodoc
abstract class _$$ProductsEventfetchProductsCopyWith<$Res> {
  factory _$$ProductsEventfetchProductsCopyWith(
          _$ProductsEventfetchProducts value,
          $Res Function(_$ProductsEventfetchProducts) then) =
      __$$ProductsEventfetchProductsCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsEventfetchProductsCopyWithImpl<$Res>
    extends _$ProductsEventCopyWithImpl<$Res>
    implements _$$ProductsEventfetchProductsCopyWith<$Res> {
  __$$ProductsEventfetchProductsCopyWithImpl(
      _$ProductsEventfetchProducts _value,
      $Res Function(_$ProductsEventfetchProducts) _then)
      : super(_value, (v) => _then(v as _$ProductsEventfetchProducts));

  @override
  _$ProductsEventfetchProducts get _value =>
      super._value as _$ProductsEventfetchProducts;
}

/// @nodoc

class _$ProductsEventfetchProducts implements ProductsEventfetchProducts {
  const _$ProductsEventfetchProducts();

  @override
  String toString() {
    return 'ProductsEvent.fetchProducts()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsEventfetchProducts);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchProducts,
    required TResult Function(ProductSortModes sortMode) sortProducts,
  }) {
    return fetchProducts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
  }) {
    return fetchProducts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
    required TResult orElse(),
  }) {
    if (fetchProducts != null) {
      return fetchProducts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(ProductsEventfetchProducts value) fetchProducts,
    required TResult Function(SortProducts value) sortProducts,
  }) {
    return fetchProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
  }) {
    return fetchProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
    required TResult orElse(),
  }) {
    if (fetchProducts != null) {
      return fetchProducts(this);
    }
    return orElse();
  }
}

abstract class ProductsEventfetchProducts implements ProductsEvent {
  const factory ProductsEventfetchProducts() = _$ProductsEventfetchProducts;
}

/// @nodoc
abstract class _$$SortProductsCopyWith<$Res> {
  factory _$$SortProductsCopyWith(
          _$SortProducts value, $Res Function(_$SortProducts) then) =
      __$$SortProductsCopyWithImpl<$Res>;
  $Res call({ProductSortModes sortMode});
}

/// @nodoc
class __$$SortProductsCopyWithImpl<$Res>
    extends _$ProductsEventCopyWithImpl<$Res>
    implements _$$SortProductsCopyWith<$Res> {
  __$$SortProductsCopyWithImpl(
      _$SortProducts _value, $Res Function(_$SortProducts) _then)
      : super(_value, (v) => _then(v as _$SortProducts));

  @override
  _$SortProducts get _value => super._value as _$SortProducts;

  @override
  $Res call({
    Object? sortMode = freezed,
  }) {
    return _then(_$SortProducts(
      sortMode == freezed
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as ProductSortModes,
    ));
  }
}

/// @nodoc

class _$SortProducts implements SortProducts {
  const _$SortProducts(this.sortMode);

  @override
  final ProductSortModes sortMode;

  @override
  String toString() {
    return 'ProductsEvent.sortProducts(sortMode: $sortMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortProducts &&
            const DeepCollectionEquality().equals(other.sortMode, sortMode));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(sortMode));

  @JsonKey(ignore: true)
  @override
  _$$SortProductsCopyWith<_$SortProducts> get copyWith =>
      __$$SortProductsCopyWithImpl<_$SortProducts>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() fetchProducts,
    required TResult Function(ProductSortModes sortMode) sortProducts,
  }) {
    return sortProducts(sortMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
  }) {
    return sortProducts?.call(sortMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? fetchProducts,
    TResult Function(ProductSortModes sortMode)? sortProducts,
    required TResult orElse(),
  }) {
    if (sortProducts != null) {
      return sortProducts(sortMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(ProductsEventfetchProducts value) fetchProducts,
    required TResult Function(SortProducts value) sortProducts,
  }) {
    return sortProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
  }) {
    return sortProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(ProductsEventfetchProducts value)? fetchProducts,
    TResult Function(SortProducts value)? sortProducts,
    required TResult orElse(),
  }) {
    if (sortProducts != null) {
      return sortProducts(this);
    }
    return orElse();
  }
}

abstract class SortProducts implements ProductsEvent {
  const factory SortProducts(final ProductSortModes sortMode) = _$SortProducts;

  ProductSortModes get sortMode;
  @JsonKey(ignore: true)
  _$$SortProductsCopyWith<_$SortProducts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProductsState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isMoreLoading => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  List<ProductModal> get products => throw _privateConstructorUsedError;
  ProductSortModes get sortMode => throw _privateConstructorUsedError;
  bool get hasError => throw _privateConstructorUsedError;
  bool get countryAvailable => throw _privateConstructorUsedError;
  CountryModal get countryModal => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductsStateCopyWith<ProductsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsStateCopyWith<$Res> {
  factory $ProductsStateCopyWith(
          ProductsState value, $Res Function(ProductsState) then) =
      _$ProductsStateCopyWithImpl<$Res>;
  $Res call(
      {bool isLoading,
      bool isMoreLoading,
      int currentPage,
      bool hasMore,
      List<ProductModal> products,
      ProductSortModes sortMode,
      bool hasError,
      bool countryAvailable,
      CountryModal countryModal});
}

/// @nodoc
class _$ProductsStateCopyWithImpl<$Res>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._value, this._then);

  final ProductsState _value;
  // ignore: unused_field
  final $Res Function(ProductsState) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isMoreLoading = freezed,
    Object? currentPage = freezed,
    Object? hasMore = freezed,
    Object? products = freezed,
    Object? sortMode = freezed,
    Object? hasError = freezed,
    Object? countryAvailable = freezed,
    Object? countryModal = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isMoreLoading: isMoreLoading == freezed
          ? _value.isMoreLoading
          : isMoreLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: currentPage == freezed
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: hasMore == freezed
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      products: products == freezed
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModal>,
      sortMode: sortMode == freezed
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as ProductSortModes,
      hasError: hasError == freezed
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      countryAvailable: countryAvailable == freezed
          ? _value.countryAvailable
          : countryAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      countryModal: countryModal == freezed
          ? _value.countryModal
          : countryModal // ignore: cast_nullable_to_non_nullable
              as CountryModal,
    ));
  }
}

/// @nodoc
abstract class _$$_ProductsStateCopyWith<$Res>
    implements $ProductsStateCopyWith<$Res> {
  factory _$$_ProductsStateCopyWith(
          _$_ProductsState value, $Res Function(_$_ProductsState) then) =
      __$$_ProductsStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isLoading,
      bool isMoreLoading,
      int currentPage,
      bool hasMore,
      List<ProductModal> products,
      ProductSortModes sortMode,
      bool hasError,
      bool countryAvailable,
      CountryModal countryModal});
}

/// @nodoc
class __$$_ProductsStateCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res>
    implements _$$_ProductsStateCopyWith<$Res> {
  __$$_ProductsStateCopyWithImpl(
      _$_ProductsState _value, $Res Function(_$_ProductsState) _then)
      : super(_value, (v) => _then(v as _$_ProductsState));

  @override
  _$_ProductsState get _value => super._value as _$_ProductsState;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isMoreLoading = freezed,
    Object? currentPage = freezed,
    Object? hasMore = freezed,
    Object? products = freezed,
    Object? sortMode = freezed,
    Object? hasError = freezed,
    Object? countryAvailable = freezed,
    Object? countryModal = freezed,
  }) {
    return _then(_$_ProductsState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isMoreLoading: isMoreLoading == freezed
          ? _value.isMoreLoading
          : isMoreLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: currentPage == freezed
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: hasMore == freezed
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      products: products == freezed
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModal>,
      sortMode: sortMode == freezed
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as ProductSortModes,
      hasError: hasError == freezed
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      countryAvailable: countryAvailable == freezed
          ? _value.countryAvailable
          : countryAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      countryModal: countryModal == freezed
          ? _value.countryModal
          : countryModal // ignore: cast_nullable_to_non_nullable
              as CountryModal,
    ));
  }
}

/// @nodoc

class _$_ProductsState implements _ProductsState {
  const _$_ProductsState(
      {required this.isLoading,
      required this.isMoreLoading,
      required this.currentPage,
      required this.hasMore,
      required final List<ProductModal> products,
      required this.sortMode,
      required this.hasError,
      required this.countryAvailable,
      required this.countryModal})
      : _products = products;

  @override
  final bool isLoading;
  @override
  final bool isMoreLoading;
  @override
  final int currentPage;
  @override
  final bool hasMore;
  final List<ProductModal> _products;
  @override
  List<ProductModal> get products {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final ProductSortModes sortMode;
  @override
  final bool hasError;
  @override
  final bool countryAvailable;
  @override
  final CountryModal countryModal;

  @override
  String toString() {
    return 'ProductsState(isLoading: $isLoading, isMoreLoading: $isMoreLoading, currentPage: $currentPage, hasMore: $hasMore, products: $products, sortMode: $sortMode, hasError: $hasError, countryAvailable: $countryAvailable, countryModal: $countryModal)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProductsState &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality()
                .equals(other.isMoreLoading, isMoreLoading) &&
            const DeepCollectionEquality()
                .equals(other.currentPage, currentPage) &&
            const DeepCollectionEquality().equals(other.hasMore, hasMore) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(other.sortMode, sortMode) &&
            const DeepCollectionEquality().equals(other.hasError, hasError) &&
            const DeepCollectionEquality()
                .equals(other.countryAvailable, countryAvailable) &&
            const DeepCollectionEquality()
                .equals(other.countryModal, countryModal));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      const DeepCollectionEquality().hash(isMoreLoading),
      const DeepCollectionEquality().hash(currentPage),
      const DeepCollectionEquality().hash(hasMore),
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(sortMode),
      const DeepCollectionEquality().hash(hasError),
      const DeepCollectionEquality().hash(countryAvailable),
      const DeepCollectionEquality().hash(countryModal));

  @JsonKey(ignore: true)
  @override
  _$$_ProductsStateCopyWith<_$_ProductsState> get copyWith =>
      __$$_ProductsStateCopyWithImpl<_$_ProductsState>(this, _$identity);
}

abstract class _ProductsState implements ProductsState {
  const factory _ProductsState(
      {required final bool isLoading,
      required final bool isMoreLoading,
      required final int currentPage,
      required final bool hasMore,
      required final List<ProductModal> products,
      required final ProductSortModes sortMode,
      required final bool hasError,
      required final bool countryAvailable,
      required final CountryModal countryModal}) = _$_ProductsState;

  @override
  bool get isLoading;
  @override
  bool get isMoreLoading;
  @override
  int get currentPage;
  @override
  bool get hasMore;
  @override
  List<ProductModal> get products;
  @override
  ProductSortModes get sortMode;
  @override
  bool get hasError;
  @override
  bool get countryAvailable;
  @override
  CountryModal get countryModal;
  @override
  @JsonKey(ignore: true)
  _$$_ProductsStateCopyWith<_$_ProductsState> get copyWith =>
      throw _privateConstructorUsedError;
}
