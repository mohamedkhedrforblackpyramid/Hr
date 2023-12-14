import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';



class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 64,
        width: 260,
        child: Stack(children: [
          RiveAnimation.asset(
            "assets/RiveAssets/button.riv",
            controllers: [_btnAnimationController],
          ),
           Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppLocalizations.of(context)!.localeName == 'ar' ? CupertinoIcons.arrow_right : CupertinoIcons.arrow_left),
                  SizedBox(
                    width: 8,
                  ),
                  Text(AppLocalizations.of(context)!.startNow,
                      style: TextStyle(fontWeight: FontWeight.w600))
                ],
              )),
        ]),
      ),
    );
  }
}
