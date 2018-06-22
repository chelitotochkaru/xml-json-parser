library xml_json_parser;

import 'dart:convert';

import 'package:xml/xml.dart' as Xml;

class XmlJsonParser {
  static String _convertNode(node) {
    if (node is Xml.XmlElement) {
      if (node.children.length > 1) {
        List<String> child = new List<String>();
        int counter = 0;
        while (counter < node.children.length) {
          Xml.XmlNode currentNode = node.children[counter];
          child.add(_convertNode(currentNode));
          counter++;
        }
        return '{"${node.name.toString()}": [${child.join(', ')}]}';
      } else {
        return '{"${node.name.toString()}": ${_convertNode(node.children[0])}}';
      }
    }
    return '"${node.text}"';
  }

  static Map<String, dynamic> transform(String xmlString) {
    //xmlString = xmlString.replaceAll(new RegExp(r'env:|ns1:|rpc:'), '');
    Xml.XmlDocument document = Xml.parse(xmlString);
    final String jsonString = _convertNode(document.children.where((node) => node is Xml.XmlElement).first);
    return json.decode(jsonString);
  }
}
