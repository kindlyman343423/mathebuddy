/**
 * mathe:buddy - a gamified learning-app for higher math
 * (c) 2022-2023 by TH Koeln
 * Author: Andreas Schwenk contact@compiler-construction.com
 * Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
 * License: GPL-3.0-or-later
 */

import 'dataBlock.dart';

// refer to the specification at https://app.f07-its.fh-koeln.de/docs-mbcl.html

// -------- DEFINITION --------

enum MBL_DefinitionType {
  Definition,
  Theorem,
  Lemma,
  Corollary,
  Proposition ,
  Conjecture,
  Axiom ,
  Claim ,
  Identity,
  Paradox,
}

class MBL_Definition extends MBL_BlockItem {
  MBL_DefinitionType type;
  items: (MBL_Equation | MBL_Text)[] = [];
  
  MBL_Definition(this.type);
  
  void postProcess() {
    for(var i=0; i<this.items.length; i++) {
      var item = this.items[i];
      item.postProcess();
    }
  }
  
  Map<String,Object> toJSON() {
    return {
      "type": this.type,
      "title": this.title,
      "label": this.label,
      "error": this.error,
      "items": this.items.map((item) => item.toJSON()),
    };
  }
}