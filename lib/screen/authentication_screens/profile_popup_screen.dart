import 'package:flutter/material.dart';

import '../../helpers/loading/loading_screen.dart';
import '../../services/auth/auth_services.dart';

class ProfilePopScreen extends StatelessWidget {
  const ProfilePopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        // height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                LoadingScreen()
                    .show(context: context, text: 'Please wait for a moment');
                await AuthService.firebase().updatePhotoUrl().whenComplete(() {
                  Navigator.pop(context);
                  LoadingScreen().hide();
                });
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.insert_photo_outlined,
                              size: 40, color: Colors.black))),
                  const SizedBox(width: 10),
                  const Expanded(
                    flex: 3,
                    child: Text('Update from Gallery',
                        style: TextStyle(fontSize: 22, color: Colors.black)),
                  ),
                ]),
              ),
            ),
            GestureDetector(
              onTap: () async => await AuthService.firebase()
                  .deletePhotoUrl()
                  .whenComplete(() => Navigator.pop(context)),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.delete_outline_outlined,
                              size: 40, color: Colors.red))),
                  const SizedBox(width: 10),
                  const Expanded(
                    flex: 3,
                    child: Text('Delete current pic',
                        style: TextStyle(fontSize: 22, color: Colors.red)),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
