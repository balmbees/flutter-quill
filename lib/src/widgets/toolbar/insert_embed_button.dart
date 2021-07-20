import 'dart:developer';
import 'package:flutter/material.dart';

import '../../models/documents/nodes/embed.dart';
import '../controller.dart';
import '../toolbar.dart';
import 'quill_icon_button.dart';

import 'package:moim_flutter/blockit/blockit.dart';
import 'package:moim_flutter/models/models.dart';

class InsertEmbedButton extends StatelessWidget {
  InsertEmbedButton({
    required this.controller,
    required this.icon,
    this.iconSize = kDefaultIconSize,
    this.fillColor,
    required this.type,
    Key? key,
  }) : super(key: key);

  final QuillController controller;
  final IconData icon;
  final double iconSize;
  final Color? fillColor;
  final String type;

  // Dialog for inserting link ,file or user content.
  TextEditingController _textFieldController = TextEditingController(
    text: 'https://www.youtube.com/watch?v=i7OAiqGdY8Y',
  );

  @override
  Widget build(BuildContext context) {
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * kIconButtonFactor,
      icon: Icon(
        icon,
        size: iconSize,
        color: Theme.of(context).iconTheme.color,
      ),
      fillColor: fillColor ?? Theme.of(context).canvasColor,
      onPressed: () {
        log('embed button type: $type');

        // Find the position.
        final index = controller.selection.baseOffset;
        final length = controller.selection.extentOffset - index;

        // Insert (replace text) data in editor.
        switch (type) {
          case 'horizontal':
            controller.replaceText(
              index,
              length,
              BlockEmbed.horizontalRule,
              null,
            );

            break;

          case 'link-preview':
            _displayDialog(context);

            controller.replaceText(
              index,
              length,
              BlockEmbed.linkPreviewRule(
                LinkPreview(
                  title: 'link-preview',
                  url: _textFieldController.text,
                ).toJson(),
              ),
              null,
            );

            break;

          default:
        }
      },
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter url link'),
          content: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(hintText: "write url link"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Insert'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
