import 'package:app_delivary_task/localization/language_constrants.dart';
import 'package:app_delivary_task/features/auth/providers/auth_provider.dart';
import 'package:app_delivary_task/utill/dimensions.dart';
import 'package:app_delivary_task/utill/styles.dart';
import 'package:app_delivary_task/helper/custom_snackbar_helper.dart';
import 'package:app_delivary_task/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignOutConfirmationDialogWidget extends StatelessWidget {
  const SignOutConfirmationDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).cardColor,
              child: Icon(Icons.contact_support, size: 50, color: Theme.of(context).textTheme.bodyLarge?.color,),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Text(getTranslated('want_to_sign_out', context)!, style: rubikRegular, textAlign: TextAlign.center),
            ),

            Divider(height: 0, color: Theme.of(context).hintColor),

            !authProvider.isLoading ? Row(children: [

              Expanded(child: InkWell(
                onTap: () {
                  authProvider.updateToken(token: '@').then((value){
                    authProvider.clearSharedData().then((condition) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showCustomSnackBar(getTranslated('logout_successfully', context)!, isError: false);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                    });
                  });

                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('yes', context)!, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                  ),
                  child: Text(getTranslated('no', context)!, style: rubikBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) : Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            ),
          ]);
        }),
      ),
    );
  }
}