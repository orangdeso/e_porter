import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../component/card_boarding_pass.dart';

class BoardingPassScreen extends StatefulWidget {
  const BoardingPassScreen({super.key});

  @override
  State<BoardingPassScreen> createState() => _BoardingPassScreenState();
}

class _BoardingPassScreenState extends State<BoardingPassScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: SimpleAppbarComponent(
        title: 'Boarding Pass',
        subTitle: 'Semua boarding pass pesawat yang aktif ditampilkan dihalaman ini',
        onTab: () {
          Get.toNamed(Routes.TRANSACTIONHISTORY);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: PrimaryColors.primary800,
                unselectedLabelColor: GrayColors.gray400,
                indicatorColor: PrimaryColors.primary800,
                tabs: const [
                  Tab(text: 'Belum dibayar'),
                  Tab(text: 'Sedang aktif'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CardBoardingPass(
                            isActive: false,
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CardBoardingPass(isActive: true),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
