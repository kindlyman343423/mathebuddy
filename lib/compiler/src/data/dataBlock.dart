/**
 * mathe:buddy - a gamified learning-app for higher math
 * (c) 2022-2023 by TH Koeln
 * Author: Andreas Schwenk contact@compiler-construction.com
 * Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
 * License: GPL-3.0-or-later
 */

import 'dataLevel.dart';

// refer to the specification at https://app.f07-its.fh-koeln.de/docs-mbcl.html

// -------- BLOCK ITEM --------

abstract class MBL_BlockItem extends MBL_LevelItem {
  //String type;
  String title = '';
  String label = '';
  String error = '';
}