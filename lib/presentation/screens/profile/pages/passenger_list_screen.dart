// ignore_for_file: deprecated_member_use
import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text_field/dropdown/dropdown_component.dart';
import 'package:e_porter/_core/component/text_field/text_input/text_field_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/_core/utils/formatter/uppercase_helper.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PassengerListScreen extends StatefulWidget {
  const PassengerListScreen({super.key});

  @override
  State<PassengerListScreen> createState() => _PassengerListScreenState();
}

class _PassengerListScreenState extends State<PassengerListScreen> {
  final ValueNotifier<String> selectedGender = ValueNotifier<String>('Laki-laki');
  final _profileController = Get.find<ProfilController>();

  // Controllers for edit form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noIdController = TextEditingController();
  String selectedTypeId = 'KTP';

  @override
  void dispose() {
    _nameController.dispose();
    _noIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPassengers();
  }

  Future<void> _loadPassengers() async {
    final userData = await PreferencesService.getUserData();
    if (userData == null || userData.uid.isEmpty) {
      SnackbarHelper.showError('Error', 'User ID tidak ditemukan, silakan login kembali');
      return;
    }
    final userId = userData.uid;
    await _profileController.fetchPassangerById(userId);
  }

  Future<void> _deletePassenger(PassengerModel passenger) async {
    if (passenger.id == null) {
      SnackbarHelper.showError('Error', 'ID Penumpang tidak valid');
      return;
    }

    final userData = await PreferencesService.getUserData();
    if (userData == null || userData.uid.isEmpty) {
      SnackbarHelper.showError('Error', 'User ID tidak ditemukan, silakan login kembali');
      return;
    }

    final userId = userData.uid;
    final success = await _profileController.deletePassenger(
      userId: userId,
      passengerId: passenger.id!,
    );

    if (success) {
      await _loadPassengers();
    }
  }

  Future<void> _updatePassenger(PassengerModel passenger) async {
    if (passenger.id == null) {
      SnackbarHelper.showError('Error', 'ID Penumpang tidak valid');
      return;
    }

    if (_nameController.text.isEmpty) {
      SnackbarHelper.showError('Error', 'Nama tidak boleh kosong');
      return;
    }

    if (_noIdController.text.isEmpty) {
      SnackbarHelper.showError('Error', 'Nomor ID tidak boleh kosong');
      return;
    }

    final userData = await PreferencesService.getUserData();
    if (userData == null || userData.uid.isEmpty) {
      SnackbarHelper.showError('Error', 'User ID tidak ditemukan, silakan login kembali');
      return;
    }

    final userId = userData.uid;

    final updatedPassenger = PassengerModel(
      id: passenger.id,
      name: _nameController.text,
      typeId: selectedTypeId,
      noId: _noIdController.text,
      gender: selectedGender.value,
    );

    final success = await _profileController.updatePassenger(
      userId: userId,
      passengerId: passenger.id!,
      passenger: updatedPassenger,
    );

    if (success) {
      SnackbarHelper.showSuccess('Berhasil', 'Data penumpang berhasil diperbarui');
      await _loadPassengers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Daftar Penumpang',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Obx(
            () {
              if (_profileController.passengerList.isEmpty) {
                return Center(
                  child: TypographyStyles.body(
                    'Bulum ada penumpang',
                    color: GrayColors.gray400,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              return ListView.builder(
                itemCount: _profileController.passengerList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final passenger = _profileController.passengerList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildPassengerCard(passenger),
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Tambah Penumpang',
          textColor: Colors.white,
          onTap: () async {
            final result = await Get.toNamed(Routes.ADDPASSENGER);
            if (result == true) {
              await _loadPassengers();
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  Widget _buildPassengerCard(PassengerModel passenger) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: GrayColors.gray200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypographyStyles.caption(
                  'Dewasa (${passenger.gender})',
                  fontWeight: FontWeight.w400,
                  color: GrayColors.gray500,
                ),
                TypographyStyles.body('${passenger.name}', color: GrayColors.gray800),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_outlined, color: GrayColors.gray500, size: 24.w),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(passenger);
              } else if (value == 'details') {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                      ),
                    ),
                    child: _buildDetailContent(passenger),
                  ),
                  isScrollControlled: true,
                );
              } else if (value == 'edit') {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                      ),
                    ),
                    child: _buildEditContent(passenger),
                  ),
                  isScrollControlled: true,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18, color: GrayColors.gray600),
                    SizedBox(width: 8.w),
                    TypographyStyles.caption('Lihat Detail', color: GrayColors.gray600),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: GrayColors.gray600),
                    SizedBox(width: 8.w),
                    TypographyStyles.caption('Edit', color: GrayColors.gray600),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8.w),
                    TypographyStyles.caption('Hapus', color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(PassengerModel passenger) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.height * 0.070,
            height: 6.h,
            decoration: BoxDecoration(
              color: GrayColors.gray200,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TypographyStyles.h6('Detail Penumpang', color: GrayColors.gray800),
            ],
          ),
        ),
        TypographyStyles.caption('Nama Penumpang', color: GrayColors.gray400, fontWeight: FontWeight.w400),
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: TypographyStyles.body('${passenger.name}', color: GrayColors.gray800),
        ),
        SizedBox(height: 16.h),
        TypographyStyles.caption('Identitas', color: GrayColors.gray400, fontWeight: FontWeight.w400),
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: TypographyStyles.body('${passenger.typeId} - ${passenger.noId}', color: GrayColors.gray800),
        ),
        SizedBox(height: 16.h),
        TypographyStyles.caption('Jenis Kelamin', color: GrayColors.gray400, fontWeight: FontWeight.w400),
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: TypographyStyles.body('${passenger.gender}', color: GrayColors.gray800),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(PassengerModel passenger) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: TypographyStyles.h6('Konfirmasi', color: GrayColors.gray800),
        content: TypographyStyles.body(
          'Apakah Anda yakin ingin menghapus data penumpang ${passenger.name}?',
          fontWeight: FontWeight.w500,
          color: GrayColors.gray500,
          maxlines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: TypographyStyles.body('Batal', color: GrayColors.gray600),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _deletePassenger(passenger);
            },
            child: TypographyStyles.body('Hapus', color: RedColors.red500),
          ),
        ],
      ),
    );
  }

  Widget _buildEditContent(PassengerModel passenger) {
    _nameController.text = passenger.name;
    _noIdController.text = passenger.noId;
    selectedTypeId = passenger.typeId;
    selectedGender.value = passenger.gender;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.070,
              height: 6.h,
              decoration: BoxDecoration(
                color: GrayColors.gray200,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.h, top: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TypographyStyles.h6('Edit Penumpang', color: GrayColors.gray800),
              ],
            ),
          ),
          TypographyStyles.body('Nama Lengkap', color: GrayColors.gray600, fontWeight: FontWeight.w400),
          SizedBox(height: 16.w),
          TextFieldComponent(
            controller: _nameController,
            hintText: 'Masukkan nama lengkap',
            validators: Validators.validatorName,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              UpperCaseTextFormatter(),
            ],
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypographyStyles.body('Tipe ID', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                  SizedBox(height: 16.h),
                  DropdownComponent(
                    hintText: "Pilih jenis dokument",
                    items: ['KTP', 'Pasport'],
                    value: selectedTypeId,
                    onChanged: (value) {
                      setState(() {
                        selectedTypeId = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypographyStyles.body('No ID', color: GrayColors.gray600, fontWeight: FontWeight.w400),
                    SizedBox(height: 16.h),
                    TextFieldComponent(
                      controller: _noIdController,
                      hintText: 'Masukkan ID',
                      validators: Validators.validatorNoID,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.w),
          TypographyStyles.body('Jenis Kelamin', color: GrayColors.gray600, fontWeight: FontWeight.w400),
          Row(
            children: [
              _buildRadioButton(context, label: 'Laki-laki', value: 'Laki-laki'),
              SizedBox(width: 40.h),
              _buildRadioButton(context, label: 'Perempuan', value: 'Perempuan')
            ],
          ),
          SizedBox(height: 20.h),
          ButtonFill(
            text: 'Simpan',
            textColor: Colors.white,
            onTap: () async {
              bool isDataChanged = passenger.name != _nameController.text ||
                  passenger.typeId != selectedTypeId ||
                  passenger.noId != _noIdController.text ||
                  passenger.gender != selectedGender.value;

              if (!isDataChanged) {
                SnackbarHelper.showInfo('Info', 'Tidak ada perubahan data yang dilakukan');
                return;
              }

              if (Get.isBottomSheetOpen ?? false) {
                Get.back();
              }
              await _updatePassenger(passenger);
            },
          )
        ],
      ),
    );
  }

  Widget _buildRadioButton(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedGender,
      builder: (context, selected, child) {
        return Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selected,
              activeColor: PrimaryColors.primary800,
              onChanged: (val) {
                selectedGender.value = val!;
              },
            ),
            SizedBox(width: 10.w),
            TypographyStyles.body(label, color: GrayColors.gray800, fontWeight: FontWeight.w500)
          ],
        );
      },
    );
  }
}
