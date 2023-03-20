import 'package:kroniker_flutter/utils/page_model.dart';

import '/auth/auth_util.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewCharacterModel extends PageModel {
  ///  State fields for stateful widgets in this page.

  TextEditingController? nameController;
  TextEditingController? descriptionController;
  TextEditingController? systemController;
  TextEditingController? sessionNumberController;
  TextEditingController? imageUrlController;


  // // State field(s) for TextField widget.
  // TextEditingController? emailTextController;
  // String? Function(BuildContext, String?)? emailTextControllerValidator;
  // TextEditingController? passwordTextController;
  // late bool passwordVisibility;
  // String? Function(BuildContext, String?)? passwordTextControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    nameController?.dispose();
    descriptionController?.dispose();
    systemController?.dispose();
    sessionNumberController?.dispose();
    imageUrlController?.dispose();
  }

  /// Additional helper methods are added here.
}
