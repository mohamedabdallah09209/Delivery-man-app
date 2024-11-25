import 'package:app_delivary_task/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:app_delivary_task/features/order/domain/models/order_model.dart';
import 'package:app_delivary_task/helper/price_converter_helper.dart';
import 'package:app_delivary_task/localization/language_constrants.dart';
import 'package:app_delivary_task/features/auth/providers/auth_provider.dart';
import 'package:app_delivary_task/features/order/providers/order_provider.dart';
import 'package:app_delivary_task/features/order/providers/tracker_provider.dart';
import 'package:app_delivary_task/utill/dimensions.dart';
import 'package:app_delivary_task/utill/images.dart';
import 'package:app_delivary_task/commons/widgets/custom_button_widget.dart';
import 'package:app_delivary_task/features/order/screens/order_details_screen.dart';
import 'package:app_delivary_task/features/order/screens/order_complete_screen.dart';
import 'package:provider/provider.dart';

class DeliveryDialogWidget extends StatelessWidget {
  final Function onTap;
  final OrderModel? orderModel;

  final double? totalPrice;

  const DeliveryDialogWidget({Key? key, required this.onTap, this.totalPrice, this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.2)),
        child: Stack(
          clipBehavior: Clip.none, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(Images.money),
              const SizedBox(height: 20),
              Center(
                  child: Text(
                    getTranslated('do_you_collect_money', context)!,
                    style: rubikRegular,
                  )),
              const SizedBox(height: 20),
              Center(
                  child: Text(
                    PriceConverterHelper.convertPrice(context, totalPrice),
                    style: rubikMedium.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: CustomButtonWidget(
                        btnTxt: getTranslated('no', context),
                        isShowBorder: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModelItem: orderModel,)));
                        },
                      )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(
                      child: Consumer<OrderProvider>(
                        builder: (context, order, child) {
                          return !order.isLoading ? CustomButtonWidget(
                            btnTxt: getTranslated('yes', context),
                            onTap: () {
                              Provider.of<TrackerProvider>(context, listen: false).updateTrackStart(false);
                              Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(
                                  token: Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                  orderId: orderModel!.id,
                                  status: 'delivered').then((value) {
                                if (value.isSuccess) {
                                  order.updatePaymentStatus(
                                      // ignore: use_build_context_synchronously
                                      token: Provider.of<AuthProvider>(context, listen: false).getUserToken(), orderId: orderModel!.id, status: 'paid');
                                  // ignore: use_build_context_synchronously
                                  Provider.of<OrderProvider>(context, listen: false).getAllOrders();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(builder: (_) => OrderCompleteScreen(orderID: orderModel!.id.toString())));
                                }
                              });
                            },
                          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                        },
                      )),
                ],
              ),
            ],
          ),
          Positioned(
            right: -20,
            top: -20,
            child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.clear, size: Dimensions.paddingSizeLarge),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModelItem: orderModel)));
                }),
          ),
        ],
        ),
      ),
    );
  }
}

