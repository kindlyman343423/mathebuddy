/**
 * mathe:buddy - a gamified learning-app for higher math
 * (c) 2022-2023 by TH Koeln
 * Author: Andreas Schwenk contact@compiler-construction.com
 * Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
 * License: GPL-3.0-or-later
 */

import 'dataLevel.dart';

// refer to the specification at https://app.f07-its.fh-koeln.de/docs-mbcl.html

// -------- EQUATION --------

enum MBL_EquationOption {
  AlignLeft,
  AlignCenter,
  AlignRight,
  AlignEquals,
}

class MBL_Equation extends MBL_LevelItem {
  String value = '';
  int numbering = -1;
  List<MBL_EquationOption> options = [];

  MBL_Equation() : super(MBL_LevelItemType.Equation);

  void postProcess() {
    // TODO
  }

  Map<String, Object> toJSON() {
    return {
      "type": this.type,
      "title": this.title,
      "label": this.label,
      "error": this.error,
      "value": this.value,
      "numbering": this.numbering,
      "options": this.options.map((option) => option.toString()),
    };
  }
}
