import '../models/porter_queue_model.dart';

abstract class PorterQueueRepository {
  Future<String> createPorterQueue(String userId, String locationPorter);
  Future<PorterQueueModel?> getPorterByUserId(String userId);
  Future<void> deletePorterQueue(String porterId);

  // Sisi Porter
  Future<PorterQueueModel?> getNextAvailablePorter();
  Future<bool> assignPorterToUser(String porterId, String userId, String transactionId);
  Future<void> createPorterTransaction(
      {required String porterTransactionId,
      required String porterId,
      required String passengerId,
      required String transactionId,
      required String ticketId,
      required String locationPassenger,
      required String locationPorter});

  // Future<List<String>> getPorterTransactionIds(String porterId);
  // Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId);

  Future<void> completePorterAssignment(String porterId);
  Future<PorterQueueModel?> getPorterById(String porterId);
  Future<bool> checkConditionForPorter(String porterId);
  Stream<PorterQueueModel?> watchPorterByUserId(String userId);
}
