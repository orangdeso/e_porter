import 'package:flutter/material.dart';
import 'package:e_porter/_core/constants/colors.dart';
import 'package:e_porter/domain/models/transaction_porter_model.dart';

class PorterTransactionHelper {
  /// Filter transaksi berdasarkan status dan ID porter
  static List<PorterTransactionModel> filterByStatus(
    List<PorterTransactionModel> transactions,
    String statusFilter,
    String currentPorterId, 
  ) {
    return transactions.where((tx) {
      // Pastikan hanya menampilkan transaksi untuk porter saat ini
      if (tx.porterUserId != currentPorterId) {
        return false;
      }

      // Cek apakah memiliki info penolakan atau penugasan ulang
      final hasRejectionInfo = tx.rejectionInfo != null;
      // final hasReassignmentInfo = tx.reassignmentInfo != null;
      
      // Filter berdasarkan status
      switch (statusFilter.toLowerCase()) {
        case 'pending':
          return tx.normalizedStatus == 'pending' && !hasRejectionInfo;
        case 'proses':
          return tx.normalizedStatus == 'proses';
        case 'selesai':
          return tx.normalizedStatus == 'selesai';
        case 'rejected':
          return hasRejectionInfo || tx.normalizedStatus == 'rejected';
        default:
          return tx.normalizedStatus == statusFilter.toLowerCase();
      }
    }).toList();
  }

  /// Mendapatkan warna status untuk UI
  static Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'proses':
        return PrimaryColors.primary800;
      case 'selesai':
        return Colors.green;
      case 'rejected':
        return RedColors.red500;
      default:
        return GrayColors.gray400;
    }
  }

  /// Mendapatkan ikon status untuk UI
  static IconData getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'proses':
        return Icons.directions_run;
      case 'selesai':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }
}