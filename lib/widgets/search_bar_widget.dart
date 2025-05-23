import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback? onQRPressed;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchPressed;

  const SearchBarWidget({
    this.hintText = 'Search Something...',
    this.onQRPressed,
    this.onChanged,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onQRPressed,
          child: const Icon(
            Icons.qr_code_scanner,
            size: 29,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onSearchPressed,
                  child: Icon(Icons.search, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 