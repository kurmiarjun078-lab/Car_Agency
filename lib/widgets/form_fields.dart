import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Login screen field: rounded box, leading icon, small label over the value.
class LoginField extends StatelessWidget {
  const LoginField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.hintColor = const Color(0xFF9A9CA3),
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFA9A9AE)),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: const Color(0xFFA0A3AE)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF6E7077)),
                ),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 4),
                    hintText: hint,
                    hintStyle: TextStyle(fontSize: 18, color: hintColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Register screen field: grey label above a white pill with soft shadow.
class PillTextField extends StatefulWidget {
  const PillTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;

  @override
  State<PillTextField> createState() => _PillTextFieldState();
}

class _PillTextFieldState extends State<PillTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 15, color: Color(0xFF8E8E93)),
          ),
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.isPassword && _hidden,
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: const TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
              ),
              if (widget.isPassword)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _hidden = !_hidden),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF6E6E73),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Admin form field: label above, thin grey outline.
class OutlinedField extends StatelessWidget {
  const OutlinedField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.prefix,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? prefix;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 17, color: Colors.black)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 17, color: Color(0xFF9B9B9F)),
            prefixIcon: prefix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Text(
                      prefix!,
                      style: const TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.black, width: 1.4),
            ),
            border: border,
          ),
        ),
      ],
    );
  }
}

/// Admin dropdown: label above, outlined box with chevron.
class OutlinedDropdown extends StatelessWidget {
  const OutlinedDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 17, color: Colors.black)),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              items: [
                for (final i in items)
                  DropdownMenuItem(value: i, child: Text(i)),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Filter sheet dropdown: white card, small label over "Select ...".
class DropdownCard extends StatelessWidget {
  const DropdownCard({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              isDense: true,
              value: value,
              hint: Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 19, color: Colors.black),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, size: 30),
              style: const TextStyle(fontSize: 19, color: Colors.black),
              items: [
                for (final i in items)
                  DropdownMenuItem(value: i, child: Text(i)),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey rounded search box used on Browse, Listings and Admin Customers.
class SearchPill extends StatelessWidget {
  const SearchPill({
    super.key,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
    this.color = AppColors.searchGrey,
    this.radius = 28,
    this.height = 52,
    this.shadow = false,
    this.hintColor = const Color(0xFF6B6B70),
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Color color;
  final double radius;
  final double height;
  final bool shadow;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ? AppShadows.soft : null,
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 26, color: hintColor),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 17),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 17, color: hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
