import 'package:flutter/material.dart';

ValueNotifier<int> investmentQuantity = ValueNotifier(0);
ValueNotifier<int> investedAmount = ValueNotifier(0);

ValueNotifier<double> liveValue = ValueNotifier(0.0);


ValueNotifier<bool> isOtpLoading = ValueNotifier(false);