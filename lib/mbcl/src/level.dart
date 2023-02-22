/**
 * mathe:buddy - a gamified learning-app for higher math
 * (c) 2022-2023 by TH Koeln
 * Author: Andreas Schwenk contact@compiler-construction.com
 * Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
 * License: GPL-3.0-or-later
 */

// refer to the specification at https://mathebuddy.github.io/mathebuddy/ (TODO: update link!)

import 'level_item.dart';

abstract class MBCL_Level__ABSTRACT {
  String file_id =
      ''; // all references go here; label is only used for searching
  String title = '';
  String label = '';
  int pos_x = -1;
  int pos_y = -1;
  List<MBCL_Level__ABSTRACT> requires = [];
  List<String> requires_tmp = []; // only used while compiling
  List<MBCL_LevelItem__ABSTRACT> items = [];

  void postProcess();

  Map<String, dynamic> toJSON() {
    return {
      "fileId": this.file_id,
      "title": this.title,
      "label": this.label,
      "posX": this.pos_x,
      "posY": this.pos_y,
      "requires": this.requires.map((req) => req.file_id).toList(),
      "items": this.items.map((item) => item.toJSON()).toList(),
    };
  }

  fromJSON(Map<String, dynamic> src) {
    // TODO
  }
}
