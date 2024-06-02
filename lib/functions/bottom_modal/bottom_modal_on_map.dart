import 'package:flutter/material.dart';

void bottomModalOnMap(BuildContext context) {
  showBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Media'),
            onTap: () {},
          ),
        ],
      );
    },
  );
}
