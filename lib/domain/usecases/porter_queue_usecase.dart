import '../models/porter_queue_model.dart';
import '../repositories/porter_queue_repository.dart';

class PorterQueueUsecase {
  final PorterQueueRepository _repository;

  PorterQueueUsecase(this._repository);

  Future<String> createPorterQueue(String userId) {
    return _repository.createPorterQueue(userId);
  }

  Future<PorterQueueModel?> getPorterByUserId(String userId) {
    return _repository.getPorterByUserId(userId);
  }

  Future<void> deletePorterQueue(String porterId) {
    return _repository.deletePorterQueue(porterId);
  }
}
