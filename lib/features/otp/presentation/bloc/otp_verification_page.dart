import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/use_case/use_case.dart';
import '../../../auth/domain/models/user_model.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../auth/domain/usecases/verify_otp.dart';
import 'otp_page_cubit.dart';
import 'otp_page_cubit_state.dart';

// class OtpVerificationPageProvider extends StatelessWidget {
//   static const routeName = '/otp-verification-page';

//   final String verificationId;

//   const OtpVerificationPageProvider({super.key, required this.verificationId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => OtpPageCubit(
//         verifyOtp: VerifyOtp(
//           firebaseRemoteDataSourceInterface: RepositoryProvider.of(context),
//         ),
//       ),
//       child: OtpVerificationPage(
//         verificationId: verificationId,
//       ),
//     );
//   }
// }

class OtpVerificationPage extends StatelessWidget {
  static const routeName = 'otp-verification-page';
  final String verificationId;
  final UserModel? userModel;
  final String type;
  OtpVerificationPage({
    super.key,
    required this.verificationId,
    this.userModel,
    required this.type,
  });

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => OtpPageCubit(
        VerifyOtp(
            authRepository: RepositoryProvider.of<AuthRepository>(context)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phone Verification'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: BlocBuilder<OtpPageCubit, OtpPageCubitState>(
              builder: (ct, state) {
            return Column(
              children: [
                const Text(
                  "Enter 6 digit verification code sent to your phone number",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Gap(heightScreen * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: heightScreen * 0.03),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    animationType: AnimationType.fade,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: Colors.white),
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.0),
                      fieldHeight: 50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      activeColor: Colors.blue,
                      // selectedColor: Colors.blue,
                      inactiveColor: Colors.grey,
                    ),
                    onCompleted: (val) async {
                      isLoading.value = true;
                      await ct.read<OtpPageCubit>().verifySmsCode(
                            VerifyOtpParams(
                              userModel: userModel,
                              smsCode: val,
                              context: context,
                              verificationId: verificationId,
                              type: type,
                            ),
                          );
                      isLoading.value = false;
                    },
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, notifier, child) {
                      return isLoading.value
                          ? const CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            )
                          : SizedBox();

                      //  TextButton(
                      //     onPressed: () {
                      //       showToast('OTP sent successfully',
                      //           position: ToastPosition.bottom,
                      //           radius: 30,
                      //           textPadding: const EdgeInsets.symmetric(
                      //               horizontal: 16, vertical: 10),
                      //           textStyle: GoogleFonts.poppins(
                      //               fontSize: 16, color: Colors.white));
                      //     },
                      //     child: const Text(
                      //       "Resend OTP",
                      //       style: TextStyle(
                      //           color: Color(0xffFFDAB9),
                      //           fontSize: 15,
                      //           fontWeight: FontWeight.w600),
                      //     ),
                      //   );
                    }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
