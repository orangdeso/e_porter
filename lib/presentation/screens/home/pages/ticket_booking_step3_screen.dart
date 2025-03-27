import 'dart:developer';

import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/icons/icons_library.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/logger_service.dart';
import 'package:e_porter/presentation/screens/home/component/footer_price.dart';
import 'package:e_porter/presentation/screens/home/component/porter_radio.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../domain/models/porter_service_model.dart';
import '../../../../domain/models/ticket_model.dart';
import '../../../../domain/models/user_entity.dart';
import '../../../controllers/porter_service_controller.dart';
import '../../../controllers/ticket_controller.dart';
import '../component/card_flight_information.dart';

class TicketBookingStep3Screen extends StatefulWidget {
  const TicketBookingStep3Screen({super.key});

  @override
  State<TicketBookingStep3Screen> createState() => _TicketBookingStep3ScreenState();
}

class _TicketBookingStep3ScreenState extends State<TicketBookingStep3Screen> {
  final ValueNotifier<String> selectedPorter1 = ValueNotifier<String>('');
  final ValueNotifier<String> selectedPorter2 = ValueNotifier<String>('');
  final ValueNotifier<String> selectedPorter3 = ValueNotifier<String>('');

  Map<int, String> layananTipe = {1: 'departure', 2: 'arrival', 3: 'transit'};

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

  late final PorterServiceController _porterController;
  final TicketController ticketController = Get.find<TicketController>();
  late final String ticketId;
  late final String flightId;
  late String? ticketDate;
  late final int passenger;
  late final List<PassengerModel?> selectedPassengers;
  late List<String> numberSeat;

  FlightModel? flightData;
  String? departureTime;
  String? arrivalTime;

  double totalPrice = 0.0;
  double totalPriceService = 0.0;
  PorterServiceModel? selectedDepartureService;
  PorterServiceModel? selectedArrivalService;
  PorterServiceModel? selectedTransitService;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'];
    flightId = args['flightId'];
    ticketDate = args['date'];
    passenger = args['passenger'] ?? 0;
    selectedPassengers = args['selectedPassenger'] ?? [];
    numberSeat = args['numberSeat'];

    _porterController = Get.find<PorterServiceController>();
    _porterController.fetchLayananPorter();

    fetchDataFlight();
  }

  Future<void> fetchDataFlight() async {
    try {
      FlightModel flight = await ticketController.getFlightById(ticketId: ticketId, flightId: flightId);
      setState(() {
        flightData = flight;
        departureTime = DateFormat.jm().format(flightData!.departureTime);
        arrivalTime = DateFormat.jm().format(flightData!.arrivalTime);
      });
    } catch (e) {
      logger.e('Terjadi kesalahan: $e');
    }
  }

  double calculateTotalPrice(double ticketPrice, int passengerCount) {
    return ticketPrice * passengerCount;
  }

  void updateServicePrice(double servicePrice, bool isSelected) {
    setState(() {
      if (isSelected) {
        totalPriceService += servicePrice;
      } else {
        totalPriceService -= servicePrice;
      }
    });
  }

  void _onCheckboxChanged(int checkboxNumber, bool? value) {
    setState(() {
      switch (checkboxNumber) {
        case 1:
          bool oldValue = _isChecked1;
          _isChecked1 = value ?? false;

          if (oldValue && !_isChecked1 && selectedDepartureService != null) {
            totalPriceService -= selectedDepartureService!.price;
            selectedDepartureService = null;
            selectedPorter1.value = '';
          }
          break;
        case 2:
          bool oldValue = _isChecked2;
          _isChecked2 = value ?? false;

          if (oldValue && !_isChecked2 && selectedArrivalService != null) {
            totalPriceService -= selectedArrivalService!.price;
            selectedArrivalService = null;
            selectedPorter2.value = '';
          }
          break;
        case 3:
          bool oldValue = _isChecked3;
          _isChecked3 = value ?? false;

          if (oldValue && !_isChecked3 && selectedTransitService != null) {
            totalPriceService -= selectedTransitService!.price;
            selectedTransitService = null;
            selectedPorter3.value = '';
          }
          break;
      }
    });
  }

  void _onPorterSelectionChanged(PorterServiceModel service, bool isSelected, String serviceType) {
    setState(() {
      if (serviceType == 'departure') {
        if (isSelected) {
          if (selectedDepartureService != null) {
            totalPriceService -= selectedDepartureService!.price;
          }
          totalPriceService += service.price;
          selectedDepartureService = service;
        } else {
          if (selectedDepartureService != null) {
            totalPriceService -= selectedDepartureService!.price;
            selectedDepartureService = null;
          }
        }
      } else if (serviceType == 'arrival') {
        if (isSelected) {
          if (selectedArrivalService != null) {
            totalPriceService -= selectedArrivalService!.price;
          }
          totalPriceService += service.price;
          selectedArrivalService = service;
        } else {
          if (selectedArrivalService != null) {
            totalPriceService -= selectedArrivalService!.price;
            selectedArrivalService = null;
          }
        }
      } else if (serviceType == 'transit') {
        if (isSelected) {
          if (selectedTransitService != null) {
            totalPriceService -= selectedTransitService!.price;
          }
          totalPriceService += service.price;
          selectedTransitService = service;
        } else {
          if (selectedTransitService != null) {
            totalPriceService -= selectedTransitService!.price;
            selectedTransitService = null;
          }
        }
      }
    });
  }

  List<String> _getSelectedServices() {
    List<String> selectedServices = [];
    if (_isChecked1) selectedServices.add("Keberangkatan: Fast Track");
    if (_isChecked2) selectedServices.add("Kedatangan: Porter VIP");
    if (_isChecked3) selectedServices.add("Transit: Transit");
    return selectedServices;
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = calculateTotalPrice(flightData?.price.toDouble() ?? 0.0, passenger);
    double grandTotal = totalPrice + totalPriceService;

    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: ProgressAppbarComponent(
        title: 'Pesan Tiket',
        subTitle: 'Langkah 3 dari 4',
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardFlightInformation(
                  date: '$ticketDate',
                  time: "${departureTime} - ${arrivalTime}",
                  departureCity: '${flightData?.cityDeparture}',
                  arrivalCity: "${flightData?.cityArrival}",
                  plane: "${flightData?.airLines} (${flightData?.code})",
                  seatClass: "${flightData?.flightClass}",
                  passenger: "$passenger",
                  stop: "${flightData?.stop}",
                  transiAirplane: "${flightData?.transitAirplane}",
                ),
                SizedBox(height: 32.h),
                TypographyStyles.h6("Layanan Porter", color: GrayColors.gray800),
                SizedBox(height: 10.h),
                TypographyStyles.caption(
                  "Silahkan pilih opsi penerbangan untuk mencari layanan porter yang cocok untuk perjalanan Anda",
                  color: GrayColors.gray600,
                  fontWeight: FontWeight.w400,
                  maxlines: 3,
                ),
                SizedBox(height: 16.h),
                _buildCheckBox(
                  context,
                  label: "Keberangkatan",
                  Widget: CustomeIcons.AirplaneTakeOffOutline(color: Colors.white),
                  value: _isChecked1,
                  onTap: (bool? value) {
                    _onCheckboxChanged(1, value);
                  },
                ),
                if (_isChecked1)
                  _buildPorterServicesList(selectedPorter: selectedPorter1, serviceType: layananTipe[1]!),
                SizedBox(height: 10.h),
                _buildCheckBox(
                  context,
                  label: "Kedatangan",
                  Widget: CustomeIcons.AirplaneLandingOutline(color: Colors.white),
                  value: _isChecked2,
                  onTap: (bool? value) {
                    _onCheckboxChanged(2, value);
                  },
                ),
                if (_isChecked2)
                  _buildPorterServicesList(selectedPorter: selectedPorter2, serviceType: layananTipe[2]!),
                SizedBox(height: 10.h),
                if (flightData?.stop != null && flightData!.stop.isNotEmpty) ...[
                  _buildCheckBox(
                    context,
                    label: "Transit",
                    Widget: CustomeIcons.TransitOutline(color: Colors.white),
                    value: _isChecked3,
                    onTap: (bool? value) {
                      _onCheckboxChanged(3, value);
                    },
                  ),
                  if (_isChecked3)
                    _buildPorterServicesList(selectedPorter: selectedPorter3, serviceType: layananTipe[3]!),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterPrice(
        price: "Rp ${NumberFormat.decimalPattern('id_ID').format(grandTotal)}",
        labelText: "Pesanan",
        labelButton: "Lanjut",
        onTap: () {
          List<String> selectedServiceLabels = [];
          Map<String, PorterServiceModel?> selectedPorterServices = {};

          if (_isChecked1) {
            selectedServiceLabels.add("Keberangkatan");
            selectedPorterServices['departure'] = selectedDepartureService;
          }

          if (_isChecked2) {
            selectedServiceLabels.add("Kedatangan");
            selectedPorterServices['arrival'] = selectedArrivalService;
          }

          if (_isChecked3) {
            selectedServiceLabels.add("Transit");
            selectedPorterServices['transit'] = selectedTransitService;
          }
          final argument = {
            'ticketId': ticketId,
            'flightId': flightId,
            'date': ticketDate,
            'passenger': passenger,
            'selectedPassenger': selectedPassengers,
            'numberSeat': numberSeat,
            'totalPrice': totalPrice,
            'grandTotal': grandTotal,
            'selectedServiceLabels': selectedServiceLabels,
            'selectedPorterServices': selectedPorterServices,
          };
          log('Ticket ID: $ticketId');
          log('Flight ID: $flightId');
          log('Ticket Date: $ticketDate');
          log('Opsi Penerbangan: $selectedServiceLabels');
          log('Layanan Porter: $selectedPorterServices');

          // final Map<String, dynamic> debugPorterServices = {};
          // selectedPorterServices.forEach((key, value) {
          //   if (value != null) {
          //     debugPorterServices[key] = {
          //       'id': value.id,
          //       'name': value.name,
          //       'price': value.price,
          //     };
          //   } else {
          //     debugPorterServices[key] = null;
          //   }
          // });
          // log('Layanan Porter: $debugPorterServices');

          Get.toNamed(Routes.TICKETBOOKINGSTEP4, arguments: argument);
        },
      ),
    );
  }

  Widget _buildCheckBox(
    BuildContext context, {
    required label,
    required Widget,
    required value,
    required onTap,
  }) {
    return CustomeShadowCotainner(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      child: CheckboxListTile(
        activeColor: PrimaryColors.primary800,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: PrimaryColors.primary800,
              child: Widget,
            ),
            SizedBox(width: 16.w),
            TypographyStyles.caption(
              label,
              color: GrayColors.gray800,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
        value: value,
        onChanged: onTap,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildPorterServicesList({
    required ValueNotifier<String> selectedPorter,
    required String serviceType,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 32.w, right: 0),
      child: ValueListenableBuilder<String>(
        valueListenable: selectedPorter,
        builder: (context, selectedValue, child) {
          return Obx(() {
            if (_porterController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: PrimaryColors.primary800,
                ),
              );
            }

            if (_porterController.hasError.value) {
              return Padding(
                padding: EdgeInsets.all(8.h),
                child: Text(
                  'Terjadi kesalahan: ${_porterController.pesanError.value}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            List<PorterServiceModel> filteredServices = [];
            if (serviceType == 'departure') {
              filteredServices = _porterController.layananPorterArrival;
            } else if (serviceType == 'arrival') {
              filteredServices = _porterController.layananPorterDeparture;
            } else if (serviceType == 'transit') {
              filteredServices = _porterController.layananPorterTransit;
            }

            if (filteredServices.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(8.h),
                child: Text(
                  'Tidak ada layanan porter untuk ${_getTipeLabel(serviceType)}',
                  style: TextStyle(color: GrayColors.gray600),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return Column(
                  children: [
                    PorterRadio(
                      title: service.name,
                      subTitle: service.description,
                      price: 'Rp ${NumberFormat.decimalPattern('id_ID').format(service.price)}',
                      value: service.id ?? '',
                      groupValue: selectedValue,
                      onTap: (value) {
                        selectedPorter.value = value!;
                        _onPorterSelectionChanged(service, selectedPorter.value.isNotEmpty, serviceType);
                      },
                    ),
                    SizedBox(height: 10.h),
                    Divider(thickness: 1, color: GrayColors.gray200),
                    SizedBox(height: 10.h),
                  ],
                );
              },
            );
          });
        },
      ),
    );
  }

  String _getTipeLabel(String serviceType) {
    switch (serviceType) {
      case 'departure':
        return 'Keberangkatan';
      case 'arrival':
        return 'Kedatangan';
      case 'transit':
        return 'Transit';
      default:
        return serviceType;
    }
  }
}
