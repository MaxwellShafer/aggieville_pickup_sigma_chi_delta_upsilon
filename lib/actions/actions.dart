import '/backend/backend.dart';
import 'package:flutter/material.dart';

Future createUserRequest(BuildContext context) async {
  await queryUserRequestsRecordOnce();
}
