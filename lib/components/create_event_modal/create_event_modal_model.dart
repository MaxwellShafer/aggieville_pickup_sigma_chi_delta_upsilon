import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'create_event_modal_widget.dart' show CreateEventModalWidget;
import 'package:flutter/material.dart';

class CreateEventModalModel extends FlutterFlowModel<CreateEventModalWidget> {
  ///  Local state fields for this component.

  DateTime? eventDate;

  String eventName = 'Event Name';

  String description = 'event description';

  String? eventLink;

  String? image;

  FFUploadedFile? imageBytes;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_createEventUploadImage = false;
  FFUploadedFile uploadedLocalFile_createEventUploadImage =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for projectName widget.
  FocusNode? projectNameFocusNode;
  TextEditingController? projectNameTextController;
  String? Function(BuildContext, String?)? projectNameTextControllerValidator;
  String? _projectNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Event Name is required';
    }

    return null;
  }

  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  String? _descriptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Description is required';
    }

    return null;
  }

  DateTime? datePicked;
  // State field(s) for clonableURL widget.
  FocusNode? clonableURLFocusNode;
  TextEditingController? clonableURLTextController;
  String? Function(BuildContext, String?)? clonableURLTextControllerValidator;
  // Stores action output result for [Validate Form] action in Button widget.
  bool? validatedForm;
  bool isDataUploading_firebaseUploadMedia = false;
  FFUploadedFile uploadedLocalFile_firebaseUploadMedia =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_firebaseUploadMedia = '';

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  EventsRecord? eventDoc;

  @override
  void initState(BuildContext context) {
    projectNameTextControllerValidator = _projectNameTextControllerValidator;
    descriptionTextControllerValidator = _descriptionTextControllerValidator;
  }

  @override
  void dispose() {
    projectNameFocusNode?.dispose();
    projectNameTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    clonableURLFocusNode?.dispose();
    clonableURLTextController?.dispose();
  }
}
