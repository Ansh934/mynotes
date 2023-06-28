import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/show_generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are you sure you want to delete this item?",
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then((value) => value ?? false);
}
