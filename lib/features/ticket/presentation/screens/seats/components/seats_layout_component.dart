import 'package:flutter/material.dart';

import '../../../../../../widget/widget.dart';

class SeatLayoutComponent extends StatefulWidget {
  final Function(List<String>)? onSelected;
  const SeatLayoutComponent({super.key, this.onSelected});

  @override
  State<SeatLayoutComponent> createState() => _SeatLayoutComponentState();
}

class _SeatLayoutComponentState extends State<SeatLayoutComponent> {
  final List<String> _selectedSeats = [];
  final List<String> _disabledSeats = [
    'I1',
    'H1',
    'G1',
    //
    'I2',
    'F2',
    'E2',
    'D2',
    'C2',
    'B2',
    'A2',
    //
    'I3',
    'G3',
    'F3',
    'E3',
    'D3',
    'C3',
    'B3',
    'A3',
    //
    'I4',
    //
    'I5',
    'H5',
    'G5',
    'F5',
    'E5',
    'D5',
    'C5',
    'A5',
    //
  ];

  final List<String> _hiddenSeats = [
    'F1',
    'E1',
    'D1',
    'C1',
    'B1',
    'A1',
    //
    'H4',
    'G4',
    'F4',
    'E4',
    'D4',
    'C4',
    'B4',
    'A4',
    //
    'H12',
    'G12',
    'F12',
    'E12',
    'D12',
    'C12',
    'B12',
    'A12',
    //
    'F15',
    'E15',
    'D15',
    'C15',
    'B15',
    'A15',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        // Grid kursi
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var row in 'IHGFEDCBA'.split('')) // Baris A-I
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var col = 1; col <= 15; col++) // Kolom 1-15
                      SeatBox(
                        label: '$row$col',
                        isSelected: _selectedSeats.contains('$row$col'),
                        isDisabled: _disabledSeats.contains('$row$col'),
                        isHidden: _hiddenSeats.contains('$row$col'),
                        onTap: (seat) {
                          setState(() {
                            if (_selectedSeats.contains(seat)) {
                              _selectedSeats.remove(seat);
                            } else {
                              _selectedSeats.add(seat);
                            }

                            if (widget.onSelected != null) {
                              widget.onSelected!(_selectedSeats);
                            }
                          });
                        },
                      ),
                  ],
                ),
              const SizedBox(height: 40),
              const AppSvg('screen'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SeatBox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDisabled;
  final bool isHidden;
  final Function(String) onTap;

  const SeatBox({
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.isHidden,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double size = 30;
    if (isHidden) {
      return Container(
          margin: const EdgeInsets.all(2), width: size, height: size);
    }

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              onTap(label);
            },
      child: Container(
        margin: const EdgeInsets.all(2),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDisabled
              ? const Color(0xFF2F3436)
              : isSelected
                  ? const Color(0xFFB3FE4B)
                  : const Color(0xFF29A1FD),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            isDisabled ? '' : label,
            style: TextStyle(
              fontSize: 9,
              color: !isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
