import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/core/use_case/use_case.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:either_dart/src/either.dart';

class ActivateBroker extends UseCase<bool, ActivateBrokerParams> {
  final HomeRepository homeRepository;

  ActivateBroker({required this.homeRepository});
  @override
  Future<Either<Failures, bool>> call(ActivateBrokerParams params) async {
    return await homeRepository.activateBroker(params.activityModel);
  }
}
