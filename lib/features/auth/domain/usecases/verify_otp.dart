import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../repository/auth_repository.dart';

class VerifyOtp extends UseCase<bool, VerifyOtpParams> {
  final AuthRepository authRepository;
  VerifyOtp({required this.authRepository});
  @override
  Future<Either<Failures, bool>> call(VerifyOtpParams params) async {
    return await authRepository.verifyOtp(
      // userModel: params.userModel,
      context: params.context,
      verificationId: params.verificationId,
      smsCode: params.smsCode,
      // type: params.type,
    );
  }
}
