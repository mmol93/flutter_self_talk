import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getAnnounceIcon() => Transform(
  alignment: Alignment.center,
  transform: Matrix4.rotationY(math.pi),
  child: SvgPicture.asset(
    'assets/images/announcement.svg',
    height: 24,
    colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
  ),
);