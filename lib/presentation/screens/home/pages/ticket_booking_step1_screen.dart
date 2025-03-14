import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/button/switch_button.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/logger_service.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/domain/models/ticket_model.dart';
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
  }

  Future<void> _loadPassengers() async {
    final userData = await PreferencesService.getUserData();
    if (userData == null || userData.uid.isEmpty) {
      SnackbarHelper.showError('Error', 'User ID tidak ditemukan, silakan login kembali');
      return;
    }
    final userId = userData.uid;
    await profilController.fetchPassangerById(userId);
    logger.d('User ID: $userId');
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

          final departureTime = DateFormat.jm().format(flight.departureTime);
          final arrivalTime = DateFormat.jm().format(flight.arrivalTime);

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardFlightInformation(
                      date: '${ticketDate}',
                      time: '$departureTime - $arrivalTime',
                      departureCity: '${flight.cityDeparture}',
                      arrivalCity: '${flight.cityArrival}',
                      plane: '${flight.airLines} (${flight.code})',
                      seatClass: '${flight.flightClass}',
                      passenger: '$passenger',
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
          onTap: () {
            Get.toNamed(Routes.TICKETBOOKINGSTEP2);
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
          logger.d('Data user: ${user.noId}');
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

                        setState(
                          () {
                            isToggled = newValue;
                          },
                        );
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
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CustomeShadowCotainner(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypographyStyles.body(
                    'Penumpang ${index + 1} (Dewasa)',
                    color: GrayColors.gray800,
                    fontWeight: FontWeight.w500,
                  ),
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
                                      // SnackbarHelper.showSuccess('Berhasil', 'Penumpang berhasil ditambahkan');
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
                                        logger.d("Passenger Models : ${passenger.noId}");
                                        return Padding(
                                          padding: EdgeInsets.only(top: 16.h),
                                          child: _buildAddPassenger(
                                            context,
                                            title: "${passenger.name}",
                                            subTitle: "${passenger.noId}",
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
                        // showModalBottomSheet(
                        //   context: context,
                        //   backgroundColor: Colors.white,
                        //   isScrollControlled: true,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(10.r),
                        //       topRight: Radius.circular(10.r),
                        //     ),
                        //   ),
                        //   builder: (context) {
                        //     return Padding(
                        //       padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                        //       child: Wrap(
                        //         children: [
                        //           TitleShowModal(
                        //             text: 'Informasi Penumpang',
                        //             onTap: () {
                        //               Navigator.pop(context);
                        //               Future.delayed(Duration(milliseconds: 300), () {
                        //                 Get.toNamed(Routes.ADDPASSENGER)?.then((result) {
                        //                   if (result == true) {
                        //                     _loadPassengers().then((_) => setState(() {}));
                        //                     SnackbarHelper.showSuccess('Berhasil', 'Penumpang berhasil ditambahkan');
                        //                   }
                        //                 });
                        //               });
                        //             },
                        //           ),
                        //           SizedBox(height: 16.h),
                        //           Obx(
                        //             () {
                        //               if (profilController.passengerList.isEmpty) {
                        //                 return Center(
                        //                   child: TypographyStyles.body(
                        //                     "Belum ada penumpang",
                        //                     color: GrayColors.gray400,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //                 );
                        //               }
                        //               return ListView.builder(
                        //                 itemCount: profilController.passengerList.length,
                        //                 shrinkWrap: true,
                        //                 itemBuilder: (context, index) {
                        //                   final passenger = profilController.passengerList[index];
                        //                   logger.d("Passenger Models : ${passenger.noId}");
                        //                   return Padding(
                        //                     padding: EdgeInsets.only(top: 16.h),
                        //                     child: _buildAddPassenger(
                        //                       context,
                        //                       title: "${passenger.name}",
                        //                       subTitle: "${passenger.noId}",
                        //                     ),
                        //                   );
                        //                 },
                        //               );
                        //             },
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    ));
  }

  Widget _buildAddPassenger(
    BuildContext context, {
    required String title,
    required String subTitle,
    VoidCallback? onTap,
  }) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap: onTap,
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
                  TypographyStyles.body(title, color: GrayColors.gray800),
                  SizedBox(height: 4.h),
                  TypographyStyles.caption("KTP - ${subTitle}", color: GrayColors.gray800, fontWeight: FontWeight.w400)
                ],
              ),
              SvgPicture.asset('assets/icons/ic_more _than.svg')
            ],
          ),
        ),
      ),
    );
  }
}
