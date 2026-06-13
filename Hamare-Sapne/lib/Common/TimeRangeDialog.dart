// import 'package:bipf_app/Common/BrandColors.dart';
// import 'package:flutter/material.dart';
//
// class TimeRangeDialog extends StatefulWidget {
//   final TimeOfDay initialStart;
//   final TimeOfDay initialEnd;
//   final Function(TimeOfDay start, TimeOfDay end) onSelected;
//
//   const TimeRangeDialog({
//     required this.initialStart,
//     required this.initialEnd,
//     required this.onSelected,
//   });
//
//   @override
//   State<TimeRangeDialog> createState() => _TimeRangeDialogState();
// }
//
// class _TimeRangeDialogState extends State<TimeRangeDialog> {
//   late TimeOfDay _start;
//   late TimeOfDay _end;
//
//   @override
//   void initState() {
//     super.initState();
//     _start = widget.initialStart;
//     _end = widget.initialEnd;
//   }
//
//   List<int> hours = List.generate(12, (i) => i + 1);
//   List<int> minutes = List.generate(60, (i) => i);
//   List<String> periods = ['AM', 'PM'];
//
//   TimeOfDay _fromParts(int hour, int minute, String period) {
//     if (period == 'PM' && hour != 12) hour += 12;
//     if (period == 'AM' && hour == 12) hour = 0;
//     return TimeOfDay(hour: hour, minute: minute);
//   }
//
//   Map<String, dynamic> _toParts(TimeOfDay time) {
//     int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     String period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return {
//       'hour': hour,
//       'minute': time.minute,
//       'period': period,
//     };
//   }
//
//   TimeOfDay _addOneHour(TimeOfDay time) {
//     final totalMinutes = time.hour * 60 + time.minute + 60;
//     final newHour = (totalMinutes ~/ 60) % 24;
//     final newMinute = totalMinutes % 60;
//     return TimeOfDay(hour: newHour, minute: newMinute);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final startParts = _toParts(_start);
//     final endParts = _toParts(_end);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final maxWidth = constraints.maxWidth > 500 ? 400.0 : double.infinity;
//
//         return Center(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: maxWidth),
//             child: Dialog(
//               insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//               backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "⏰ Select Time Range",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                     _timeSection("Start Time", startParts, isStart: true),
//                     const SizedBox(height: 16),
//                     _timeSection("End Time", endParts, isStart: false),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.red)),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: BrandColors.appColor,
//                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           ),
//                           icon: const Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
//                           label: const Text("OK", style: TextStyle(fontSize: 16, color: Colors.white)),
//                           onPressed: () {
//                             final startMinutes = _start.hour * 60 + _start.minute;
//                             final endMinutes = _end.hour * 60 + _end.minute;
//                             if (endMinutes <= startMinutes) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("End time must be after start time")),
//                               );
//                             } else {
//                               widget.onSelected(_start, _end);
//                               Navigator.pop(context);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _timeSection(String title, Map<String, dynamic> timeParts, {required bool isStart}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _modernDropdown<int>(
//               value: timeParts['hour'],
//               items: hours,
//               onChanged: (val) => setState(() {
//                 if (isStart) {
//                   _start = _fromParts(val!, _start.minute, timeParts['period']);
//                   _end = _addOneHour(_start);
//                 } else {
//                   _end = _fromParts(val!, _end.minute, timeParts['period']);
//                 }
//               }),
//             ),
//             const Text(":", style: TextStyle(fontSize: 18)),
//             _modernDropdown<int>(
//               value: minutes.contains(isStart ? _start.minute : _end.minute)
//                   ? (isStart ? _start.minute : _end.minute)
//                   : 0,
//               items: minutes,
//               onChanged: (val) => setState(() {
//                 if (isStart) {
//                   _start = _fromParts(timeParts['hour'], val!, timeParts['period']);
//                   _end = _addOneHour(_start);
//                 } else {
//                   _end = _fromParts(timeParts['hour'], val!, timeParts['period']);
//                 }
//               }),
//             ),
//             _modernDropdown<String>(
//               value: timeParts['period'],
//               items: periods,
//               onChanged: (val) => setState(() {
//                 if (isStart) {
//                   _start = _fromParts(timeParts['hour'], _start.minute, val!);
//                   _end = _addOneHour(_start);
//                 } else {
//                   _end = _fromParts(timeParts['hour'], _end.minute, val!);
//                 }
//               }),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _modernDropdown<T>({
//     required T value,
//     required List<T> items,
//     required void Function(T?) onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: DropdownButton<T>(
//         value: value,
//         items: items
//             .map((item) => DropdownMenuItem<T>(
//           value: item,
//           child: Text('$item', style: const TextStyle(fontSize: 16)),
//         ))
//             .toList(),
//         onChanged: onChanged,
//         underline: const SizedBox(),
//         isDense: true,
//         icon: const Icon(Icons.keyboard_arrow_down),
//       ),
//     );
//   }
// }
