import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void showTutorial(BuildContext context, List<TargetFocus> targets) {
  TutorialCoachMark(
    targets: targets, // List<TargetFocus>
    colorShadow: Colors.red, // DEFAULT Colors.black
    onClickTarget: (target) {},
    onClickTargetWithTapPosition: (target, tapDetails) {},
    onClickOverlay: (target) {},
    onSkip: () {
      return false;
    },
    onFinish: () {},
    hideSkip: true,
  ).show(context: context);
}
