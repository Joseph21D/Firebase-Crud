import 'package:crud/services/firebase_service.dart';
import 'package:flutter/material.dart';
// import 'package:crud/services/firebase_service.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});
  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController surnameController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    nameController.text = arguments['name'];
    surnameController.text = arguments['surname']; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Update name',
              ),
            ),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(
                hintText: 'Update surname',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  await updatePeople(arguments['uid'], nameController.text, surnameController.text)
                      .then((_) {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}