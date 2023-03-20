/// mathe:buddy - a gamified app for higher math
/// (c) 2022-2023 by TH Koeln
/// Author: Andreas Schwenk contact@compiler-construction.com
/// Funded by: FREIRAUM 2022, Stiftung Innovation in der Hochschullehre
/// License: GPL-3.0-or-later

import 'package:mathebuddy/keyboard_layouts.dart';
import 'package:tex/tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mathebuddy/mbcl/src/level_item.dart';

import 'package:mathebuddy/color.dart';
import 'package:mathebuddy/help.dart';
import 'package:mathebuddy/main.dart';
import 'package:mathebuddy/screen.dart';

const double defaultFontSize = 16;

InlineSpan generateParagraphItem(CoursePageState state, MbclLevelItem item,
    {bold = false,
    italic = false,
    color = Colors.black,
    MbclExerciseData? exerciseData}) {
  switch (item.type) {
    case MbclLevelItemType.reference:
      {
        return TextSpan(
            text: "Warning: References are not yet implemented!",
            style: TextStyle(color: Colors.red));
      }
    case MbclLevelItemType.text:
      return TextSpan(
        text: "${item.text} ",
        style: TextStyle(
            color: color,
            fontSize: defaultFontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal),
      );
    case MbclLevelItemType.boldText:
    case MbclLevelItemType.italicText:
    case MbclLevelItemType.color:
      {
        List<InlineSpan> gen = [];
        switch (item.type) {
          case MbclLevelItemType.boldText:
            {
              for (var it in item.items) {
                gen.add(generateParagraphItem(state, it,
                    bold: true, exerciseData: exerciseData));
              }
              return TextSpan(children: gen);
            }
          case MbclLevelItemType.italicText:
            {
              for (var it in item.items) {
                gen.add(generateParagraphItem(state, it,
                    italic: true, exerciseData: exerciseData));
              }
              return TextSpan(
                children: gen,
              );
            }
          case MbclLevelItemType.color:
            {
              var colorKey = int.parse(item.id);
              var colors = [
                // TODO
                Colors.black,
                Colors.red,
                Colors.blue,
                Colors.purple,
                Colors.orange
              ];
              var color = colors[colorKey % colors.length];
              for (var it in item.items) {
                gen.add(generateParagraphItem(state, it,
                    color: color, exerciseData: exerciseData));
              }
              return TextSpan(children: gen);
            }
          default:
            // this will never happen
            return TextSpan();
        }
      }
    case MbclLevelItemType.inlineMath:
      {
        var texSrc = '';
        for (var subItem in item.items) {
          switch (subItem.type) {
            case MbclLevelItemType.text:
              {
                texSrc += subItem.text;
                break;
              }
            case MbclLevelItemType.variableReference:
              {
                var variableId = subItem.id;
                if (exerciseData == null) {
                  texSrc += 'ERROR: not in exercise mode!';
                } else {
                  var instance =
                      exerciseData.instances[exerciseData.runInstanceIdx];
                  var variableValue = instance[variableId];
                  if (variableValue == null) {
                    texSrc += 'ERROR: unknown exercise variable $variableId';
                  } else {
                    texSrc += convertMath2TeX(variableValue);
                  }
                }
                break;
              }
            default:
              print(
                  "ERROR: genParagraphItem(..): type '${item.type.name}' is not finally implemented");
          }
        }
        var tex = TeX();
        tex.scalingFactor = 1.17;
        //print("... tex src: $texSrc");
        var svg = tex.tex2svg(texSrc);
        var svgWidth = tex.width;
        if (texSrc.contains("\\sqrt") || svg.isEmpty) {
          return TextSpan(
            text: "${tex.error}. TEX-INPUT: $texSrc",
            style: TextStyle(color: Colors.red, fontSize: defaultFontSize),
          );
        } else {
          return WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                  padding: EdgeInsets.only(right: 4.0),
                  child: SvgPicture.string(
                    svg,
                    width: svgWidth.toDouble(),
                  )));
        }
      }
    case MbclLevelItemType.inputField:
      {
        // TODO: debug-show expected solution
        var inputFieldData = item.inputFieldData as MbclInputFieldData;
        if (exerciseData != null &&
            exerciseData.inputFields.containsKey(item.id) == false) {
          exerciseData.inputFields[item.id] = inputFieldData;
          inputFieldData.studentValue = "";
          var exerciseInstance =
              exerciseData.instances[exerciseData.runInstanceIdx];
          inputFieldData.expectedValue =
              exerciseInstance[inputFieldData.variableId] as String;
        }
        Widget contents;
        Color feedbackColor = getFeedbackColor(exerciseData?.feedback);
        if (inputFieldData.studentValue.isEmpty) {
          contents = RichText(
              text: TextSpan(children: [
            WidgetSpan(
                child: Icon(
              Icons.keyboard,
              size: 42,
              color: feedbackColor,
            )),
            WidgetSpan(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Text(' ${inputFieldData.expectedValue}  ',
                        style: TextStyle(
                            color: Colors.black, fontStyle: FontStyle.italic))))
          ]));
        } else {
          var tex = TeX();
          tex.scalingFactor = 1.5; //1.17;
          tex.setColor(
              feedbackColor.red, feedbackColor.green, feedbackColor.blue);
          var svg = tex.tex2svg(convertMath2TeX(inputFieldData.studentValue));
          var svgWidth = tex.width;
          if (svg.isEmpty) {
            contents = Text(
              "${tex.error} ",
              style: TextStyle(color: Colors.red, fontSize: defaultFontSize),
            );
          } else {
            // TODO: tex.setColor(...);
            contents = RichText(
                text: WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: SvgPicture.string(svg, width: svgWidth.toDouble())));
          }
          /*contents = Text(inputFieldData.studentValue,
              style:
                  TextStyle(color: matheBuddyRed, fontSize: defaultFontSize));*/
        }
        var key = exerciseKey;
        return WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
                onTap: () {
                  if (key != null) {
                    Scrollable.ensureVisible(key.currentContext!,
                        duration: Duration(milliseconds: 250));
                  }
                  if (state.keyboardState.layout != null) {
                    state.keyboardState.layout = null;
                  } else {
                    //scrollController?.jumpTo(10);

                    state.keyboardState.exerciseData = exerciseData;
                    state.keyboardState.inputFieldData = inputFieldData;
                    switch (inputFieldData.type) {
                      case MbclInputFieldType.int:
                        state.keyboardState.layout = keyboardLayoutInteger;
                        break;
                      case MbclInputFieldType.real:
                        state.keyboardState.layout = keyboardLayoutReal;
                        break;
                      case MbclInputFieldType.complexNormal:
                        state.keyboardState.layout =
                            keyboardLayoutComplexNormalForm;
                        break;
                      /*case MbclInputFieldType.choices:
                      //inputFieldData.choices
                      break;*/
                      default:
                        print("WARNING: generateParagraphItem():"
                            "keyboard layout for input field type"
                            " ${inputFieldData.type.name} not yet implemented");
                        state.keyboardState.layout = keyboardLayoutTerm;
                    }
                  }
                  // ignore: invalid_use_of_protected_member
                  state.setState(() {});
                },
                child: contents));
      }
    default:
      {
        print(
            "ERROR: genParagraphItem(..): type '${item.type.name}' is not implemented");
        return TextSpan(
            text: "ERROR: genParagraphItem(..): "
                "type '${item.type.name}' is not implemented",
            style: TextStyle(color: Colors.red));
      }
  }
}
