import 'package:app/l10n/app_localizations.dart';
import 'package:app/models/provider_details.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const Schedule({super.key, required this.data, required this.formKey});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<String> selectedDays = [];
  final Map<String, String> allDays = {
    "sun": "sunday",
    "mon": "monday",
    "tue": "tuesday",
    "wed": "wednesday",
    "thu": "thursday",
    "fri": "friday",
    "sat": "saturday",
  };

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Helper to get localized day names for the UI
  String _getLocalizedDay(String dayKey, AppLocalizations l10) {
    // ... (no changes in this method)
    switch (dayKey) {
      case "mon":
        return l10.monday;
      case "tue":
        return l10.tuesday;
      case "wed":
        return l10.wednesday;
      case "thu":
        return l10.thursday;
      case "fri":
        return l10.friday;
      case "sat":
        return l10.saturday;
      case "sun":
        return l10.sunday;
      default:
        return dayKey;
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _updateScheduleDirectly() {
    widget.data.availabilitySchedule?.clear();

    if (selectedDays.isNotEmpty && _startTime != null && _endTime != null) {
      final startInMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endInMinutes = _endTime!.hour * 60 + _endTime!.minute;

      if (endInMinutes > startInMinutes) {
        final timeRange =
            '${_formatTimeOfDay(_startTime!)} - ${_formatTimeOfDay(_endTime!)}';

        for (String dayKey in selectedDays) {
          final fullDayName = allDays[dayKey]!;
          widget.data.availabilitySchedule?[fullDayName] = [timeRange];
        }
      }
    }

  }

  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStartTime ? _startTime : _endTime) ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialBackgroundColor: Colors.green.withOpacity(0.1),
              dialHandColor: Colors.green,
              entryModeIconColor: Colors.green,
              hourMinuteTextColor: Colors.green,
              hourMinuteColor: Colors.green.withOpacity(0.1),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.green),
              ),
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _startController.text = _formatTimeOfDay(picked);
        } else {
          _endTime = picked;
          _endController.text = _formatTimeOfDay(picked);
        }
        _updateScheduleDirectly();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: d.width10,
          vertical: d.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10.setYourAvailability,
              style: TextStyle(fontSize: d.font18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: d.height10),
            Text(
              l10.choosethedaysandtimeswhenyoureavailabletoprovideservices,
              style: TextStyle(fontSize: d.font16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: d.height10),

            FormField<List<String>>(
              initialValue: selectedDays,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10.pleaseSelectADay;
                }
                return null;
              },
              builder: (FormFieldState<List<String>> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: allDays.keys.map((dayKey) {
                          final isSelected = selectedDays.contains(dayKey);
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: d.width10 / 2,
                              vertical: d.width10 / 2,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? const Color.fromARGB(255, 50, 116, 52)
                                    : Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedDays.remove(dayKey);
                                  } else {
                                    selectedDays.add(dayKey);
                                  }
                                  field.didChange(selectedDays);
                                  // **** 3. CALL THE UPDATE METHOD AFTER CHANGING A DAY ****
                                  _updateScheduleDirectly();
                                });
                              },
                              child: Text(
                                _getLocalizedDay(dayKey, l10),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: d.font16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: d.height20),
            if (selectedDays.isNotEmpty) ...[
              // ... (The rest of the TextFormFields remain the same, but the final button is removed)
              Text(
                l10.from,
                style: TextStyle(
                  fontSize: d.font16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: d.height10),
              TextFormField(
                controller: _startController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10.chooseTime,
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10.pleaseSelectATime;
                  }
                  return null;
                },
                onTap: () => _pickTime(context, true),
              ),
              SizedBox(height: d.height20),
              Text(
                l10.to,
                style: TextStyle(
                  fontSize: d.font16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: d.height10),
              TextFormField(
                controller: _endController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10.chooseTime,
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10.pleaseSelectATime;
                  }
                  if (_startTime != null && _endTime != null) {
                    final startInMinutes =
                        _startTime!.hour * 60 + _startTime!.minute;
                    final endInMinutes = _endTime!.hour * 60 + _endTime!.minute;
                    if (endInMinutes <= startInMinutes) {
                      return l10.endTimeMustBeAfterStartTime;
                    }
                  }
                  return null;
                },
                onTap: () => _pickTime(context, false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
