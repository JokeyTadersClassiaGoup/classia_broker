import 'package:classia_broker/core/error/failures.dart';
import 'package:classia_broker/core/use_case/use_case.dart';
import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:either_dart/src/either.dart';

import '../model/broker_model.dart';

class GetBrokerById extends UseCase<BrokerModel, GetBrokerIdParams> {
  final HomeRepository homeRepository;

  GetBrokerById({required this.homeRepository});
  @override
  Future<Either<Failures, BrokerModel>> call(GetBrokerIdParams params) async {
    return await homeRepository.getBrokerById(params.uId, params.accessToken);
  }
}
