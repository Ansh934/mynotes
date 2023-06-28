import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/show_generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: "An error occurred",
    content: text,
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
