import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';
import 'package:net_carbons/app/constants/a3_a2.dart';
import 'package:net_carbons/app/constants/string_constants.dart';
import 'package:net_carbons/data/all_countries/city_response/city.dart';
import 'package:net_carbons/data/all_countries/dial_code.dart';
import 'package:net_carbons/domain/user_profile/modal/profile_modal.dart';
import 'package:net_carbons/presentation/app_widgets/csPicker/modals/country_state.dart';
import 'package:net_carbons/presentation/app_widgets/csPicker/stat-country.dart';
import 'package:net_carbons/presentation/app_widgets/outlined_button.dart';
import 'package:net_carbons/presentation/profile/bloc/user_profile_bloc.dart';
import 'package:net_carbons/app/extensions.dart';
import '../../../app/constants/a2_a3.dart';
import '../../../domain/countries/model/country_modal.dart';
import '../../app_widgets/text_input_field.dart';
import '../../resources/color.dart';
import '../bloc/checkout_bloc.dart';
import '../widgets/checkout_app_bar.dart';

class InputAddressPageView extends StatefulWidget {
  const InputAddressPageView(
      {super.key,
      required this.onSubmit,
      required this.profileModalData,
      this.billingAddressModal});
  final Function(BillingAddressModal) onSubmit;
  final UserProfileModal profileModalData;
  final BillingAddressModal? billingAddressModal;
  @override
  State<InputAddressPageView> createState() => _InputAddressPageViewState();
}

class _InputAddressPageViewState extends State<InputAddressPageView> {
  PhoneNumberData? phoneNumberData;

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _addressLin1Controller = TextEditingController();

  final TextEditingController _addressLin2Controller = TextEditingController();

  final TextEditingController _pinCodeController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();


  CountryModal? selectedCountryLocal;

  _initFields(
      {required BuildContext context,
      UserProfileModal? profileModal,
      BillingAddressModal? billingAddress}) {
    phoneNumberData = seperatePhoneAndDialCode(billingAddress?.contactNo);

    _firstNameController.text = billingAddress?.firstName ?? '';
    _lastNameController.text = billingAddress?.lastName ?? '';
    _addressLin1Controller.text = billingAddress?.addressLine1 ?? '';
    _addressLin2Controller.text = billingAddress?.addressLine2 ?? '';

    _pinCodeController.text = billingAddress?.pincode ?? '';
    _emailController.text = profileModal?.user.email ?? '';

    initCountryCode = billingAddress?.countryCode;
    initStateCode = billingAddress?.stateCode;
    initCity = billingAddress?.city;
  }

  void _initLocal() async {
    selectedCountryLocal =
        BlocProvider.of<AppControllerBloc>(context).state.countryModal;

    initCountryCode = selectedCountryLocal?.countryCode;
  }

  Region? selectedState;
  CountryPickerModel? selectedCountry;
  City? selectedCity;

  String? initCountryCode;
  String? initStateCode;
  String? initCity;

  @override
  void initState() {
    if (widget.billingAddressModal == null) {
      if (widget.profileModalData.billingAddress == null) {
        _initLocal();
        _emailController.text = widget.profileModalData.user.email;
      } else if (widget.profileModalData.billingAddress != null) {
        _initFields(
          context: context,
          profileModal: widget.profileModalData,
          billingAddress: widget.profileModalData.billingAddress,
        );
      }
    } else {
      _initFields(
        context: context,
        billingAddress: widget.billingAddressModal,
        profileModal: widget.profileModalData,
      );
    }

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  ScrollController scrollController = ScrollController();

  final Map<String, GlobalKey<FormState>> formKey = {
    "firstNameKey": GlobalKey<FormState>(),
    "lastNameKey": GlobalKey<FormState>(),
    "countryKey": GlobalKey<FormState>(),
    "stateKey": GlobalKey<FormState>(),
    "cityKey": GlobalKey<FormState>(),
    "address1Key": GlobalKey<FormState>(),
    "address2Key": GlobalKey<FormState>(),
    "zipKey": GlobalKey<FormState>(),
  };
  final Map<String, FocusNode> nodes = {
    "firstNameKey": FocusNode(),
    "lastNameKey": FocusNode(),
    "address1Key": FocusNode(),
    "address2Key": FocusNode(),
    "zipKey": FocusNode(),
    "countryKey": FocusNode(),
    "stateKey": FocusNode(),
    "cityKey": FocusNode(),

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: const CheckoutAppBar(
          title: 'Address',
          actionText: '1/2 Checkout',
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                        padding: EdgeInsets.all(4.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryActiveColor,
                                width: .5)),
                        height: 40.h,
                        child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              _emailController.text,
                            ))),
                    SizedBox(
                      height: 8.h,
                    ),
                    Form(
                      key: formKey['firstNameKey'],
                      child: InputField(
                        focusNode: nodes['firstNameKey'],
                        textEditingController: _firstNameController,
                        label: 'First name',
                        hintText: 'First name',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                        onFocused: () {},
                        onUnfocused: () =>
                            formKey['firstNameKey']?.currentState?.validate(),
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    Form(
                      key: formKey['lastNameKey'],
                      child: InputField(
                        focusNode: nodes['lastNameKey'],
                        textEditingController: _lastNameController,
                        label: 'Last Name',
                        hintText: 'Last Name',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                        onFocused: () {},
                        onUnfocused: () =>
                            formKey['lastNameKey']?.currentState?.validate(),
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Contact No.",
                    //       style: Theme.of(context).textTheme.subtitle1,
                    //     ),
                    //     SizedBox(
                    //       height: 9.h,
                    //     ),
                    //     Form(
                    //       key: formKey['phoneKey'],
                    //       child: IntlPhoneField(
                    //         validator: (val) {
                    //           return val?.isValid( message:"Enter a valid number");
                    //         },
                    //         invalidNumberMessage:
                    //             _contactNumberController.text.trim().isEmpty
                    //                 ? "Phone number is required"
                    //                 : 'Invalid phone number',
                    //         onCountryChanged: (country) {
                    //           print(country.code);
                    //           setState(() {
                    //             initCountryCode =
                    //                 countryCodesA2ToA3[country.code];
                    //           });
                    //         },
                    //         focusNode: nodes['phoneKey'],
                    //         initialValue: phoneNumberData?.phoneNumber,
                    //         decoration: const InputDecoration(
                    //           border: OutlineInputBorder(
                    //             borderSide: BorderSide(),
                    //           ),
                    //         ),
                    //         initialCountryCode: phoneNumberData?.countryCode ??
                    //             countryCodesA3ToA2[initCountryCode],
                    //         onChanged: (phone) {
                    //           setState(() {
                    //             _contactNumberController.text =
                    //                 phone.completeNumber;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 26.h,
                    // ),
                    StateCountrySelector(
                      cityFocusNode: nodes['cityKey'],
                      cityFormKey: formKey['cityKey'],
                      countryFocusNode: nodes['countryKey'],
                      countryFormKey: formKey['countryKey'],
                      stateFocusNode: nodes['stateKey'],
                      stateFormKey: formKey['stateKey'],

                      initialCountryIso3Code: initCountryCode ?? '',
                      initialStateCode: initStateCode ?? '',
                      initialCity: initCity ?? '',

                      onCountryChanged: (val) {
                        formKey['countryKey']?.currentState?.validate();
                        setState(() {
                          selectedCountry = val;
                        });
                      },
                      onStateChanged: (val) {
                        formKey['stateKey']?.currentState?.validate();
                        setState(() {
                          selectedState = val;
                        });
                      },
                      onCityChanged: (city) {
                        formKey['cityKey']?.currentState?.validate();
                        setState(() {
                          selectedCity = city;
                        });
                      },
                      // onCityChanged: (val) {},
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    Form(
                      key: formKey['address1Key'],
                      child: InputField(
                        focusNode: nodes['address1Key'],
                        textEditingController: _addressLin1Controller,
                        label: 'Address Line 1',
                        hintText: 'Address Line 1',
                        validator: (val) {
                          if (val!.isEmpty || val.length < 8) {
                            return 'Enter a Valid address';
                          }
                          return null;
                        },
                        onFocused: () {},
                        onUnfocused: () =>
                            formKey['address1Key']?.currentState?.validate(),
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    Form(
                      key: formKey['address2Key'],
                      child: InputField(
                        focusNode: nodes['address2Key'],
                        textEditingController: _addressLin2Controller,
                        label: 'Address Line 2',
                        hintText: 'Address Line 2',
                        onFocused: () {},
                        onUnfocused: () =>
                            formKey['address2Key']?.currentState?.validate(),
                        validator: (val) {},
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    Form(
                      key: formKey['zipKey'],
                      child: SizedBox(
                        width: 160.w,
                        child: InputField(
                          focusNode: nodes['zipKey'],
                          inputType: TextInputType.number,
                          textEditingController: _pinCodeController,
                          label: 'ZIP',
                          hintText: 'Zip code',
                          validator: (val) {
                            if (val!.isEmpty ||
                                !RegExp(r"^[0-9]").hasMatch(val)) {
                              return 'Enter Code';
                            }
                            return null;
                          },
                          onFocused: () {},
                          onUnfocused: () =>
                              formKey['zipKey']?.currentState?.validate(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    AppButton2(
                      isLoading: state.isLoading,
                      onTap: () {
                        for (var element in formKey.entries) {
                          if (!element.value.currentState!.validate()) {
                            scrollController.jumpTo(
                                scrollController.position.minScrollExtent);
                            nodes[element.key]?.requestFocus();

                            return;
                          }
                        }

                        final billingAddressModal = BillingAddressModal(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          addressLine1: _addressLin1Controller.text,
                          addressLine2: _addressLin2Controller.text,
                          city: selectedCity?.name ?? '',
                          state: selectedState?.name ?? '',
                          pincode: _pinCodeController.text,
                          contactNo: '',
                          countryCode: countryCodesA2ToA3[
                                  selectedCountry?.countryShortCode] ??
                              '',
                          stateCode: selectedState?.shortCode ?? '',
                          country: selectedCountry?.countryName ?? '',

                          ////
                          customerProfile:
                              widget.profileModalData.user.id ?? '',
                          id: widget.profileModalData.billingAddress?.id ?? '',
                          email: _emailController.text.trim(),
                        );
                        widget.onSubmit(billingAddressModal);
                        BlocProvider.of<UserProfileBloc>(context).add(
                            UserProfileEvent.updateAddress(
                                billingAddressModal));
                      },
                      filled: true,
                      text: Text(
                        ButtonStrings.continueText,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      feedbackTimeText: Text(
                        ButtonStrings.continueText,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.copyWith(color: AppColors.primaryActiveColor),
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

PhoneNumberData? seperatePhoneAndDialCode(String? phoneWithDialCode) {
  if (phoneWithDialCode == null) {
    return null;
  }
  // +91 9947511979
  String? countryCode;
  String? countryDialCode;
  String? phoneNumber;
  Map<String, String>? foundedCountry;
  for (var country in CountriesCodes.allCountries) {
    String dialCode = country["dial_code"].toString();
    if (phoneWithDialCode.contains(dialCode)) {
      foundedCountry = country;
      break;
    }
  }

  if (foundedCountry != null) {
    countryDialCode = foundedCountry["dial_code"];
    phoneNumber = phoneWithDialCode.substring(
      foundedCountry["dial_code"]!.length,
    );
    countryCode = foundedCountry['code'];
    print("$countryCode+ $countryDialCode + $phoneNumber");
    return PhoneNumberData(
        countryCode: countryCode,
        countryDialCode: countryDialCode,
        phoneNumber: phoneNumber,
        fullNumber: phoneWithDialCode);
  }
  return PhoneNumberData(fullNumber: phoneWithDialCode);
}

class PhoneNumberData {
  PhoneNumberData(
      {this.countryCode,
      this.countryDialCode,
      this.phoneNumber,
      required this.fullNumber});
  String? countryCode;
  String? countryDialCode;
  String? phoneNumber;
  String fullNumber;
}
