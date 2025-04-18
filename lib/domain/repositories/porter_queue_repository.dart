import '../models/porter_queue_model.dart';

abstract class PorterQueueRepository {
  Future<String> createPorterQueue(String userId);
  Future<PorterQueueModel?> getPorterByUserId(String userId);
  Future<void> deletePorterQueue(String porterId);
}