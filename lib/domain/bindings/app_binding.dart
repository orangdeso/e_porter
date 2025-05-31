import 'package:e_porter/domain/bindings/auth_binding.dart';
import 'package:e_porter/domain/bindings/navigation_binding.dart';
import 'package:e_porter/presentation/screens/boarding_pass/provider/porter_service_provider.dart';
import 'package:e_porter/presentation/widgets/animations/animation_configs.dart';
import 'package:get/get.dart';
import 'package:e_porter/data/repositories/transaction_repository_impl.dart';
import 'package:e_porter/_core/service/transaction_expiry_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    _initCoreBindings();
    _initServices();
    _configureGlobalTransitions();
  }

  void _initCoreBindings() {
    AuthBinding().dependencies();
    MainNavigationBinding().dependencies();
  }

  void _initServices() {
    Get.put<TransactionRepositoryImpl>(TransactionRepositoryImpl(), permanent: true);

    final repository = Get.find<TransactionRepositoryImpl>();
    TransactionExpiryService().initialize(repository);

    PorterServiceProvider.registerDependencies();
    PorterServiceProvider.initServices();
  }

  void _configureGlobalTransitions() {
    Get.config(
      defaultTransition: Transition.fadeIn,
      defaultDurationTransition: AnimationConfigs.sharedAxisDuration,
    );
  }
}
