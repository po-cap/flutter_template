

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:template/common/index.dart';

class BarItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const BarItemWidget({
    super.key, 
    required this.title, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.scheme.surfaceContainer,
            width: 2
          )
        )
      ),
      child: <Widget>[
        TextWidget.h4(title),
        
        <Widget>[
          TextWidget.body(
            value,
            overflow: TextOverflow.ellipsis,
            color: context.colors.scheme.primary.withValues(alpha: 0.8),
          ),
          Icon(Icons.chevron_right)
        ].toRow()
      ]
      .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ).paddingBottom(AppSpace.listItem * 2);
  }
}