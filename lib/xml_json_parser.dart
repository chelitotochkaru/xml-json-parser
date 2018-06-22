library xml_json_parser;
import 'package:xml/xml.dart' as Xml;

class XmlJsonParser {
  static dynamic _convertNode(node) {
    if (node is Xml.XmlElement) {
      if (node.children.length > 1) {
        var child = [];
        int counter = 0;
        while(counter < node.children.length) {
          final Xml.XmlNode currentNode = node.children[counter];
          child.add(_convertNode(currentNode));
          counter++;
        }
        return { node.name.toString(): child };
      } else {
        return {
          node.name.toString(): _convertNode(node.children[0])
        };
      }
    }
    return "'${node.text}'";
  }

  static List<dynamic> transform(String xmlString) {
    //xml = xml.replaceAll(new RegExp(r'env:|ns1:|rpc:'), '');
    final Xml.XmlDocument document = Xml.parse(xmlString);
    final json = [];
    json.add(_convertNode(document.children.where((node) => node is Xml.XmlElement).first));
    return json;
  }
}
