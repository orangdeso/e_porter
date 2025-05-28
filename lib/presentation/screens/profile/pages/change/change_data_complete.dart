import 'dart:developer';
import 'package:e_porter/_core/component/appbar/appbar_component.dart';
import 'package:e_porter/_core/component/button/button_fill.dart';
import 'package:e_porter/_core/component/card/custome_shadow_cotainner.dart';
import 'package:e_porter/_core/component/text/custom_text.dart';
import 'package:e_porter/_core/component/text_field/dropdown/dropdown_component.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/utils/formatter/uppercase_helper.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/_core/validators/validators.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/presentation/controllers/profil_controller.dart';
import 'package:e_porter/presentation/screens/auth/component/Input_form.dart';
import 'package:e_porter/presentation/screens/profile/component/header_information.dart';
import 'package:e_porter/presentation/screens/profile/component/radio_button.dart';
import 'package:e_porter/presentation/screens/routes/app_rountes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChangeDataComplete extends StatefulWidget {
  const ChangeDataComplete({super.key});

  @override
  State<ChangeDataComplete> createState() => _ChangeDataCompleteState();
}

class _ChangeDataCompleteState extends State<ChangeDataComplete> {
  DateTime selectedDate = DateTime.now();
  String selectedDateText = 'dd/mm/yyyy';
  String? selectedWork;

  final _profileController = Get.find<ProfilController>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> selectedGender = ValueNotifier<String>('Laki-laki');

  @override
  void initState() {
    super.initState();
    _dateController.text = 'dd/mm/yyyy';
    _initializeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    selectedGender.dispose();
    super.dispose();
  }

  void _initializeData() {
    final userData = _profileController.userData.value;
    if (userData != null) {
      _nameController.text = userData.name ?? '';

      if (userData.birthDate != null && userData.birthDate!.isNotEmpty) {
        try {
          selectedDate = DateFormat('dd MMMM yyyy', 'en_US').parse(userData.birthDate!);
          _dateController.text = userData.birthDate!;
        } catch (e) {
          _dateController.text = 'dd/mm/yyyy';
        }
      } else {
        _dateController.text = 'dd/mm/yyyy';
      }

      selectedGender.value = userData.gender ?? 'Laki-laki';
      selectedWork = userData.work;
      _cityController.text = userData.city ?? '';
      _addressController.text = userData.address ?? '';
    }
  }

  Future<void> _handleSaveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userData = _profileController.userData.value;
    String formattedBirthDate = DateFormat('dd MMMM yyyy', 'en_US').format(selectedDate);

    bool hasChanges = _hasDataChanged(userData, formattedBirthDate);

    if (!hasChanges) {
      SnackbarHelper.showInfo('Info', 'Tidak ada perubahan data yang perlu disimpan');
      return;
    }

    final success = await _profileController.updateUserData(
      name: _nameController.text.trim(),
      birthDate: _dateController.text,
      gender: selectedGender.value,
      work: selectedWork!,
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (success) {
      Get.toNamed(Routes.INFORMATIONS);
    }
  }

  bool _hasDataChanged(UserData? userData, String formattedBirthDate) {
    if (userData == null) return true;

    bool nameChanged = (_nameController.text.trim()) != (userData.name ?? '');
    bool birthDateChanged = formattedBirthDate != (userData.birthDate ?? '');
    bool genderChanged = selectedGender.value != (userData.gender ?? 'Laki-laki');
    bool workChanged = selectedWork != userData.work;
    bool cityChanged = (_cityController.text.trim()) != (userData.city ?? '');
    bool addressChanged = (_addressController.text.trim()) != (userData.address ?? '');

    return nameChanged || birthDateChanged || genderChanged || workChanged || cityChanged || addressChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Informasi Data Anda',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
        onTab: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: HeaderInformation(
                title: 'Pastikan anda memasukkan informasi mengenai data diri anda dengan benar!',
              ),
            ),
            Expanded(
              child: CustomeShadowCotainner(
                height: MediaQuery.of(context).size.height * 0.67,
                borderRadius: BorderRadius.circular(0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.textPadding8('Nama Lengkap'),
                        SizedBox(height: 16.h),
                        InputForm(
                          controller: _nameController,
                          hintText: 'SUPARJO',
                          svgIconPath: 'assets/icons/ic_account.svg',
                          backgroundColor: Colors.white,
                          validator: Validators.validatorName,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                            UpperCaseTextFormatter(),
                          ],
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        CustomText.textPadding8('Tanggal Lahir'),
                        SizedBox(height: 16.h),
                        InputForm(
                          controller: _dateController,
                          hintText: 'dd/mm/yyyy',
                          svgIconPath: 'assets/icons/ic_account.svg',
                          backgroundColor: Colors.white,
                          enabled: false,
                          validator: Validators.validatorName,
                          textInputType: TextInputType.text,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
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
                                _dateController.text = DateFormat('dd MMMM yyyy', 'en_US').format(selectedDate);
                                log(selectedDate.toString());
                              });
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomText.textPadding8('Jenis Kelamin'),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            RadioButtonGender(value: 'Laki-laki', label: 'Laki-laki', selectedGender: selectedGender),
                            SizedBox(width: 40.h),
                            RadioButtonGender(value: 'Perempuan', label: 'Perempuan', selectedGender: selectedGender),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        CustomText.textPadding8('Pekerjaan'),
                        SizedBox(height: 16.h),
                        DropdownComponent(
                          width: MediaQuery.of(context).size.width,
                          hintText: "Pilih pekerjaan",
                          items: ['PELAJAR/MAHASISWA', 'KARYAWAN SWASTA', 'WIRASWASTA', 'PNS', 'TNI/POLRI'],
                          value: selectedWork,
                          onChanged: (value) {
                            setState(() {
                              selectedWork = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomText.textPadding8('Kota / Kabupaten'),
                        SizedBox(height: 16.h),
                        InputForm(
                          controller: _cityController,
                          hintText: 'Kota / Kabupaten',
                          svgIconPath: 'assets/icons/ic_account.svg',
                          backgroundColor: Colors.white,
                          validator: Validators.validatorName,
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        CustomText.textPadding8('Alamat'),
                        SizedBox(height: 16.h),
                        InputForm(
                          controller: _addressController,
                          hintText: 'Jl. Contoh Alamat No. 123',
                          svgIconPath: 'assets/icons/ic_account.svg',
                          backgroundColor: Colors.white,
                          validator: Validators.validatorName,
                          textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomeShadowCotainner(
          borderRadius: BorderRadius.circular(0),
          child: ButtonFill(
            text: _profileController.isUpdatingUserData.value ? 'Menyimpan...' : 'Simpan',
            textColor: Colors.white,
            isLoading: _profileController.isUpdatingUserData.value,
            onTap: _profileController.isUpdatingUserData.value
                ? null
                : () async {
                    await _handleSaveData();
                  },
          ),
        ),
      ),
    );
  }
}
