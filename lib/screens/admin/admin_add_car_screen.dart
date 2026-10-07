import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widgets/dashed_border.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';

class AdminAddCarScreen extends StatefulWidget {
  const AdminAddCarScreen({super.key, this.onBack});

  /// Called by the back arrow. Falls back to Navigator.maybePop when null.
  final VoidCallback? onBack;

  @override
  State<AdminAddCarScreen> createState() => _AdminAddCarScreenState();
}

class _AdminAddCarScreenState extends State<AdminAddCarScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _engine = TextEditingController();
  final _description = TextEditingController();
  String? _brand;
  String? _fuel;
  String? _transmission;

  @override
  void dispose() {
    for (final c in [_name, _price, _engine, _description]) {
      c.dispose();
    }
    super.dispose();
  }

  void _pickImage(int slot) {
    // TODO: wire up the image_picker package here:
    //   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add image $slot (image_picker not wired yet)')),
    );
  }

  void _submit() {
    if (_name.text.trim().isEmpty || _brand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a car name and select a brand')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_name.text.trim()} submitted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE3E3E6))),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed:
                      widget.onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.chevron_left, size: 36),
                ),
                const Expanded(
                  child: Text(
                    'Add New Car',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Upload Images', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (var i = 1; i <= 3; i++) ...[
                        Expanded(child: _UploadTile(onTap: () => _pickImage(i))),
                        if (i != 3) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedField(
                    label: 'Car Name',
                    hint: 'e.g., Tesla Model S',
                    controller: _name,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: OutlinedDropdown(
                          label: 'Brand',
                          hint: 'Select Brand',
                          items: MockData.brands,
                          value: _brand,
                          onChanged: (v) => setState(() => _brand = v),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: OutlinedField(
                          label: 'Price',
                          hint: r'$0.00',
                          controller: _price,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: OutlinedDropdown(
                          label: 'Fuel Type',
                          hint: 'Select Fuel Type',
                          items: MockData.fuelTypes,
                          value: _fuel,
                          onChanged: (v) => setState(() => _fuel = v),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: OutlinedField(
                          label: 'Engine',
                          hint: 'e.g., Electric',
                          controller: _engine,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedDropdown(
                          label: 'Transmission',
                          hint: 'Select Transmission',
                          items: MockData.transmissions,
                          value: _transmission,
                          onChanged: (v) => setState(() => _transmission = v),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  OutlinedField(
                    label: 'Description',
                    hint: 'Enter description...',
                    controller: _description,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'Submit Car',
                    onPressed: _submit,
                    height: 56,
                    radius: 14,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: const DashedRRectPainter(),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F4),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera, size: 30, color: Color(0xFF8E8E93)),
                SizedBox(height: 6),
                Text('Add Image', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
