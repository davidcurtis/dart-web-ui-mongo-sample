import 'dart:html';
import 'package:web_components/web_components.dart';

class Choice extends WebComponent {
  inserted() {
    var input = this.query('input') as InputElement;
    var _name = _getIdFromMultipleChoice(this);
    input.name = _name;
  }
  
  _getIdFromMultipleChoice(Element elem) {
    if (elem.tagName != "X-MULTIPLE-CHOICE") {
      return _getIdFromMultipleChoice(elem.parent);
    } else {
      return elem.id;
    }
  }
}