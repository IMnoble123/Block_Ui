import 'dart:io';
import '../../../../app/extensions.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgManager;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/countries.dart' as intlcountries;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';
import 'package:net_carbons/app/constants/a3_a2.dart';
import 'package:net_carbons/app/constants/svg_flags.dart';
import 'package:net_carbons/app/utils/image_utils.dart';
import 'package:net_carbons/domain/countries/model/country_modal.dart';
import 'package:net_carbons/notification/notification_helpers.dart';
import 'package:net_carbons/presentation/app_widgets/outlined_button.dart';
import 'package:net_carbons/presentation/app_widgets/text_input_field.dart';
import 'package:net_carbons/presentation/profile/bloc/user_profile_bloc.dart';
import 'package:net_carbons/presentation/profile/child_screens/settings/screen_settings.dart';
import 'package:net_carbons/presentation/resources/assets.dart';
import 'package:net_carbons/presentation/resources/color.dart';
import 'package:net_carbons/presentation/resources/ui_widgets/top_wave.dart';

import '../../../checkout/checkout_views/address_page_view.dart';

class ScreenMyProfile extends StatefulWidget {
  const ScreenMyProfile({Key? key}) : super(key: key);

  @override
  State<ScreenMyProfile> createState() => _ScreenMyProfileState();
}

class _ScreenMyProfileState extends State<ScreenMyProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  bool firstRun = true;

  CountryModal? selectedCountry;

  CurrencyAndSymbol? selectedCurrencyAndSymbol;

  DateTime selectedDate = DateTime(DateTime.now().year - 18);

  XFile? selectedImage;

  String? existingImageUrl;

  @override
  void initState() {
    BlocProvider.of<UserProfileBloc>(context)
        .add(const UserProfileEvent.fetchProfile());

    super.initState();
  }

  ScrollController scrollController = ScrollController();

  final Map<String, GlobalKey<FormState>> formKey = {
    "firstNameKey": GlobalKey<FormState>(),
    "lastNameKey": GlobalKey<FormState>(),
    "phoneKey": GlobalKey<FormState>(),
    "countryKey": GlobalKey<FormState>(),
    "currencyKey": GlobalKey<FormState>(),

  };
  final Map<String, FocusNode> nodes = {
    "firstNameKey": FocusNode(),
    "lastNameKey": FocusNode(),
    "countryKey": FocusNode(),
    "currencyKey": FocusNode(),
    "phoneKey": FocusNode(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppControllerBloc, AppControllerState>(
      builder: (context, appControllerBlocState) {
        return BlocConsumer<UserProfileBloc, UserProfileState>(
          listenWhen: (p, c) => p.saveProfileStatus != c.saveProfileStatus,
          listener: (context, state) {
            if (mounted) {
              if (state.saveProfileStatus == SaveProfileStatus.failed &&
                  state.showASnackBar) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error in saving profile")));
                BlocProvider.of<UserProfileBloc>(context)
                    .add(const UserProfileEvent.setSnackBar(false, null));
                Future.delayed(const Duration(seconds: 5), () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                });
                //  Navigator.pop(context);

              }
              if (state.saveProfileStatus == SaveProfileStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile saved")));
                BlocProvider.of<UserProfileBloc>(context)
                    .add(const UserProfileEvent.setSnackBar(false, null));
                Future.delayed(const Duration(seconds: 5), () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  }
                });
                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            if (firstRun) {
              firstNameController.text =
                  state.userProfileModal?.user.firstName ?? '';
              lastNameController.text =
                  state.userProfileModal?.user.lastName ?? '';

              _contactNumberController.text =
                  state.userProfileModal?.billingAddress?.contactNo ?? '';
              state.userProfileModal?.user.dob != null
                  ? selectedDate = state.userProfileModal!.user.dob
                  : null;
              mapAndInitCountry(appControllerBlocState, state);
              existingImageUrl = state.userProfileModal?.user.profileImage;
              firstRun = false;
            }

            return ModalProgressHUD(
              inAsyncCall: state.isLoading,
              progressIndicator: const CupertinoActivityIndicator(),
              child: Scaffold(
                appBar: buildAppAppBar(() {
                  Navigator.pop(context);
                },
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(80.h),
                        child: Container(
                          color: AppColors.primaryInactive,
                          height: 41.h,
                          child: Center(
                            child: Text(
                              "My Profile",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .5,
                                      fontSize: 16,
                                      color: AppColors.primaryActiveColor),
                            ),
                          ),
                        )),
                    backgroundColor: AppColors.primaryInactive,
                    hideWave: true),
                backgroundColor: AppColors.scaffoldColor,
                body: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _selectImage(context).then((value) async {
                                if (value != null) {
                                  final image =
                                      await ImageUtils.cropImage(value.path);
                                  if (image != null) {
                                    setState(() {
                                      selectedImage = image;
                                      existingImageUrl = null;
                                    });
                                  }
                                }
                              });
                            },
                            child: SizedBox(
                              height: 100.h,
                              width: 100.h,
                              child: ImagePlaceHolder(
                                image: selectedImage,
                                existingImage: existingImageUrl,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 53.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                key: formKey['firstNameKey'],
                                child: InputField(
                                  focusNode: nodes['firstNameKey'],
                                  textEditingController: firstNameController,
                                  label: 'First name',
                                  hintText: '',
                                  onFocused: () {},
                                  onUnfocused: () => formKey['firstNameKey']
                                      ?.currentState
                                      ?.validate(),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter a valid name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Form(
                                key: formKey['lastNameKey'],
                                child: InputField(
                                  focusNode: nodes['lastNameKey'],
                                  textEditingController: lastNameController,
                                  label: 'Last name',
                                  onFocused: () {},
                                  onUnfocused: () => formKey['lastNameKey']
                                      ?.currentState
                                      ?.validate(),
                                  hintText: '',
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter a valid name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Contact No.",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  Form(
                                    key: formKey['phoneKey'],
                                    child: IntlPhoneField(
                                      validator: (val) {
                                        return val
                                            ?.isValid(message: "Enter a valid number");
                                      },
                                      invalidNumberMessage:
                                          _contactNumberController.text
                                                  .trim()
                                                  .isEmpty
                                              ? "Phone number is required"
                                              : 'Invalid phone number',
                                      focusNode: nodes['phoneKey'],
                                      initialValue: seperatePhoneAndDialCode(
                                              _contactNumberController.text
                                                  .trim())
                                          ?.phoneNumber,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      initialCountryCode:
                                          seperatePhoneAndDialCode(
                                                      _contactNumberController
                                                          .text
                                                          .trim())
                                                  ?.countryCode ??
                                              countryCodesA3ToA2[state
                                                  .userProfileModal
                                                  ?.user
                                                  .country
                                                  .countryCode],
                                      onChanged: (phone) {
                                        setState(() {
                                          _contactNumberController.text =
                                              phone.completeNumber;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Country",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            color:
                                                AppColors.primaryActiveColor),
                                  ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  Form(
                                    key: formKey['countryKey'],
                                    child: SizedBox(
                                        width: double.maxFinite,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<
                                              CountryModal>(
                                            validator: (value) =>
                                                selectedCountry == null
                                                    ? 'Country is required'
                                                    : null,
                                            focusNode: nodes['countryKey'],
                                            icon: Center(
                                                child: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 32.sp,
                                            )),
                                            hint: const Text(
                                                "Or Select a Country"),
                                            value: selectedCountry,
                                            isDense: true,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCountry = newValue;
                                              });
                                            },
                                            items: appControllerBlocState
                                                .countries
                                                .map((country) {
                                              return DropdownMenuItem<
                                                  CountryModal>(
                                                value: country,
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          svgManager.Svg(
                                                        'assets/flags_svg/${flags[country.countryCode ?? 'USA']}',
                                                      ),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 15.w,
                                                    ),
                                                    SizedBox(
                                                      width: 13.w,
                                                    ),
                                                    Text(
                                                      country.entity.length < 22
                                                          ? country.entity
                                                          : "${country.entity.substring(0, 21)}...",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selected country",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            color:
                                                AppColors.primaryActiveColor),
                                  ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  Container(
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.appGreyColor,
                                            width: .5)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18.w),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: svgManager.Svg(
                                            'assets/flags_svg/${flags[appControllerBlocState.countryModal?.countryCode ?? 'USA']}',
                                          ),
                                          backgroundColor: Colors.transparent,
                                          radius: 15.w,
                                        ),
                                        SizedBox(
                                          width: 13.w,
                                        ),
                                        Text(
                                          appControllerBlocState.countryModal !=
                                                  null
                                              ? appControllerBlocState
                                                          .countryModal!
                                                          .entity
                                                          .length <
                                                      22
                                                  ? appControllerBlocState
                                                          .countryModal
                                                          ?.entity ??
                                                      ''
                                                  : '${appControllerBlocState.countryModal?.entity.substring(0, 21)}...'
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Form(
                                key: formKey['currencyKey'],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Default Currency",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                              color:
                                                  AppColors.primaryActiveColor),
                                    ),
                                    SizedBox(
                                      height: 9.h,
                                    ),
                                    SizedBox(
                                        width: double.maxFinite,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<
                                              CurrencyAndSymbol>(
                                            validator: (value) => value == null
                                                ? 'Currency is required'
                                                : null,
                                            focusNode: nodes['currencyKey'],
                                            icon: Center(
                                                child: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 32.sp,
                                            )),
                                            hint: const Text(
                                                "Or Select a Currency"),
                                            value: selectedCurrencyAndSymbol,
                                            isDense: true,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCurrencyAndSymbol =
                                                    newValue;
                                              });
                                            },
                                            items: appControllerBlocState
                                                .currencyList
                                                .map((currency) {
                                              return DropdownMenuItem<
                                                  CurrencyAndSymbol>(
                                                value: currency,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${currency.currencyCode}(${currency.currencySymbol})",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Birthday",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            color:
                                                AppColors.primaryActiveColor),
                                  ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showDatePicker(context, selectedDate);
                                    },
                                    child: Container(
                                      height: 45.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.appGreyColor,
                                              width: .5)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.w),
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30.h,
                              ),

                              //Invalid inputs are not allowed. Profile image, Country, Default currency, Date of Birth& Phone only allowed
                              AppButton2(
                                isLoading: state.isLoading,
                                filled: true,
                                onTap: () async {
                                  for (var element in formKey.entries) {
                                    if (!element.value.currentState!
                                        .validate()) {
                                      scrollController.jumpTo(scrollController
                                          .position.minScrollExtent);
                                      nodes[element.key]?.requestFocus();

                                      return;
                                    }
                                  }

                                  BlocProvider.of<UserProfileBloc>(context).add(
                                      UserProfileEvent.saveMyProfile(data: {
                                    'firstName':
                                        firstNameController.text.trim(),
                                    'lastName': lastNameController.text.trim(),
                                    'profileImage': selectedImage != null
                                        ? MultipartFile.fromFileSync(
                                            selectedImage!.path,
                                            filename:
                                                selectedImage?.path.toString(),
                                            contentType:
                                                MediaType('image', 'png'))
                                        : '',
                                    'country': selectedCountry?.entity,
                                    'defaultCurrency':
                                        selectedCurrencyAndSymbol?.currencyCode,
                                    'dob': DateFormat('yyyy-MM-dd')
                                        .format(selectedDate),
                                    'phone':
                                        _contactNumberController.text.trim()
                                  }, country: selectedCountry));
                                },
                                text: Text(
                                  "Save",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                feedbackTimeText: Text(
                                  "Save",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.copyWith(
                                          color: AppColors.primaryActiveColor),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<XFile?> _selectImage(BuildContext context) async {
    final img = await ImageUtils.getImage(context);
    if (img == null) {
      return null;
    }
    final image = img as XFile;
    final size = await image.length();
    if (size > 2097152) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image must be less than 2MB')));
        return null;
      }
    }
    return image;
  }

  void mapAndInitCountry(
      AppControllerState appControllerBlocState, UserProfileState state) {
    if (appControllerBlocState.countries.isNotEmpty) {
      selectedCountry = appControllerBlocState.countries.firstWhere((element) {
        return element.countryCode ==
            state.userProfileModal?.user.country.details.countryCode;
      },
          orElse: () => appControllerBlocState.countries.firstWhere((element) =>
              element.countryCode ==
              appControllerBlocState.countryModal?.countryCode));
    }

    selectedCurrencyAndSymbol = appControllerBlocState.currencyList.firstWhere(
        (element) {
      return element.currencyCode ==
          state.userProfileModal?.user.defaultCurrency;
    },
        orElse: () => appControllerBlocState.currencyList
            .firstWhere((element) => element.currencyCode == "USD"));
  }

  _showDatePicker(BuildContext context, DateTime currentDate) {
    if (Platform.isIOS) {
      _showCupertinoDatePicker(
          CupertinoDatePicker(
            minimumDate: DateTime(
              1970,
            ),
            maximumDate: DateTime(DateTime.now().year - 18,
                DateTime.now().month, DateTime.now().day),
            mode: CupertinoDatePickerMode.date,
            initialDateTime:
                currentDate == DateTime.fromMicrosecondsSinceEpoch(1)
                    ? DateTime(
                        1970,
                      )
                    : currentDate,
            use24hFormat: true,
            // This is called when the user changes the dateTime.
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                selectedDate = newDateTime;
              });
            },
          ),
          context);
      return;
    }
    showDatePicker(
      context: context,
      initialDate: currentDate == DateTime.fromMicrosecondsSinceEpoch(1)
          ? DateTime(
              1970,
            )
          : currentDate,
      firstDate: DateTime(
        1970,
      ),
      lastDate: DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
    ).then((newDateTime) => newDateTime != null
        ? setState(() => selectedDate = newDateTime)
        : null);
  }

  void _showCupertinoDatePicker(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({
    Key? key,
    this.image,
    this.existingImage,
  }) : super(key: key);

  final XFile? image;
  final String? existingImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DottedBorder(
          color: existingImage != null || image != null
              ? AppColors.appWhite
              : AppColors.appGreyColor,
          dashPattern: const [5, 5],
          radius: Radius.circular(50.r),
          borderType: BorderType.Circle,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  image != null ? FileImage(File(image!.path)) : null,
              foregroundImage: existingImage != null
                  ? existingImage!.isNotEmpty
                      ? NetworkImage(existingImage!)
                      : null
                  : null,
              radius: 50.r,
              child: image == null
                  ? Center(
                      child: SvgPicture.asset(
                      SvgAssets.cameraIcon,
                      fit: BoxFit.contain,
                      width: 42.w,
                      height: 37.h,
                    ))
                  : const SizedBox(),
            ),
          ),
        ),
        if (image != null || existingImage != null)
          Positioned(
              right: 5,
              bottom: 5,
              child: CircleAvatar(
                backgroundColor: AppColors.appGreyColor,
                radius: 11.r,
                child: CircleAvatar(
                  backgroundColor: AppColors.appWhite,
                  radius: 10.r,
                  child: SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child: SvgPicture.asset(SvgAssets.cameraIcon),
                  ),
                ),
              ))
      ],
    );
  }
}


