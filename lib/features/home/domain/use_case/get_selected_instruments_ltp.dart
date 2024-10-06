import 'package:classia_broker/features/home/domain/repository/home_repository.dart';
import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class GetSelectedInstrumentsLtp extends UseCase<int, String> {
  final HomeRepository repository;

  GetSelectedInstrumentsLtp({required this.repository});

  @override
  Future<Either<Failures, int>> call(String params) async {
    return await repository.getSelectedInstrumentLtp(params);
  }
}
