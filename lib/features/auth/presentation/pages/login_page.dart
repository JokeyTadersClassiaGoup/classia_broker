import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/company_logo.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../../core/utils/invest_amount.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecases/sign_up.dart';
import 'bloc/auth_cubit.dart';
import 'bloc/auth_cubit_state.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  final TextEditingController phoneNumberController = TextEditingController();

  // @override
  // void dispose() {
  //   super.dispose();
  //   isOtpLoading.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AuthCubit(
        signUp: SignUp(
            authRepository: RepositoryProvider.of<AuthRepository>(context)),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: BlocBuilder<AuthCubit, AuthCubitState>(builder: (ct, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CompanyImage(),
                  ),
                  const Text(
                    "Login to Your Account",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xffE0FFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Text(
                      "Enter your Phone Number",
                      style: TextStyle(fontSize: 17, color: Colors.white70),
                    ),
                  ),
                  TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      prefix: const Text(
                        '+91 ',
                        style: TextStyle(color: Colors.white),
                      ),
                      counterText: '',
                      label: const Text('Phone number'),
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.9)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                  ),
                  Gap(heightScreen * 0.03),
                  ValueListenableBuilder(
                      valueListenable: isOtpLoading,
                      builder: (_, val, child) {
                        return isOtpLoading.value
                            ? const Loader()
                            : PrimaryLoadingButton(
                                onPressed: () async {
                                  // await Future.delayed(const Duration(seconds: 2));
                                  await ct.read<AuthCubit>().signUpUser(
                                        SignUpParams(
                                          phoneNumber:
                                              phoneNumberController.text.trim(),
                                          context: context,
                                          type: 'login',
                                        ),
                                      );
                                },
                                title: 'Get OTP',
                              );
                      }),
                  Gap(
                    heightScreen * 0.020,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                            // fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed(SignUpPage.routeName);
                        },
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                              color: Color(0xffFFDAB9),
                              // fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: heightScreen * 0.1,
                  // ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
