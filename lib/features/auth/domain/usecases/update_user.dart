
import 'package:either_dart/src/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

class UpdateUser extends UseCase<bool, UserModel> {
  final AuthRepository authRepository;

  UpdateUser({required this.authRepository});
  @override
  Future<Either<Failures, bool>> call(UserModel params) {
    return authRepository.updateUser(params);
  }
}
