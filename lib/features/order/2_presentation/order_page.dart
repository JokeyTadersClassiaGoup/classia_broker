import 'package:classia_broker/features/order/1_domian/entity/order_page_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/show_warning_toast.dart';
import '../1_domian/entity/order.dart';
import '../1_domian/repository/order_repository.dart';
import '../1_domian/use_cases/place_order.dart';
import '../widgets/product_item.dart';
import 'bloc/order_page_cubit.dart';

class OrderPageProvider extends StatelessWidget {
  static const routeName = 'order-page';
  final OrderPageArgs orderPageArgs;
  const OrderPageProvider({super.key, required this.orderPageArgs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderPageCubit(
        placeOrder: PlaceOrder(
          orderRepository: RepositoryProvider.of<OrderRepository>(context),
        ),
      ),
      child: OrderPage(orderPageArgs: orderPageArgs),
    );
  }
}

class OrderPage extends StatefulWidget {
  final OrderPageArgs orderPageArgs;

  const OrderPage({
    super.key,
    required this.orderPageArgs,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  ValueNotifier<double> totalValue = ValueNotifier(0.0);
  ValueNotifier<bool> isDelivery = ValueNotifier(true);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    totalValue.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = widget.orderPageArgs;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 10.0,
          title: Text(
            args.title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '\u{20B9} ${args.lastTradedPrice}',
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            ValueListenableBuilder(
                valueListenable: isDelivery,
                builder: (_, val, child) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProductItem(
                        onPressed: () => isDelivery.value = true,
                        label: 'Delivery',
                        bgColor: isDelivery.value
                            ? AppColors.goldColor
                            : AppColors.secondaryColor,
                        textColor:
                            isDelivery.value ? Colors.black : Colors.white,
                        fontWeight: isDelivery.value
                            ? FontWeight.w600
                            : FontWeight.w500,
                        border: isDelivery.value ? false : true,
                      ),
                      const Gap(15),
                      ProductItem(
                        onPressed: () => isDelivery.value = false,
                        label: 'Intraday',
                        bgColor: isDelivery.value
                            ? AppColors.secondaryColor
                            : AppColors.goldColor,
                        textColor:
                            isDelivery.value ? Colors.white : Colors.black,
                        fontWeight: isDelivery.value
                            ? FontWeight.w500
                            : FontWeight.w600,
                        border: isDelivery.value ? true : false,
                      ),
                    ],
                  );
                }),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Quantity',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    onTap: () {
                      totalValue.value = args.lastTradedPrice;
                    },
                    controller: quantityController,
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      filled: true,
                      fillColor: Colors.black12,
                      constraints: const BoxConstraints(
                        maxWidth: 120,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '1.0',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 20,
                      ),
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        var parsedValue = double.parse(quantityController.text);
                        totalValue.value = parsedValue * args.lastTradedPrice;
                        //   if (totalValue.value > widget.availableBalance) {
                        //     canPlace.value = false;
                        //     showWarningToast(
                        //         msg: 'Available balance is not enough');
                        //   }
                        // } else {
                        // totalValue.value = args.lastTradedPrice;
                      }
                    },
                  ),
                ),
              ],
            ),
            const Gap(10),

            // const Gap(30),
            // Divider(),
            const Spacer(),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            ValueListenableBuilder(
              valueListenable: totalValue,
              builder: (context, _, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Total Price',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        )),
                    Text(
                      '\u{20B9} ${totalValue.value.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: AppColors.goldColor,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (_, val, child) {
                return ElevatedButton(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          if (quantityController.text.isEmpty) {
                            showWarningToast(
                                msg: 'To place order min quantity should be 1');
                          } else {
                            isLoading.value = true;
                            Order orderToPlace = Order(
                              quantity: int.parse(quantityController.text),
                              product: isDelivery.value ? 'D' : 'I',
                              validity: 'DAY',
                              price: 0,
                              tag: '',
                              instrumentToken: args.instrumentKey,
                              orderType: 'MARKET',
                              transactionType: args.orderType ? 'BUY' : 'SELL',
                              disclosedQuantity: 0,
                              triggerPrice: 0,
                              isAmo: false,
                            );
                            await context.read<OrderPageCubit>().createOrder(
                                  order: orderToPlace,
                                  accessToken: args.accessToken,
                                );
                            isLoading.value = false;
                          }
                        },
                  child: isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Place Order'),
                );
              }),
        ),
      ),
    );
  }
}
