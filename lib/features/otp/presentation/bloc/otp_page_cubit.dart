import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/use_case/use_case.dart';
import '../../../../core/utils/show_warning_toast.dart';
import '../../../auth/domain/usecases/verify_otp.dart';
import 'otp_page_cubit_state.dart';

class OtpPageCubit extends Cubit<OtpPageCubitState> {
  final VerifyOtp verifyOtp;

  OtpPageCubit(this.verifyOtp) : super(OtpPageCubitState());

  Future verfiySmsCode(VerifyOtpParams params) async {
    final response = await verifyOtp.call(params);

    if (response.isRight) {
    } else {
      showWarningToast(msg: response.left.message);
    }
  }
}
