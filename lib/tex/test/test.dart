/**
 * mathe:buddy - a gamified learning-app for higher math
 * (c) 2022-2023 by TH Koeln
 * Author: Andreas Schwenk contact@compiler-construction.com
 * Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
 * License: GPL-3.0-or-later
 */

import 'dart:io';

import '../src/tex.dart';

void main() {
  var tex = new Tex();
  var src = "3x+y^2"; //"\\frac x{ \\sum_1^{{6}} w } \\cdot 5";
  var output = tex.tex2svg(src);
  print(output);
  File('lib/tex/test/svg/test.svg').writeAsStringSync(output);
}