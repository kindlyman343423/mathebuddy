/// mathe:buddy - a gamified learning-app for higher math
/// (c) 2022-2023 by TH Koeln
/// Author: Andreas Schwenk contact@compiler-construction.com
/// Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
/// License: GPL-3.0-or-later

import 'package:slex/slex.dart';

import '../../mbcl/src/level.dart';
import '../../mbcl/src/level_item.dart';

/// <GRAMMAR>
///   inlineMathCore =
///     { ( "@" ID | "@@" ID | <!"$"> ) };
/// </GRAMMAR>
MbclLevelItem parseInlineMath(
    MbclLevel level, Lexer lexer, MbclLevelItem? exercise) {
  if (lexer.isTerminal('\$')) lexer.next();
  var inlineMath = MbclLevelItem(level, MbclLevelItemType.inlineMath, -1);
  while (lexer.isNotTerminal('\$') && lexer.isNotEnd()) {
    var tk = lexer.getToken().token;
    var prefix = '';
    if (tk == '@' || tk == '@@') {
      prefix = lexer.getToken().token;
      lexer.next();
      tk = lexer.getToken().token;
    }
    var isId = lexer.getToken().type == LexerTokenType.id;
    lexer.next();
    // variable reference
    if (exercise != null) {
      if (isId &&
          (exercise.exerciseData as MbclExerciseData).variables.contains(tk)) {
        var v = MbclLevelItem(level, MbclLevelItemType.variableReference, -1);
        v.id = prefix + tk;
        inlineMath.items.add(v);
        continue;
      }
    }
    // default
    var text = MbclLevelItem(level, MbclLevelItemType.text, -1);
    text.text = tk;
    inlineMath.items.add(text);
  }
  if (lexer.isTerminal('\$')) lexer.next();
  return inlineMath;
}
