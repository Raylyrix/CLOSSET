import 'package:CLOSSET/models/manufacturer.dart';
import 'package:CLOSSET/models/user.dart';
import 'package:CLOSSET/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

class ManufacturerRegistration extends StatefulWidget {
  int userId;
  ManufacturerRegistration({Key? key, required this.userId}) : super(key: key);

  @override
  State<ManufacturerRegistration> createState() =>
      _ManufacturerRegistrationState();
}

List<String> allClothTypes = [
  'Shirt',
  'Trousers',
  'Suits',
  'Dresses',
  'Skirts',
  'Blouses',
  'T-shirts',
  'Jeans',
  'Jackets',
  'Coats',
  'Sweaters',
  'Cardigans',
  'Hoodies',
  'Shorts',
  'Underwear',
  'Socks',
  'Swimwear',
  'Sportswear',
  'Sleepwear',
  'Loungewear',
  'Workwear',
  'Uniforms',
];

List<String> allMaterialTypes = [
  'Cotton',
  'Polyester',
  'Nylon',
  'Acrylic',
  'Rayon',
  'Spandex',
  'Linen',
  'Wool',
  'Leather',
  'Fur',
  'Silk',
  'Denim',
  'Velvet',
  'Corduroy',
  'Tweed',
  'Chiffon',
  'Georgette',
  'Crepe',
  'Satin',
  'Organza',
  'Tulle',
  'Lace',
  'Mesh',
  'Knit',
  'Jersey',
  'Terry',
  'Fleece',
  'Flannel',
  'Poplin',
  'Twill',
  'Gabardine',
  'Broadcloth',
  'Muslin',
  'Voile',
  'Batiste',
  'Calico',
  'Canvas',
  'Chambray',
  'Cheesecloth',
  'Chenille',
  'Chino',
  'Chintz',
  'Corduroy',
  'Damask',
  'Faille',
  'Gauze',
  'Herringbone',
  'Jacquard',
  'Moire',
  'Oxford',
  'Pique',
  'Plissé',
  'Poplin',
  'Sateen',
  'Seersucker',
  'Taffeta',
  'Tweed',
  'Twill',
  'Velour',
  'Velvet',
  'Voile',
  'Worsted',
  'Bouclé',
  'Burlap',
  'Cambric',
  'Challis',
  'Crêpe',
  'Duck',
  'Faille',
  'Flannel',
  'Gingham',
  'Houndstooth',
  'Madras',
  'Moire',
  'Muslin',
  'Percale',
  'Poplin',
  'Sateen',
  'Seersucker',
  'Taffeta',
  'Tweed',
  'Twill',
  'Velour',
  'Velvet',
  'Voile',
  'Worsted',
  'Bouclé',
  'Burlap',
  'Cambric',
  'Challis',
  'Crêpe',
  'Duck',
  'Faille',
];

class _ManufacturerRegistrationState extends State<ManufacturerRegistration> {
  final TextEditingController _certificationController =
      TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> _selectedClothTypes = [];
  final List<String> _selectedMaterialTypes = [];
  User? user;
  @override
  createMF() async {
    final mf = await Manufacturer.createManufacturer(
      Manufacturer(
        id: 0,
        userId: widget.userId,
        certification: _certificationController.text,
        bankAccount: _bankAccountController.text,
        capacity: int.parse(_capacityController.text),
        // address: _addressController.text,
        clothTypes: _selectedClothTypes.join(','),
        materialTypes: _selectedMaterialTypes.join(','),
      ),
    );
  }

  // List
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manufacturer Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
            children: [
              const SizedBox(height: 20),
              TextFieldInput(
                textInputType: TextInputType.number,
                textEditingController: _certificationController,
                hintText: "Certification",
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                textInputType: TextInputType.number,
                textEditingController: _bankAccountController,
                hintText: "Bank Account",
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                textInputType: TextInputType.number,
                textEditingController: _capacityController,
                hintText: "Capacity",
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                textInputType: TextInputType.streetAddress,
                textEditingController: _addressController,
                hintText: "Address",
              ),
              const SizedBox(height: 16),
              const Text('Cloth Types'),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Wrap(
                    // runSpacing:
                    spacing: 4,
                    children: allClothTypes
                        .map((e) => FilterChip(
                              label: Text(e),
                              selected: _selectedClothTypes.contains(e),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedClothTypes.add(e);
                                  } else {
                                    _selectedClothTypes.remove(e);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Material Types'),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 4,
                    children: allMaterialTypes
                        .map((e) => FilterChip(
                              label: Text(e),
                              selected: _selectedMaterialTypes.contains(e),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedMaterialTypes.add(e);
                                  } else {
                                    _selectedMaterialTypes.remove(e);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  createMF();
                },
                child: const Text('Submit'),
              )
            ],
          )),
        ),
      ),
    );
  }
}
