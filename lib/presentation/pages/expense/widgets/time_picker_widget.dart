import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerWidget({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectTime(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Time',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          selectedTime.format(context),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer, // Change this to your desired color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      onTimeSelected(picked);
    }
  }
}
