import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/flight_class_radio.dart';
import 'package:e_porter/presentation/screens/home/component/flight_date_selector.dart';
import 'package:e_porter/presentation/screens/home/component/flight_selector.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BookingTickets extends StatefulWidget {
  const BookingTickets({super.key});

  @override
  State<BookingTickets> createState() => _BookingTicketsState();
}

class _BookingTicketsState extends State<BookingTickets> {
  DateTime selectedDate = DateTime.now();
  String selectedDateText = 'dd/mm/yyyy';

  final ValueNotifier<String> selectedClass = ValueNotifier<String>('Economy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Pesan Tiket',
        backgroundColors: Colors.white,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Stack(
            children: [
              IntrinsicHeight(
                child: CustomeShadowCotainner(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlightSelector(
                        label: 'Dari',
                        hintText: 'Pilih Bandara',
                        svgIconPath: CustomeIcons.PlaneRightOutline(),
                        onTap: () {
                          Get.toNamed(Routes.SEARCHFLIGHT);
                        },
                      ),
                      SizedBox(height: 16.h),
                      FlightSelector(
                        label: 'Ke',
                        hintText: 'Pilih Bandara',
                        svgIconPath: CustomeIcons.PlaneLeftOutline(),
                        onTap: () {
                          Get.toNamed(Routes.SEARCHFLIGHT);
                        },
                      ),
                      SizedBox(height: 16.h),
                      FlightDateSelector(
                        label: 'Tanggal pergi',
                        valueText: selectedDateText,
                        svgIconPath: 'assets/icons/ic_calendar.svg',
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2045),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: PrimaryColors.primary800,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                              selectedDateText = DateFormat('EEE, d MMM yyyy', 'en_US').format(selectedDate);
                              print(selectedDate);
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlightSelector(
                            label: 'Kelas penerbangan',
                            hintText: 'Pilih Kelas',
                            svgIconPath: CustomeIcons.FlightSeatOutline(),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                  ),
                                ),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Wrap(
                                      children: [
                                        _buildTitleShowModal('Kelas Penerbangan'),
                                        _buildFlightClassRadio(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          FlightSelector(
                            label: 'Penumpang',
                            hintText: '1 Dewasa',
                            svgIconPath: CustomeIcons.PassengerOutline(),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                  ),
                                ),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Wrap(
                                      children: [
                                        _buildTitleShowModal('Tambah Penumpang'),
                                        _buildFlightAddPassenger(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      TypographyStyles.small(
                        'Penumpang bayi tidak mendapatkan kursi sendiri',
                        color: GrayColors.gray500,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 20.h),
                      ButtonFill(
                        text: 'Cari Tiket',
                        textColor: Colors.white,
                        onTap: () {
                          Get.toNamed(Routes.SEARCHTICKETS);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 40.w, // geser agak ke dalam dari sisi kanan
                top: 65.h, // posisikan di tengah2 antara dua card
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        strokeAlign: 1.5,
                        color: GrayColors.gray200,
                      ),
                    ),
                    child: CustomeIcons.DataTransferOutline(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleShowModal(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 166.w, vertical: 16.h),
          child: Divider(
            thickness: 4,
            color: Color(0xFFD9D9D9),
          ),
        ),
        TypographyStyles.h6(text, color: GrayColors.gray800),
      ],
    );
  }

  Widget _buildFlightClassRadio() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
      ),
      child: ValueListenableBuilder<String>(
        valueListenable: selectedClass,
        builder: (context, selectedValue, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlightClassRadio(
                title: 'Economy',
                subTitle: 'Memenuhi kebutuhan utama Anda dengan biaya terendah',
                value: 'Economy',
                groupValue: selectedValue,
                onChanged: (value) {
                  selectedClass.value = value!;
                },
              ),
              SizedBox(height: 10.h),
              FlightClassRadio(
                title: 'Premium Economy',
                subTitle: 'Perjalanan terjangkau dengan makanan lezat dan ruang lebih lega',
                value: 'Premium Economy',
                groupValue: selectedValue,
                onChanged: (value) {
                  selectedClass.value = value!;
                },
              ),
              SizedBox(height: 10.h),
              FlightClassRadio(
                title: 'Business',
                subTitle: 'Terbang nyaman dengan konter check-in dan kursi eksklusif',
                value: 'Business',
                groupValue: selectedValue,
                onChanged: (value) {
                  selectedClass.value = value!;
                },
              ),
              SizedBox(height: 10.h),
              FlightClassRadio(
                title: 'First Class',
                subTitle: 'Kelas paling mewah dengan layanan terbaik dan personal',
                value: 'First Class',
                groupValue: selectedValue,
                onChanged: (value) {
                  selectedClass.value = value!;
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFlightAddPassenger() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h),
        TypographyStyles.caption(
          'Dewasa',
          color: GrayColors.gray800,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 2.h),
        TypographyStyles.small(
          '3 Tahun ke atas',
          color: GrayColors.gray600,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 14.h),
        Container(
          height: 100.h,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: 0), // Start at 1
            itemExtent: 45.0, // Set the height of each item
            selectionOverlay: CircleAvatar(
              radius: 18.r,
              backgroundColor: PrimaryColors.primary800.withOpacity(0.7),
            ),
            onSelectedItemChanged: (index) {},
            children: List<Widget>.generate(10, (index) {
              return Center(
                child: TypographyStyles.body('${index + 1}'),
              );
            }),
          ),
        ),
        // CircleAvatar(
        //   radius: 18.r,
        //   backgroundColor: PrimaryColors.primary800,
        //   child: Obx(
        //     () => TypographyStyles.body(
        //       '${bookingTiketcController.selectedNumber.value}',
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        // SizedBox(height: 10),
        // CupertinoPicker(
        //   itemExtent: 50, // Tinggi tiap item
        //   backgroundColor: Colors.white,
        //   selectionOverlay: Container(
        //     color: Colors.white.withOpacity(0.1),
        //   ),
        //   scrollController: FixedExtentScrollController(
        //       initialItem: bookingTiketcController.selectedNumber.value - 1), // Set default pilihan
        //   onSelectedItemChanged: (int index) {
        //     bookingTiketcController.updateNumber(index + 1);
        //   },
        //   children: List.generate(
        //     10,
        //     (index) => Center(
        //       child: CircleAvatar(
        //         radius: 18.r,
        //         backgroundColor: GrayColors.gray50,
        //         child: TypographyStyles.body(
        //           '${index + 1}',
        //           color: GrayColors.gray300,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: ZoomTapAnimation(
            child: ButtonFill(
              text: 'Selesai',
              textColor: Colors.white,
              onTap: () {},
            ),
          ),
        ),
        // SizedBox(height: 16.h)
      ],
    );
  }
}
