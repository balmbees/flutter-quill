import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:path_provider/path_provider.dart';

typedef DemoContentBuilder = Widget Function(
    BuildContext context, QuillController? controller);

List<Map<String, dynamic>> convertFromBlockToQuill(String result) {
  // Convert format from moim block to quill delta.
  var contentList = jsonDecode(result);
  var convertedContentList = <Map<String, dynamic>>[];

  for (var content in contentList) {
    if (content['type'] == 'text') {
      if (content['content'] == '' || content['content'] == null) {
        content['content'] = '\n';
      }

      var item = {
        'insert': content['content'],
      };

      convertedContentList.add(item);
    } else {
      convertedContentList.add(
        {
          'insert': {
            content['type'] as String: content,
          },
        },
      );
    }
  }

  convertedContentList.add(
    {
      "insert": "\n",
    },
  );

  for (var content in convertedContentList) {
    log('convertedContent: $content');
  }

  return convertedContentList;
}

// Common scaffold for all examples.
class DemoScaffold extends StatefulWidget {
  const DemoScaffold({
    required this.documentFilename,
    required this.builder,
    this.actions,
    this.showToolbar = true,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  /// Filename of the document to load into the editor.
  final String documentFilename;
  final DemoContentBuilder builder;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showToolbar;

  @override
  _DemoScaffoldState createState() => _DemoScaffoldState();
}

class _DemoScaffoldState extends State<DemoScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  QuillController? _controller;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null && !_loading) {
      _loading = true;
      _loadFromAssets();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result =
          await rootBundle.loadString('assets/${widget.documentFilename}');

      final doc = Document.fromJson(
        convertFromBlockToQuill(result),
      );

      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
        _loading = false;
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
        _loading = false;
      });
    }
  }

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    return await FilesystemPicker.open(
      context: context,
      rootDirectory: await getApplicationDocumentsDirectory(),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actions ?? <Widget>[];
    var toolbar = QuillToolbar.basic(controller: _controller!);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.grey.shade800,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: _loading || !widget.showToolbar ? null : toolbar,
        actions: actions,
      ),
      floatingActionButton: widget.floatingActionButton,
      body: _loading
          ? const Center(child: Text('Loading...'))
          : widget.builder(context, _controller),
    );
  }
}
