import '../models/porter_queue_model.dart';
import '../repositories/porter_queue_repository.dart';

class PorterQueueUsecase {
  final PorterQueueRepository _repository;

  PorterQueueUsecase(this._repository);

  Future<String> createPorterQueue(String userId, String locationPorter) {
    return _repository.createPorterQueue(userId, locationPorter);
  }

  Future<PorterQueueModel?> getPorterByUserId(String userId) {
    return _repository.getPorterByUserId(userId);
  }

  Future<void> deletePorterQueue(String porterId) {
    return _repository.deletePorterQueue(porterId);
  }

  // Sisi Porter
  Future<PorterQueueModel?> getNextAvailablePorter() {
    return _repository.getNextAvailablePorter();
  }

  Future<bool> assignPorterToUser(String porterId, String userId, String transactionId) {
    return _repository.assignPorterToUser(porterId, userId, transactionId);
  }

  Future<Map<String, String>> requestPorter({
    required String passengerId,
    required String ticketId,
    required String transactionId,
    required String locationPassenger,
  }) async {
    final porter = await _repository.getNextAvailablePorter();
    if (porter == null) throw Exception('Porter tidak tersedia');

    final porterId = porter.id!;
    final txId = DateTime.now().millisecondsSinceEpoch.toString();
    final locPorter = porter.locationPorter!;

    final ok = await _repository.assignPorterToUser(porterId, passengerId, txId);
    if (!ok) throw Exception('Gagal menugaskan porter');

    await _repository.createPorterTransaction(
      porterTransactionId: txId,
      porterId: porterId,
      passengerId: passengerId,
      transactionId: transactionId,
      ticketId: ticketId,
      locationPassenger: locationPassenger,
      locationPorter: locPorter,
    );

    return {
      'porterId': porterId,
      'transactionId': txId,
    };
  }

  Future<void> completePorterAssignment(String porterId) {
    return _repository.completePorterAssignment(porterId);
  }

  Future<PorterQueueModel?> getPorterById(String porterId) {
    return _repository.getPorterById(porterId);
  }

  Future<bool> checkConditionForPorter(String porterId) {
    return _repository.checkConditionForPorter(porterId);
  }

  Stream<PorterQueueModel?> watchPorterByUserId(String userId) {
    return _repository.watchPorterByUserId(userId);
  }
}
