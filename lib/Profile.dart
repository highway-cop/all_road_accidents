import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'Utils.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = FirebaseAuth.instance.currentUser as User;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  _ProfileState() {
    if (user.displayName != null) {
      nameController.text = user.displayName as String;
    }

    emailController.text = user.email as String;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome (Opcional)',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: false,
            readOnly: true,
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'E-Mail',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              showLoadingOverlay(context);

              try {
                if (nameController.text.isNotEmpty) {
                  await user.updateDisplayName(nameController.text);
                }
              } finally {
                Navigator.of(context).pop();
              }
            },
            child: Text('SALVAR'),
          )
        ],
      ),
    );
  }
}
