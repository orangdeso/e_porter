import 'dart:io';

import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/_core/constants/typography.dart';
import 'package:e_porter/_core/service/permission_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../_core/component/appbar/appbar_component.dart';
import '../../../../_core/component/button/button_fill.dart';
import '../../../../_core/component/card/custome_shadow_cotainner.dart';
import '../../../../_core/service/preferences_service.dart';
import '../../../../domain/models/upload_file_model.dart';
import '../../../controllers/transaction_controller.dart';
import '../../routes/app_rountes.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  final List<UploadFileModel> uploadedFiles = [];
  final TransactionController _transactionController = Get.find<TransactionController>();
  bool isUploading = false;

  late String ticketId;
  late String transactionId;
  late String userId = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    ticketId = args['ticketId'] ?? '';
    transactionId = args['transactionId'] ?? '';

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await PreferencesService.getUserData();
    if (userData != null) {
      setState(() {
        userId = userData.uid;
      });
    }
  }

  void _uploadToServer() async {
    try {
      // Validasi data transaksi
      if (ticketId.isEmpty || transactionId.isEmpty || userId.isEmpty) {
        Get.snackbar(
          'Error',
          'Data transaksi tidak lengkap',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (uploadedFiles.isEmpty || uploadedFiles.first.status != FileUploadStatus.completed) {
        Get.snackbar(
          'Error',
          'Silakan pilih dan selesaikan proses file terlebih dahulu',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      setState(() {
        isUploading = true;
      });

      Get.snackbar(
        'Info',
        'Mengupload bukti pembayaran...',
        backgroundColor: PrimaryColors.primary600,
        colorText: Colors.white,
      );

      final fileToUpload = uploadedFiles.first;
      final File proofImage = File(fileToUpload.filePath);

      await _transactionController.uploadPaymentProof(
        ticketId: ticketId,
        transactionId: transactionId,
        proofImage: proofImage,
        userId: userId,
      );

      Get.snackbar(
        'Sukses',
        'Bukti pembayaran berhasil diupload',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.NAVBAR);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupload bukti pembayaran: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColors.gray50,
      appBar: DefaultAppbarComponent(
        title: 'Upload Bukti Pembayaran',
        textColor: Colors.white,
        backgroundColors: PrimaryColors.primary800,
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: PrimaryColors.primary50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(width: 1.w, color: PrimaryColors.primary800),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/icons/ic_upload.svg', width: 32.w, height: 32.h),
                      SizedBox(height: 8.h),
                      TypographyStyles.body('Upload Bukti Pembayaran disini', color: GrayColors.gray800),
                      SizedBox(height: 16.h),
                      ZoomTapAnimation(
                        child: GestureDetector(
                          onTap: () => _pickFile(),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: GrayColors.gray300,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TypographyStyles.caption('Pilih File', color: GrayColors.gray800),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                TypographyStyles.small(
                  'Silahkan upload bukti pembayaran anda disini',
                  color: GrayColors.gray500,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 32.h),
                TypographyStyles.body('Upload File', color: GrayColors.gray800),
                SizedBox(height: 16.h),
                Column(
                  children: uploadedFiles.isEmpty
                      ? [_buildEmptyState()]
                      : uploadedFiles.map((file) => _buildFileItem(file)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomeShadowCotainner(
        child: ButtonFill(
          text: 'Upload',
          textColor: Colors.white,
          onTap: () {
            if (uploadedFiles.isNotEmpty) {
              _submitFiles();
            } else {
              Get.snackbar(
                'Peringatan',
                'Silahkan pilih file terlebih dahulu',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 100.h,
      width: double.infinity,
      alignment: Alignment.center,
      child: TypographyStyles.caption(
        'Belum ada file yang dipilih',
        color: GrayColors.gray500,
      ),
    );
  }

  Widget _buildFileItem(UploadFileModel file) {
    IconData fileIcon;

    if (file.fileName.toLowerCase().endsWith('.zip')) {
      fileIcon = Icons.folder_zip_outlined;
    } else if (file.fileName.toLowerCase().endsWith('.jpg') ||
        file.fileName.toLowerCase().endsWith('.jpeg') ||
        file.fileName.toLowerCase().endsWith('.png')) {
      fileIcon = Icons.image_outlined;
    } else if (file.fileName.toLowerCase().endsWith('.mp4') || file.fileName.toLowerCase().endsWith('.mov')) {
      fileIcon = Icons.video_file_outlined;
    } else {
      fileIcon = Icons.insert_drive_file_outlined;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(fileIcon, size: 24.r, color: GrayColors.gray700),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypographyStyles.small(file.fileName, color: GrayColors.gray800, fontWeight: FontWeight.w500),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        TypographyStyles.caption(
                          '${(file.fileSize / (1024 * 1024)).toStringAsFixed(1)} mb',
                          color: file.status == FileUploadStatus.failed ? Colors.red : GrayColors.gray600,
                          fontWeight: FontWeight.w400,
                        ),
                        if (file.status == FileUploadStatus.uploading)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: TypographyStyles.caption(
                              '| ${file.progress}% - ${file.remainingTime} sec left',
                              color: GrayColors.gray600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        if (file.status == FileUploadStatus.failed)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: TypographyStyles.caption(
                              'Upload failed',
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (file.status == FileUploadStatus.failed)
                    IconButton(
                      icon: Icon(Icons.refresh, size: 20.r, color: GrayColors.gray600),
                      onPressed: () => _retryUpload(file),
                    ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 20.r, color: GrayColors.gray600),
                    onPressed: () => _removeFile(file),
                  ),
                ],
              ),
            ],
          ),
          if (file.status == FileUploadStatus.uploading) ...[
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: file.progress / 100,
              backgroundColor: GrayColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(PrimaryColors.primary600),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    bool permissionGranted = await PermissionHelper.requestStoragePermission();
    if (!permissionGranted) {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to select files.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        final file = result.files.first;
        final newFile = UploadFileModel(
          fileName: file.name,
          filePath: file.path!,
          fileSize: file.size,
          progress: 0,
          remainingTime: '0',
          status: FileUploadStatus.pending,
        );

        setState(() {
          uploadedFiles.add(newFile);
        });

        // Simulasikan proses loading lokal
        _simulateLocalLoading(newFile);
      }
    } catch (e) {
      print('Error picking file: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memilih file',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _simulateLocalLoading(UploadFileModel file) {
    setState(() {
      file.status = FileUploadStatus.uploading;
    });

    // Simulate progressing upload - in a real app this would be actual file reading/processing
    int progress = 0;
    Future.doWhile(() async {
      if (progress >= 100) return false;

      await Future.delayed(Duration(milliseconds: 100));
      progress += 5;

      if (mounted) {
        setState(() {
          file.progress = progress.toDouble();
          file.remainingTime = ((100 - progress) ~/ 10).toString();
        });
      }

      return progress < 100 && file.status == FileUploadStatus.uploading;
    }).then((_) {
      if (mounted && file.status == FileUploadStatus.uploading) {
        setState(() {
          // Simulate some files failing to upload for demonstration
          if (file.fileName.contains('Icon-Set')) {
            file.status = FileUploadStatus.failed;
          } else {
            file.status = FileUploadStatus.completed;
          }
        });
      }
    });
  }

  void _retryUpload(UploadFileModel file) {
    setState(() {
      file.progress = 0;
      file.remainingTime = '0';
    });
    _simulateLocalLoading(file);
  }

  void _removeFile(UploadFileModel file) {
    setState(() {
      uploadedFiles.remove(file);
    });
  }

  void _submitFiles() {
    // Check if all files are uploaded successfully
    bool allCompleted = uploadedFiles.every((file) => file.status == FileUploadStatus.completed);

    if (!allCompleted) {
      Get.dialog(
        AlertDialog(
          title: Text('Peringatan'),
          content: Text('Beberapa file belum selesai diupload. Apakah Anda ingin melanjutkan?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                _uploadToServer();
              },
              child: Text('Lanjutkan'),
            ),
          ],
        ),
      );
    } else {
      _uploadToServer();
    }
  }
}
