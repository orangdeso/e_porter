// ignore_for_file: deprecated_member_use

import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/button/switch_button.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/domain/models/ticket_model.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
import 'package:e_porter/presentation/controllers/ticket_controller.dart';
import 'package:e_porter/presentation/screens/home/component/card_flight_information.dart';
import 'package:e_porter/presentation/screens/home/component/title_show_modal.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TicketBookingStep1Screen extends StatefulWidget {
  const TicketBookingStep1Screen({super.key});

  @override
  State<TicketBookingStep1Screen> createState() => _TicketBookingStep1ScreenState();
}

class _TicketBookingStep1ScreenState extends State<TicketBookingStep1Screen> {
  bool isToggled = false;
  late final String ticketId;
  late final String flightId;
  late final String ticketDate;
  late final int passenger;
  late Future<FlightModel> _flightFuture;
  late final TicketController ticketController;
  final ProfilController profilController = Get.find<ProfilController>();
  final currencyFormatter = NumberFormat.decimalPattern('id_ID');
  dynamic _loggedUser;
  List<PassengerModel?> selectedPassengers = [];

  String? departureTime;
  String? arrivalTime;
  String? cityDeparture;
  String? cityArrival;
  String? airLines;
  String? code;
  String? flightClass;
  String? transitAirplane;
  String? stop;
  String? codeDeparture;
  String? codeArrival;
  String? airlineLogo;

  @override
  void initState() {
    super.initState();
    _loadPassengers();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'];
    flightId = args['flightId'];
    ticketDate = args['ticketDate'];
    passenger = args['passenger'];

    ticketController = Get.find<TicketController>();
    _flightFuture = ticketController.getFlightById(ticketId: ticketId, flightId: flightId);

    selectedPassengers = List.filled(passenger, null, growable: false);
  }

  PassengerModel _convertUserDataToPassengerModel(UserData userData) {
    return PassengerModel(
      name: userData.name ?? '',
      typeId: userData.tipeId ?? '',
      noId: userData.noId ?? '',
      gender: userData.gender ?? '',
    );
  }

  Future<void> _loadPassengers() async {
    final userData = await PreferencesService.getUserData();
    if (userData == null || userData.uid.isEmpty) {
      SnackbarHelper.showError('Error', 'User ID tidak ditemukan, silakan login kembali');
      return;
    }
    final userId = userData.uid;
    await profilController.fetchPassangerById(userId);
    // logger.d('User ID: $userId');
  }

  bool isAllPassengersFilled() {
    if (isToggled && _loggedUser != null) {
      return selectedPassengers.skip(1).every((p) => p != null);
    } else {
      return selectedPassengers.every((p) => p != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 1 dari 4',
        onTab: () {
          Get.back();
        },
      ),
      body: FutureBuilder<FlightModel>(
        future: _flightFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Data tidak ditemukan"));
          }
          final flight = snapshot.data!;

          departureTime = DateFormat.jm().format(flight.departureTime);
          arrivalTime = DateFormat.jm().format(flight.arrivalTime);
          cityDeparture = flight.cityDeparture;
          cityArrival = flight.cityArrival;
          airLines = flight.airLines;
          code = flight.code;
          flightClass = flight.flightClass;
          transitAirplane = flight.transitAirplane;
          stop = flight.stop;
          codeDeparture = flight.codeDeparture;
          codeArrival = flight.codeArrival;
          airlineLogo = flight.airlineLogo;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardFlightInformation(
                      date: ticketDate,
                      time: '$departureTime - $arrivalTime',
                      departureCity: '$cityDeparture',
                      arrivalCity: '$cityArrival',
                      plane: '${airLines} (${code})',
                      seatClass: '$flightClass',
                      passenger: '$passenger',
                      transiAirplane: '$transitAirplane',
                      stop: '$stop',
                      airlineLogo: airlineLogo,
                    ),
                    SizedBox(height: 32.h),
                    TypographyStyles.h6('Detail Pemesanan', color: GrayColors.gray800),
                    SizedBox(height: 20.h),
                    _buildCardUsers(),
                    SizedBox(height: 32.h),
                    TypographyStyles.h6('Detail Penumpang', color: GrayColors.gray800),
                    SizedBox(height: 20.h),
                    _buildCardDetailPessenger()
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: ButtonFill(
          text: 'Lanjutkan',
          textColor: Colors.white,
          backgroundColor: isAllPassengersFilled() ? PrimaryColors.primary800 : GrayColors.gray400,
          onTap: () {
            // logger.d('Selected Passengers: $selectedPassengers');
            if (selectedPassengers.any((p) => p == null)) {
              SnackbarHelper.showError('Error', 'Harap lengkapi slot penumpang');
            } else {
              final argument = {
                'ticketId': ticketId,
                'flightId': flightId,
                'date': ticketDate,
                'departureTime': departureTime,
                'arrivalTime': arrivalTime,
                'cityDeparture': cityDeparture,
                'cityArrival': cityArrival,
                'airLines': airLines,
                'code': code,
                'flightClass': flightClass,
                'transitAirplane': transitAirplane,
                'stop': stop,
                'codeDeparture': codeDeparture,
                'codeArrival': codeArrival,
                'airlineLogo': airlineLogo,
                'passenger': passenger,
                'selectedPassenger': selectedPassengers,
              };

              Get.toNamed(Routes.TICKETBOOKINGSTEP2, arguments: argument);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCardUsers() {
    return FutureBuilder(
      future: PreferencesService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return SizedBox.shrink();
        } else if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          _loggedUser = user;
          // logger.d('Data user: ${user.noId}');
          return CustomeShadowCotainner(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypographyStyles.small('Nama', fontWeight: FontWeight.w400, color: GrayColors.gray600),
                SizedBox(height: 10.h),
                TypographyStyles.body(user.name ?? 'User not found',
                    color: GrayColors.gray800, fontWeight: FontWeight.w500),
                SizedBox(height: 16.h),
                TypographyStyles.small('Email', fontWeight: FontWeight.w400, color: GrayColors.gray600),
                SizedBox(height: 10.h),
                TypographyStyles.body(user.email ?? 'Email not found',
                    color: GrayColors.gray800, fontWeight: FontWeight.w500),
                SizedBox(height: 16.h),
                TypographyStyles.small('No Telepon', fontWeight: FontWeight.w400, color: GrayColors.gray600),
                SizedBox(height: 10.h),
                TypographyStyles.body(user.phone ?? 'Number phone not found',
                    color: GrayColors.gray800, fontWeight: FontWeight.w500),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TypographyStyles.caption(
                      'Tambahkan sebagai penumpang',
                      color: GrayColors.gray800,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(width: 20.w),
                    SwitchButton(
                      value: isToggled,
                      onChanged: (newValue) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isPassengerAdd', newValue);

                        setState(() {
                          isToggled = newValue;
                          if (!newValue) {
                            selectedPassengers[0] = null;
                          } else if (_loggedUser != null) {
                            selectedPassengers[0] = _convertUserDataToPassengerModel(_loggedUser);
                          }
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          );
        } else {
          return CustomeShadowCotainner(
            child: Center(
              child: TypographyStyles.body(
                "Data user tidak tersedia",
                color: GrayColors.gray600,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCardDetailPessenger() {
    return Column(
      children: List.generate(
        passenger,
        (index) {
          if (isToggled && index == 0 && _loggedUser != null) {
            return _buildUserPassengerCard(_loggedUser, index);
          } else {
            final p = selectedPassengers[index];
            if (p != null) {
              return _buildSelectedPassengerCard(p, index);
            } else {
              return _buildEmptyPassengerCard(index);
            }
          }
        },
      ),
    );
  }

  Widget _buildUserPassengerCard(dynamic user, int index) {
    bool isSlotEditTable = !isToggled || index != 0;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomeShadowCotainner(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypographyStyles.body(
                  '${_loggedUser.name}',
                  color: GrayColors.gray800,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                TypographyStyles.caption(
                  "${_loggedUser.tipeId} - ${_loggedUser.noId}",
                  color: GrayColors.gray800,
                  fontWeight: FontWeight.w400,
                )
              ],
            ),
            Row(
              children: [
                ZoomTapAnimation(
                  child: IconButton(
                    icon: CustomeIcons.RemoveOutline(),
                    onPressed: () {
                      setState(() {
                        selectedPassengers[0] = null;
                        isToggled = false;
                      });
                    },
                  ),
                ),
                if (isSlotEditTable)
                  ZoomTapAnimation(
                    child: GestureDetector(
                      child: CustomeIcons.EditOutline(),
                      onTap: () {
                        Get.bottomSheet(
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                            child: Wrap(
                              children: [
                                TitleShowModal(
                                  text: 'Informasi Penumpang',
                                  onTap: () async {
                                    if (Get.isBottomSheetOpen ?? false) {
                                      Get.back();
                                    }
                                    await Future.delayed(Duration(seconds: 1));
                                    var result = await Get.toNamed(Routes.ADDPASSENGER);
                                    if (result == true) {
                                      _loadPassengers().then((_) => setState(() {}));
                                    }
                                  },
                                ),
                                Obx(
                                  () {
                                    if (profilController.passengerList.isEmpty) {
                                      return Center(
                                        child: TypographyStyles.body(
                                          "Belum ada penumpang",
                                          color: GrayColors.gray400,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: profilController.passengerList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final passenger = profilController.passengerList[index];
                                        // logger.d("Passenger Models : ${passenger.noId}");
                                        return Padding(
                                          padding: EdgeInsets.only(top: 16.h),
                                          child: _buildAddPassenger(
                                            context,
                                            title: "${passenger.name}",
                                            subTitle: "${passenger.typeId} - ${passenger.noId}",
                                            onTap: () {
                                              selectedPassengers[index] = passenger;
                                              Get.back();
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPassengerCard(PassengerModel p, int slotIndex) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomeShadowCotainner(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypographyStyles.body(
                  '${p.name}',
                  color: GrayColors.gray800,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                TypographyStyles.caption(
                  "${p.typeId} - ${p.noId}",
                  color: GrayColors.gray800,
                  fontWeight: FontWeight.w400,
                )
              ],
            ),
            Row(
              children: [
                ZoomTapAnimation(
                  child: IconButton(
                    icon: CustomeIcons.RemoveOutline(),
                    onPressed: () {
                      setState(() {
                        selectedPassengers[slotIndex] = null;
                      });
                    },
                  ),
                ),
                ZoomTapAnimation(
                  child: GestureDetector(
                    child: CustomeIcons.EditOutline(),
                    onTap: () {
                      _onEditPassenger(slotIndex);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPassengerCard(int slotIndex) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomeShadowCotainner(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TypographyStyles.body(
              'Penumpang ${slotIndex + 1} (Dewasa)',
              color: GrayColors.gray800,
              fontWeight: FontWeight.w500,
            ),
            ZoomTapAnimation(
              child: GestureDetector(
                child: CustomeIcons.EditOutline(),
                onTap: () {
                  _onEditPassenger(slotIndex);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddPassenger(
    BuildContext context, {
    required String title,
    required String subTitle,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: GrayColors.gray50,
            border: Border.all(width: 1.w, color: GrayColors.gray200),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.body(title, color: enabled ? GrayColors.gray800 : GrayColors.gray300),
                  SizedBox(height: 4.h),
                  TypographyStyles.caption(
                    "${subTitle}",
                    color: enabled ? GrayColors.gray800 : GrayColors.gray300,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              SvgPicture.asset(
                'assets/icons/ic_more_than.svg',
                color: enabled ? PrimaryColors.primary800 : GrayColors.gray300,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onEditPassenger(int slotIndex) {
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Wrap(
          children: [
            TitleShowModal(
              text: 'Informasi Penumpang',
              onTap: () async {
                if (Get.isBottomSheetOpen ?? false) {
                  Get.back();
                }
                await Future.delayed(Duration(seconds: 1));
                var result = await Get.toNamed(Routes.ADDPASSENGER);
                if (result == true) {
                  _loadPassengers().then((_) => setState(() {}));
                }
              },
            ),
            Obx(
              () {
                final usedNoIds = selectedPassengers.where((p) => p != null).map((p) => p!.noId).toSet();
                if (profilController.passengerList.isEmpty) {
                  return Center(
                    child: TypographyStyles.body(
                      "Belum ada penumpang",
                      color: GrayColors.gray400,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: profilController.passengerList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, pIndex) {
                    final passenger = profilController.passengerList[pIndex];
                    final isUsed = usedNoIds.contains(passenger.noId);
                    // logger.d("Passenger Models : ${passenger.noId}");
                    return Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: _buildAddPassenger(
                        context,
                        title: "${passenger.name}",
                        subTitle: "${passenger.typeId} - ${passenger.noId}",
                        enabled: !isUsed,
                        onTap: isUsed
                            ? null
                            : () {
                                selectedPassengers[slotIndex] = passenger;
                                Get.back();
                                setState(() {});
                              },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
    );
  }
}
