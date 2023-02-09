import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';
import 'package:net_carbons/app/app_controller/state_classes/settings.dart';
import 'package:net_carbons/app/auth/auth_bloc.dart';
import 'package:net_carbons/app/dependency.dart';
import 'package:net_carbons/data/all_countries/repository/repository.dart';
import 'package:net_carbons/data/core/mapper/mapper.dart';
import 'package:net_carbons/data/user_profile/repository/repository.dart';
import 'package:net_carbons/data/user_profile/save_calculations_payload/save_calculations_payload.dart';
import 'package:net_carbons/domain/countries/model/country_modal.dart';
import 'package:net_carbons/domain/home_products/modal/models.dart';
import 'package:net_carbons/domain/user_profile/modal/profile_modal.dart';
import 'package:net_carbons/presentation/profile/bloc/user_profile_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'calculate_bloc.freezed.dart';
part 'calculate_event.dart';
part 'calculate_state.dart';

class CalculateBloc extends Bloc<CalculateEvent, CalculateState> {
  final repository = getIt<CountriesRepository>();
  final userProfileRepo = getIt<UserProfileRepository>();
  final UserProfileBloc userProfileBloc;
  final AppControllerBloc appControllerBloc;
  final AuthBloc authBloc;

  AppControllerState appControllerState = AppControllerState.initial(
      isLoading: false,
      countries: [],
      currencyList: [],
      currency: 'USD',
      appCustomSettings: AppCustomSettings(notificationEnabled: false),
      buildApp: false,
      showSnackBar: false,
      appLevelSnackBar: AppLevelSnackBar.empty());
  bool userMadeAChange() {
    if (state.noOfPeople != 1 ||
        state.houseSizeValue != 1 ||
        state.meatEggFishValue != 1 ||
        state.incomeValue != 1 ||
        state.airTravelValue != 1) {
      return true;
    }
    return false;
  }

  CalculateBloc(
      {required this.appControllerBloc,
      required this.authBloc,
      required this.userProfileBloc})
      : super(_Initial(
            userMadeAChange: false,
            noOfPeople: 1,
            noOfPeopleUsingTransport: 0,
            incomeValue: 1,
            airTravelValue: 1,
            houseSizeValue: 1,
            meatEggFishValue: 1,
            percentageSliderValue: 0,
            calculatorResultValue: 0,
            offsetValue: 0,
            totalValue: 0,
            selectedCountry: null,
            selectedCountryLocal: null,
            isCountryError: false,
            isLoading: false,
            countries: [],
            productWithLeastPrice: ProductModal.emptyCalc(),
            emissionSavingStatus: EmissionSavingStatus.initial,
            emissionLoading: false)) {
    appControllerState = appControllerBloc.state;
    appControllerBloc.stream.listen((event) {
      if (event.countryModal != null) {
        if (state.selectedCountry != null) {
          if (event.countryModal?.countryCode !=
              state.selectedCountry?.countryCode) {
            add(const CalculateEvent.started());
          }
        }
      }
      appControllerState = event;
    });

    authBloc.stream.listen((event) async {
      if (event is Authenticated) {
        event.map((value) => null, authenticated: (authenticated) async {
          if (authenticated.shouldSyncLocalCartToServer) {
            if (userMadeAChange()) {
              final res = await userProfileRepo.saveEmission(
                  SaveCalculationsPayload(
                      houseHoldMembers: state.noOfPeople,
                      publicTransportationMembers:
                          state.noOfPeopleUsingTransport,
                      income: getValueString(state.incomeValue),
                      houseSize: getValueString(state.houseSizeValue),
                      airTravel: getValueString(state.airTravelValue),
                      meatConsumption: getValueString(state.meatEggFishValue),
                      totalCarbonEmissions: state.calculatorResultValue,
                      countryCode: state.selectedCountry?.countryCode ?? ''));
            }
          }
        },
            unauthenticated: (unauthenticated) {},
            loading: (loading) {},
            unknown: (unknown) {});

        return;
      } else if (event is Unauthenticated) {}
    });

    on<Started>((event, emit) async {
      final country = await repository.getCountryFromLocal();
      CountryModal? selectedCountryLocal = country?.hiveToCountryModal();
      if (appControllerBloc.state.countries.isNotEmpty) {
        emit(state.copyWith(countries: appControllerBloc.state.countries));
        final selectedCountry = appControllerState.countries.firstWhere(
            (element) {
          return element.countryCode ==
              appControllerBloc.state.countryModal?.countryCode;
        },
            orElse: () => appControllerState.countries.firstWhere((element) =>
                element.countryCode == selectedCountryLocal?.countryCode));

        final result = _getResult(
            state.copyWith(
              selectedCountry: state.selectedCountry ?? selectedCountry,
            ),
            save: false);

        final offset = (state.percentageSliderValue * result) / 100;

        final price = state.productWithLeastPrice.priceLocal?.price ??
            state.productWithLeastPrice.priceInUsd.price;

        return emit(state.copyWith(
            selectedCountryLocal: selectedCountryLocal,
            selectedCountry: state.selectedCountry ?? selectedCountry,
            isCountryError: false,
            isLoading: false,
            offsetValue: offset.roundToDouble(),
            calculatorResultValue: result,
            //TODO Price list
            totalValue: result.roundToDouble() * price,
            countries: appControllerBloc.state.countries,
            houseSizeValue: 1,
            incomeValue: 1,
            airTravelValue: 1,
            noOfPeople: 1,
            noOfPeopleUsingTransport: 0,
            meatEggFishValue: 1));
      } else {
        emit(state.copyWith(isLoading: true));
        final res = await repository.fetAllCountries();
        res.fold((l) {
          emit(state.copyWith(
              isCountryError: true, isLoading: false, errorMessage: l.message));
        }, (countries) {
          if (!appControllerBloc.state.isLoading) {
            appControllerBloc
                .add(AppControllerEvent.addListOfCountries(countries));
          }

          final selectedCountry = countries.firstWhere((element) {
            return element.countryCode == selectedCountryLocal?.countryCode;
          },
              orElse: () => countries.firstWhere(
                  (element) =>
                      element.countryCode ==
                      appControllerBloc.state.countryModal?.countryCode,
                  orElse: () => countries
                      .firstWhere((element) => element.countryCode == "USA")));
          final result = _getResult(
              state.copyWith(
                selectedCountry: state.selectedCountry ?? selectedCountry,
              ),
              save: false);

          final offset = (state.percentageSliderValue * result) / 100;

          final price = state.productWithLeastPrice.priceLocal?.price ??
              state.productWithLeastPrice.priceInUsd.price;

          emit(state.copyWith(
              selectedCountryLocal: selectedCountryLocal,
              selectedCountry: state.selectedCountry ?? selectedCountry,
              isCountryError: false,
              isLoading: false,
              offsetValue: offset.roundToDouble(),
              calculatorResultValue: result,
              totalValue: result.roundToDouble() * price,
              countries: countries,
              houseSizeValue: 1,
              incomeValue: 1,
              airTravelValue: 1,
              noOfPeople: 1,
              noOfPeopleUsingTransport: 0,
              meatEggFishValue: 1));
        });
      }
    });
    // on<CalculateEventaddEmissionTOState>((event, emit) {
    //   final result = _getResult(
    //       state.copyWith(
    //         houseSizeValue: getStringValue(event.data.houseSize),
    //         incomeValue: getStringValue(event.data.income),
    //         airTravelValue: getStringValue(event.data.airTravel),
    //         noOfPeople: event.data.houseHoldMembers,
    //         noOfPeopleUsingTransport: event.data.publicTransportationMembers,
    //         meatEggFishValue: getStringValue(event.data.meatConsumption),
    //         selectedCountry: state.countries.firstWhere(
    //             (element) => element.countryCode == event.data.countryCode,
    //             orElse: () => appControllerState.countries.firstWhere(
    //                 (element) =>
    //                     element.countryCode ==
    //                     (appControllerBloc.state.countryModal?.countryCode ??
    //                         "USA"))),
    //       ),
    //       save: false);
    //   final offset = (state.percentageSliderValue * result) / 100;
    //
    //   final price = state.productWithLeastPrice.priceLocal?.price ??
    //       state.productWithLeastPrice.priceInUsd.price;
    //   return emit(state.copyWith(
    //     totalValue: result.roundToDouble() * price,
    //     offsetValue: event.data.totalCarbonEmissions,
    //     calculatorResultValue: result,
    //     houseSizeValue: getStringValue(event.data.houseSize),
    //     incomeValue: getStringValue(event.data.income),
    //     airTravelValue: getStringValue(event.data.airTravel),
    //     noOfPeople: event.data.houseHoldMembers,
    //     noOfPeopleUsingTransport: event.data.publicTransportationMembers,
    //     meatEggFishValue: getStringValue(event.data.meatConsumption),
    //     selectedCountry: state.countries.firstWhere(
    //         (element) => element.countryCode == event.data.countryCode),
    //   ));
    // });

    on<CalculateEventfetchEmissionData>((event, emit) async {
      if (state.userMadeAChange) {
        return;
      }
      if (authBloc.state is Authenticated) {
        if (userProfileBloc.state.userProfileModal != null) {
          if (userProfileBloc
                  .state.userProfileModal!.calculationsResponseModal !=
              null) {
            final data = userProfileBloc
                .state.userProfileModal!.calculationsResponseModal!;
            final result = _getResult(
                state.copyWith(
                  houseSizeValue: getStringValue(data.houseSize),
                  incomeValue: getStringValue(data.income),
                  airTravelValue: getStringValue(data.airTravel),
                  noOfPeople: data.houseHoldMembers,
                  noOfPeopleUsingTransport: data.publicTransportationMembers,
                  meatEggFishValue: getStringValue(data.meatConsumption),
                  selectedCountry: appControllerBloc.state.countries.firstWhere(
                      (element) => element.countryCode == data.countryCode),
                ),
                save: false);
            final offset = (state.percentageSliderValue * result) / 100;
            final price = state.productWithLeastPrice.priceLocal?.price ??
                state.productWithLeastPrice.priceInUsd.price;
            emit(state.copyWith(
              isLoading: false,
              totalValue: result.roundToDouble() * price,
              offsetValue: data.totalCarbonEmissions,
              calculatorResultValue: result,
              houseSizeValue: getStringValue(data.houseSize),
              incomeValue: getStringValue(data.income),
              airTravelValue: getStringValue(data.airTravel),
              noOfPeople: data.houseHoldMembers,
              noOfPeopleUsingTransport: data.publicTransportationMembers,
              meatEggFishValue: getStringValue(data.meatConsumption),
              selectedCountry: appControllerBloc.state.countries.firstWhere(
                  (element) => element.countryCode == data.countryCode),
            ));
          }
        } else {
          emit(state.copyWith(isLoading: true));
          final res = await userProfileRepo.getUserProfile();
          res.fold((l) {
            emit(state.copyWith(isLoading: false));
          }, (r) {
            if (r.calculationsResponseModal != null) {
              final data = r.calculationsResponseModal!;
              final result = _getResult(
                  state.copyWith(
                    houseSizeValue: getStringValue(data.houseSize),
                    incomeValue: getStringValue(data.income),
                    airTravelValue: getStringValue(data.airTravel),
                    noOfPeople: data.houseHoldMembers,
                    noOfPeopleUsingTransport: data.publicTransportationMembers,
                    meatEggFishValue: getStringValue(data.meatConsumption),
                    selectedCountry: appControllerBloc.state.countries
                        .firstWhere((element) =>
                            element.countryCode == data.countryCode),
                  ),
                  save: false);
              final offset = (state.percentageSliderValue * result) / 100;
              final price = state.productWithLeastPrice.priceLocal?.price ??
                  state.productWithLeastPrice.priceInUsd.price;
              emit(state.copyWith(
                isLoading: false,
                totalValue: result.roundToDouble() * price,
                offsetValue: data.totalCarbonEmissions,
                calculatorResultValue: result,
                houseSizeValue: getStringValue(data.houseSize),
                incomeValue: getStringValue(data.income),
                airTravelValue: getStringValue(data.airTravel),
                noOfPeople: data.houseHoldMembers,
                noOfPeopleUsingTransport: data.publicTransportationMembers,
                meatEggFishValue: getStringValue(data.meatConsumption),
                selectedCountry: appControllerBloc.state.countries.firstWhere(
                    (element) => element.countryCode == data.countryCode),
              ));
            }
            emit(state.copyWith(isLoading: false));
          });
        }
      } else {
        _getLocalData(emit, state);
      }
      emit(state.copyWith(isLoading: false));
    });

    on<NoOfPeopleChanged>((event, emit) {
      final result = _getResult(state.copyWith(
        noOfPeople: event.noOfPeople,
      ));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        noOfPeople: event.noOfPeople,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<NoOfPeopleUsingTransportChanged>((event, emit) {
      final result = _getResult(state.copyWith(
        noOfPeopleUsingTransport: event.noOfPeopleUsingTransport,
      ));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        noOfPeopleUsingTransport: event.noOfPeopleUsingTransport,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<IncomeChanged>((event, emit) {
      final result = _getResult(state.copyWith(
        incomeValue: event.incomeValue,
      ));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        incomeValue: event.incomeValue,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<AirTravelChanged>((event, emit) {
      final result = _getResult(state.copyWith(
        airTravelValue: event.airTravelValue,
      ));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        airTravelValue: event.airTravelValue,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<HouseSizeChanged>((event, emit) {
      final result = _getResult(state.copyWith(
        houseSizeValue: event.houseSizeValue,
      ));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        houseSizeValue: event.houseSizeValue,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<MeatEggFishChanged>((event, emit) {
      final result = _getResult(state.copyWith(
        meatEggFishValue: event.meatEggFishValue,
      ));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        meatEggFishValue: event.meatEggFishValue,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<PercentageSliderChanged>((event, emit) {
      final result = _getResult(
          state.copyWith(
            percentageSliderValue: event.percentageSliderValu.toInt(),
          ),
          save: false);
      final offset = (event.percentageSliderValu * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
        userMadeAChange: true,
        percentageSliderValue: event.percentageSliderValu.toInt(),
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });

    on<SelectedCountryChanged>((event, emit) {
      final result = _getResult(state.copyWith(
          selectedCountry: event.countryModal,
          houseSizeValue: 1,
          incomeValue: 1,
          airTravelValue: 1,
          noOfPeople: 1,
          noOfPeopleUsingTransport: 0,
          meatEggFishValue: 1));
      final offset = (state.percentageSliderValue * result) / 100;
      final price = state.productWithLeastPrice.priceLocal?.price ??
          state.productWithLeastPrice.priceInUsd.price;
      emit(state.copyWith(
          userMadeAChange: true,
          selectedCountry: event.countryModal,
          calculatorResultValue: result,
          offsetValue: offset.roundToDouble(),
          //TODO Price list
          totalValue: result.roundToDouble() * price,
          houseSizeValue: 1,
          incomeValue: 1,
          airTravelValue: 1,
          noOfPeople: 1,
          noOfPeopleUsingTransport: 0,
          meatEggFishValue: 1,
          percentageSliderValue: 0));
    });

    on<GetLeastProduct>((event, emit) {
      final result = _getResult(state, save: false);

      final offset = (state.percentageSliderValue * result) / 100;
      final product = event.productModal;

      if (product == null) {
        print('Error in product');
        return;
      }
      final price = product.priceLocal?.price ?? product.priceInUsd.price;

      emit(state.copyWith(
        productWithLeastPrice: product,
        calculatorResultValue: result,
        offsetValue: offset.roundToDouble(),
        //TODO Price list
        totalValue: result.roundToDouble() * price,
      ));
    });
    on<CalculateEventSaveEmissionInServer>(
      (event, emit) async {
        if (authBloc.state is Authenticated) {
          return await saveEmissionToServer(emit, event.emission);
        } else if (authBloc.state is Unauthenticated) {
          return await saveEmissionToLocalDb(event.emission, emit);
        }
      },
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(seconds: 5))
            .asyncExpand(mapper);
      },
    );
    on<CalculateEventSaveEmissionInServerOnClick>(
      (event, emit) async {
        if (authBloc.state is Authenticated) {
          return await saveEmissionToServer(emit, event.emission);
        } else if (authBloc.state is Unauthenticated) {
          return await saveEmissionToLocalDb(event.emission, emit);
        }
      },
    );
  }

  saveEmissionToLocalDb(double emission, Emitter<CalculateState> emit) async {
    final res = await userProfileRepo.saveEmissionToLocalStorage(
        SaveCalculationsPayload(
            houseHoldMembers: state.noOfPeople,
            publicTransportationMembers: state.noOfPeopleUsingTransport,
            income: getValueString(state.incomeValue),
            houseSize: getValueString(state.houseSizeValue),
            airTravel: getValueString(state.airTravelValue),
            meatConsumption: getValueString(state.meatEggFishValue),
            totalCarbonEmissions: emission,
            countryCode: state.selectedCountry?.countryCode ?? 'USA'));
    return res.fold(
        (l) => emit(state.copyWith(
            emissionLoading: false,
            emissionSavingStatus: EmissionSavingStatus.failed)),
        (r) => emit(state.copyWith(
            emissionLoading: false,
            emissionSavingStatus: EmissionSavingStatus.saved)));
  }

  saveEmissionToServer(Emitter<CalculateState> emit, double emission) async {
    emit(state.copyWith(
        emissionLoading: true,
        emissionSavingStatus: EmissionSavingStatus.loading));
    final res = await userProfileRepo.saveEmission(SaveCalculationsPayload(
        houseHoldMembers: state.noOfPeople,
        publicTransportationMembers: state.noOfPeopleUsingTransport,
        income: getValueString(state.incomeValue),
        houseSize: getValueString(state.houseSizeValue),
        airTravel: getValueString(state.airTravelValue),
        meatConsumption: getValueString(state.meatEggFishValue),
        totalCarbonEmissions: emission,
        countryCode: state.selectedCountry?.countryCode ?? 'USA'));
    return res.fold(
        (l) => emit(state.copyWith(
            emissionLoading: false,
            emissionSavingStatus: EmissionSavingStatus.failed)),
        (r) => emit(state.copyWith(
            emissionLoading: false,
            emissionSavingStatus: EmissionSavingStatus.saved)));
  }

  Future<void> _getLocalData(
      Emitter<CalculateState> emit, CalculateState state) async {
    if (authBloc.state is Unauthenticated) {
      final savedData = await userProfileRepo.getEmissionToLocalStorage();
      savedData.fold((l) {}, (r) async {
        if (appControllerBloc.state.countryModal?.countryCode !=
            r.countryCode) {
          return emit(state.copyWith(isLoading: false));
        }
        CountryModal? selectedCountry;
        if (appControllerState.countries.isNotEmpty) {
          selectedCountry = appControllerState.countries.firstWhere((element) {
            return element.countryCode == r.countryCode;
          },
              orElse: () => appControllerState.countries
                  .firstWhere((element) => element.countryCode == "USA"));
        }

        final result = _getResult(
            state.copyWith(
              houseSizeValue: getStringValue(r.houseSize),
              airTravelValue: getStringValue(r.airTravel),
              noOfPeople: r.houseHoldMembers,
              noOfPeopleUsingTransport: r.publicTransportationMembers,
              incomeValue: getStringValue(r.income),
              meatEggFishValue: getStringValue(r.meatConsumption),
              selectedCountryLocal: selectedCountry,
              selectedCountry: selectedCountry,
              isCountryError: false,
              isLoading: false,
              calculatorResultValue: r.totalCarbonEmissions,
              countries: appControllerState.countries,
            ),
            save: false);
        final offset = (state.percentageSliderValue * result) / 100;
        emit(state.copyWith(
          houseSizeValue: getStringValue(r.houseSize),
          airTravelValue: getStringValue(r.airTravel),
          noOfPeople: r.houseHoldMembers,
          noOfPeopleUsingTransport: r.publicTransportationMembers,
          incomeValue: getStringValue(r.income),
          meatEggFishValue: getStringValue(r.meatConsumption),
          selectedCountryLocal: selectedCountry,
          selectedCountry: selectedCountry,
          isCountryError: false,
          isLoading: false,
          countries: appControllerState.countries,
          calculatorResultValue: result,
          offsetValue: offset.roundToDouble(),
        ));
        await userProfileRepo.clearLocalStorageEmission();
      });
    }
  }

  double _getResult(CalculateState state, {bool save = true}) {
    if (state.selectedCountry == null) {
      return 0.0;
    } else {
      double countryFactor = 0.0;
      countryFactor = state.selectedCountry != null
          ? double.tryParse(state.selectedCountry!.carbonCountryPerCapita) ??
              0.0
          : 10.0;

      final lifStyleVal = (state.incomeValue *
          state.airTravelValue *
          state.meatEggFishValue *
          state.houseSizeValue);

      final privetTransUser = state.noOfPeople - state.noOfPeopleUsingTransport;

      final byMemberVal = (privetTransUser * countryFactor) +
          ((state.noOfPeopleUsingTransport * countryFactor) * .85);
      if (save) {
        add(CalculateEvent.saveEmissionInServer(byMemberVal * lifStyleVal));
      }
      return byMemberVal * lifStyleVal;
    }
  }
}

String getValueString(double value) {
  if (value == .85) {
    return 'low';
  } else if (value == 1) {
    return 'medium';
  } else if (value == 1.15) {
    return 'high';
  }
  return 'medium';
}

double getStringValue(String value) {
  if (value == 'low') {
    return .85;
  } else if (value == 'medium') {
    return 1;
  } else if (value == 'high') {
    return 1.15;
  }
  return 1;
}
