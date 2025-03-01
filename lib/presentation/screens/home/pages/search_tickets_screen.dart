import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/presentation/screens/home/component/card_tickets.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchTicketsScreen extends StatefulWidget {
  const SearchTicketsScreen({super.key});

  @override
  State<SearchTicketsScreen> createState() => _SearchTicketsScreenState();
}

class _SearchTicketsScreenState extends State<SearchTicketsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: CustomeAppbarComponent(
        valueDari: 'Yogyakarta',
        valueKe: 'Lombok',
        date: 'Sen, 27 Jn 2025',
        passenger: '2',
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypographyStyles.h6('Pilih Pesawat', color: GrayColors.gray800, letterSpacing: 0.2),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CardTickets(
                        departureCity: 'Yogyakarta (YIA)',
                        date: 'Sen, 27 Jan',
                        arrivalCity: 'Lombok (LOP)',
                        departureCode: 'YIA',
                        arrivalCode: 'LOP',
                        departureTime: '12.20 AM',
                        arrivalTime: '06.00 AM',
                        duration: '5j 40m',
                        seatClass: 'Economy',
                        price: 'Rp 1.200.000',
                        onTap: () {
                          Get.toNamed(Routes.TICKETBOOKINGSTEP1);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
