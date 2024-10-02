import 'package:either_dart/src/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

class GetUser extends UseCase<UserModel, String> {
  final AuthRepository authRepository;

  GetUser({required this.authRepository});
  @override
  Future<Either<Failures, UserModel>> call(String params) async {
    return await authRepository.getUser(params);
  }
}
