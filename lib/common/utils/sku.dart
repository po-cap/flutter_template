

import 'package:template/common/models/item_model/sku.dart';

class Node {
  
  final String value;
  final Map<String,String> specs;
  List<Node> children = [];

  Node({
    required this.value, 
    required this.specs
  });

  factory Node.root() => Node(value: '', specs: {});
}

extension NodeExtension on Node {
  
  List<Node> addChildren(
    MapEntry<String, List<String>> attribute
  ) {
    for(var value in attribute.value) {
      children.add(
        Node(
          value: this.value.isEmpty ? value : "${this.value},$value",
          specs: specs..addAll({
            attribute.key: value
          })
        )
      );
    }
    return children;
  }


  /// 查找叶子节点
  List<Node> findLeafNodes() {
    final leafNodes = <Node>[];
    final stack = <Node>[this];
    
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      
      if (current.children.isEmpty) {
        leafNodes.add(current);
      } else {
        // 将子节点按逆序加入栈中（保持遍历顺序）
        for (var i = current.children.length - 1; i >= 0; i--) {
          stack.add(current.children[i]);
        }
      }
    }
    return leafNodes;
  }

  SkuModel toSku() {
    return SkuModel(
      id: 0, 
      name: value, 
      specs: specs, 
      photo: '', 
      price: 0, 
      quantity: 0
    );
  }

}


class SkuUtil {

  static List<SkuModel> toSkus(Map<String,List<String>> attributes) {
    
    Node root = Node.root();

    ///
    List<Node> nodes = [ root ];
    List<Node> tmpNodes = [];
    for(var attribute in attributes.entries) {
      for(var node in nodes) {
        tmpNodes.addAll(
          node.addChildren(attribute)
        );
      }
      nodes = tmpNodes;
      tmpNodes = [];
    }

    /// 查找叶子节点
    final leafNodes = root.findLeafNodes();

    /// 將叶子节点轉為 Sku
    return leafNodes.map(
      (node) => node.toSku()
    ).toList();
  }


}