import 'package:CLOSSET/models/designer.dart';
import 'package:CLOSSET/providers/designer_provider.dart';
import 'package:CLOSSET/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesingerRegistrationPage extends StatefulWidget {
  const DesingerRegistrationPage({Key? key}) : super(key: key);

  @override
  State<DesingerRegistrationPage> createState() =>
      _DesingerRegistrationPageState();
}

class _DesingerRegistrationPageState extends State<DesingerRegistrationPage> {
  TextEditingController brandNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desinger Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                decoration: const InputDecoration(
                  labelText: 'Brand Name',
                ),
                controller: brandNameController),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                const Text('I agree to the terms and conditions'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                final userId =
                    Provider.of<UserProvider>(context, listen: false).user.id;
                Designer designer = Designer(
                    id: 0, userID: userId, brandName: brandNameController.text);
                Designer.createDesinger(designer).catchError((error) {
                  print('Error: $error');
                }).then((value) {
                  Provider.of<DesignerProvider>(context).setDesigner(value);
                });
              },
              child: const Text('Register'),
            ),
          ],
        )),
      ),
    );
  }
}
