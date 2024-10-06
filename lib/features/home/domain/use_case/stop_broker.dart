import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/core/use_case/use_case.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:either_dart/src/either.dart';

class StopBroker extends UseCase<bool, String> {
  final HomeRepository homeRepository;

  StopBroker({required this.homeRepository});
  @override
  Future<Either<Failures, bool>> call(String params) async {
    return await homeRepository.stopBroker(params);
  }
}
