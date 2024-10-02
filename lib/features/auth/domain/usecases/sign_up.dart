import 'package:either_dart/src/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../repository/auth_repository.dart';

class SignUp extends UseCase<bool, SignUpParams> {
  final AuthRepository authRepository;

  SignUp({required this.authRepository});

  @override
  Future<Either<Failures, bool>> call(SignUpParams params) async {
    return await authRepository.signUpWithPhone(
      params: params,
      context: params.context,
      type: params.type,
    );
  }
}
