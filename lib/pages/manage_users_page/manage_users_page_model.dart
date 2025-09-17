import '/flutter_flow/flutter_flow_util.dart';
import 'manage_users_page_widget.dart' show ManageUsersPageWidget;
import 'package:flutter/material.dart';

class ManageUsersPageModel extends FlutterFlowModel<ManageUsersPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
