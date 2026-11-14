import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/app_data.dart';
import '../../data/models.dart';
import '../../services/db_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/dashed_border.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';

/// Add a new car, or edit [car] when it is given.
class AdminAddCarScreen extends StatefulWidget {
  const AdminAddCarScreen({super.key, this.car, this.onBack});

  final Car? car;

  /// Called by the back arrow. Falls back to Navigator.maybePop when null.
  final VoidCallback? onBack;

  @override
  State<AdminAddCarScreen> createState() => _AdminAddCarScreenState();
}

class _AdminAddCarScreenState extends State<AdminAddCarScreen> {
  static const int _maxImages = 3;
  // Firestore documents are limited to 1 MB; photos are stored inside it.
  static const int _maxImageChars = 800000;

  late final Car? _editing = widget.car;
  late final _name = TextEditingController(text: _editing?.name ?? '');
  late final _price = TextEditingController(
      text: _editing == null ? '' : _editing!.price.toString());
  late final _engine = TextEditingController(text: _editing?.engine ?? '');
  late final _horsepower =
      TextEditingController(text: _editing?.horsepower ?? '');
  late final _mileage = TextEditingController(text: _editing?.mileage ?? '');
  late final _description =
      TextEditingController(text: _editing?.description ?? '');
  late final _features =
      TextEditingController(text: (_editing?.features ?? const []).join(', '));
  late String? _brand = _editing?.brand;
  // Only keep stored values that exist in the dropdown lists.
  late String? _category = _only(_editing?.category, AppData.categoryNames);
  late String? _fuel = _only(_editing?.fuel, AppData.fuelTypes);
  late String? _transmission =
      _only(_editing?.transmission, AppData.transmissions);
  late String? _seats = _only(_editing?.seats.toString(), AppData.seatOptions);
  late int? _colorIndex = _editing?.colorIndex;
  late bool _featured = _editing?.featured ?? false;
  late final List<String> _images = [...?_editing?.images];
  bool _saving = false;

  static String? _only(String? v, List<String> options) =>
      v != null && options.contains(v) ? v : null;

  @override
  void dispose() {
    for (final c in [
      _name,
      _price,
      _engine,
      _horsepower,
      _mileage,
      _description,
      _features,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickImage() async {
    if (_images.length >= _maxImages) {
      _toast('Maximum $_maxImages photos');
      return;
    }
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 60,
      );
      if (file == null) return;
      final encoded = base64Encode(await file.readAsBytes());
      final total =
          _images.fold<int>(0, (n, e) => n + e.length) + encoded.length;
      if (total > _maxImageChars) {
        _toast('Photo is too large. Choose a smaller image.');
        return;
      }
      setState(() => _images.add(encoded));
    } catch (e) {
      _toast('Could not select photo: $e');
    }
  }

  Future<void> _submit() async {
    if (_saving) return;
    final name = _name.text.trim();
    final price = int.tryParse(_price.text.replaceAll(',', '').trim());
    if (name.isEmpty || _brand == null) {
      _toast('Enter a car name and select a brand.');
      return;
    }
    if (price == null || price <= 0) {
      _toast('Enter a valid price using digits only, such as 7500000.');
      return;
    }
    final old = _editing;
    final car = Car(
      id: old?.id ?? '',
      name: name,
      brand: _brand!,
      price: price,
      currency: old?.currency ?? '₹',
      rating: old?.rating ?? 4.5,
      reviews: old?.reviews ?? 0,
      fuel: _fuel ?? 'Petrol',
      transmission: _transmission ?? 'Automatic',
      category: _category ?? 'Sedan',
      seats: int.tryParse(_seats ?? '') ?? 5,
      colorIndex: _colorIndex,
      engine: _engine.text.trim(),
      horsepower: _horsepower.text.trim(),
      mileage: _mileage.text.trim(),
      acceleration: old?.acceleration ?? '',
      topSpeed: old?.topSpeed ?? '',
      description: _description.text.trim(),
      features: [
        for (final f in _features.text.split(','))
          if (f.trim().isNotEmpty) f.trim(),
      ],
      imageAsset: old?.imageAsset,
      images: _images,
      featured: _featured,
      createdAt: old?.createdAt,
    );
    setState(() => _saving = true);
    try {
      if (old == null) {
        await DbService.instance.addCar(car);
      } else {
        await DbService.instance.updateCar(car);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast('Could not save car: $e');
      return;
    }
    if (!mounted) return;
    _toast(old == null ? '$name was added.' : '$name was updated.');
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brands = {
      ...AppData.brands,
      if (_brand != null) _brand!,
    }.toList()
      ..sort();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  Expanded(
                    child: Text(
                      _editing == null ? 'Add New Car' : 'Edit Car',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
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
                    const Text('Upload Images (max 3)',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var i = 0; i < _maxImages; i++) ...[
                          Expanded(
                            child: i < _images.length
                                ? _PhotoTile(
                                    data: _images[i],
                                    onRemove: () =>
                                        setState(() => _images.removeAt(i)),
                                  )
                                : _UploadTile(onTap: _pickImage),
                          ),
                          if (i != _maxImages - 1) const SizedBox(width: 12),
                        ],
                      ],
                    ),
                    if (_editing != null &&
                        _images.isEmpty &&
                        _editing!.imageAsset != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'This car uses its default photo. Add a new photo to replace it.',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
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
                            items: brands,
                            value: _brand,
                            onChanged: (v) => setState(() => _brand = v),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedField(
                            label: 'Price (₹)',
                            hint: 'e.g., 7500000',
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
                            label: 'Category',
                            hint: 'Select Category',
                            items: AppData.categoryNames,
                            value: _category,
                            onChanged: (v) => setState(() => _category = v),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedDropdown(
                            label: 'Seats',
                            hint: 'Select Seats',
                            items: AppData.seatOptions,
                            value: _seats,
                            onChanged: (v) => setState(() => _seats = v),
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
                            items: AppData.fuelTypes,
                            value: _fuel,
                            onChanged: (v) => setState(() => _fuel = v),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedDropdown(
                            label: 'Transmission',
                            hint: 'Select Transmission',
                            items: AppData.transmissions,
                            value: _transmission,
                            onChanged: (v) => setState(() => _transmission = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: OutlinedField(
                            label: 'Engine',
                            hint: 'e.g., Electric',
                            controller: _engine,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedField(
                            label: 'Horsepower',
                            hint: 'e.g., 400 HP',
                            controller: _horsepower,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    OutlinedField(
                      label: 'Mileage / Range',
                      hint: 'e.g., 12 km/l',
                      controller: _mileage,
                    ),
                    const SizedBox(height: 14),
                    const Text('Colour', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (var i = 0; i < AppData.filterColors.length; i++)
                          GestureDetector(
                            onTap: () => setState(() =>
                                _colorIndex = _colorIndex == i ? null : i),
                            child: Container(
                              width: 38,
                              height: 38,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppData.filterColors[i],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _colorIndex == i
                                      ? Colors.black
                                      : const Color(0xFFD0D0D4),
                                  width: _colorIndex == i ? 3 : 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    OutlinedField(
                      label: 'Features (comma separated)',
                      hint: 'Autopilot, Premium Audio, Glass Roof',
                      controller: _features,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    OutlinedField(
                      label: 'Description',
                      hint: 'Enter description...',
                      controller: _description,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show in Featured Cars'),
                      value: _featured,
                      activeThumbColor: Colors.black,
                      onChanged: (v) => setState(() => _featured = v),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: _saving
                          ? 'Saving...'
                          : (_editing == null ? 'Submit Car' : 'Save Changes'),
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
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.data, required this.onRemove});
  final String data;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CarImage(asset: data, radius: 18),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
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
