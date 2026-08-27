import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/slots_model/slots_list_response.dart';
import '../../../widgets/app_button_widget.dart';
import '../../../widgets/snackbar_widget.dart';

class EditSlotBottomSheetWidget extends StatefulWidget {
  final SlotItem slot;
  final Function(
    SlotItem slot,
    String day,
    String startTime,
    String endTime,
    bool isActive,
  )? onUpdateSlot;

  const EditSlotBottomSheetWidget({
    super.key,
    required this.slot,
    this.onUpdateSlot,
  });

  static Future<void> show(
    BuildContext context, {
    required SlotItem slot,
    Function(
      SlotItem slot,
      String day,
      String startTime,
      String endTime,
      bool isActive,
    )? onUpdateSlot,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditSlotBottomSheetWidget(
        slot: slot,
        onUpdateSlot: onUpdateSlot,
      ),
    );
  }

  @override
  State<EditSlotBottomSheetWidget> createState() =>
      _EditSlotBottomSheetWidgetState();
}

class _EditSlotBottomSheetWidgetState extends State<EditSlotBottomSheetWidget> {
  final List<String> _days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  late String? _selectedDay;
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _selectedDay = _findMatchingDay(widget.slot.dayOfWeek);
    _startTime = _parseTimeOfDay(widget.slot.startTime);
    _endTime = _parseTimeOfDay(widget.slot.endTime);
    _isActive = widget.slot.isActive == true;
  }

  String? _findMatchingDay(String? inputDay) {
    if (inputDay == null || inputDay.isEmpty) return null;
    for (final day in _days) {
      if (day.toLowerCase() == inputDay.trim().toLowerCase()) {
        return day;
      }
    }
    return _days.first;
  }

  TimeOfDay? _parseTimeOfDay(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}
    return null;
  }

  String _formatTimeDisplay(TimeOfDay? time) {
    if (time == null) return '--:-- --';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _formatTimeTo24Hr(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Future<void> _pickTime({required bool isStartTime}) async {
    final initial = (isStartTime ? _startTime : _endTime) ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: AppColor.pureWhite,
              onSurface: AppColor.charcoal,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColor.pureWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              hourMinuteColor: AppColor.orangeTint2,
              hourMinuteTextColor: AppColor.primary,
              dialHandColor: AppColor.primary,
              dialBackgroundColor: AppColor.whiteShade,
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
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _handleSubmit() {
    if (_selectedDay == null || _selectedDay!.isEmpty) {
      appSnackBar(context, AppColor.bright_red, 'Please select a day of week');
      return;
    }

    if (_startTime == null) {
      appSnackBar(context, AppColor.bright_red, 'Please select a start time');
      return;
    }

    if (_endTime == null) {
      appSnackBar(context, AppColor.bright_red, 'Please select an end time');
      return;
    }

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    if (endMinutes <= startMinutes) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'End time must be greater than start time',
      );
      return;
    }

    final startTimeStr = _formatTimeTo24Hr(_startTime!);
    final endTimeStr = _formatTimeTo24Hr(_endTime!);

    Navigator.of(context).pop();
    widget.onUpdateSlot?.call(
      widget.slot,
      _selectedDay!,
      startTimeStr,
      endTimeStr,
      _isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Grey Close/Cross Button at top center
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.charcoal.withValues(alpha: 0.55),
                border: Border.all(
                  color: AppColor.pureWhite.withValues(alpha: 0.3),
                  width: 1.5.r,
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColor.pureWhite,
                size: 20.r,
              ),
            ),
          ),
          12.hS,

          // Bottom Sheet Content Container
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: bottomPadding > 0 ? bottomPadding + 14.h : 22.h,
            ),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Title
                Text(
                  'Edit Time Slot',
                  style: AppFont.style(
                    color: AppColor.charcoal,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.hS,
                Text(
                  'Update operating hours and availability for this slot',
                  style: AppFont.style(
                    color: AppColor.slateGrey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                18.hS,

                // 1. Day of Week Dropdown
                _buildLabel('Day of Week'),
                6.hS,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: AppColor.whiteShade,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColor.border.withValues(alpha: 0.8),
                      width: 1.r,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDay,
                      isExpanded: true,
                      hint: Text(
                        'Select Day',
                        style: AppFont.style(
                          color: AppColor.slateGrey.withValues(alpha: 0.7),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColor.primary,
                        size: 24.r,
                      ),
                      items: _days.map((day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(
                            day,
                            style: AppFont.style(
                              color: AppColor.charcoal,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDay = val;
                        });
                      },
                    ),
                  ),
                ),
                16.hS,

                // 2. Start Time & End Time Row
                Row(
                  children: [
                    // Start Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Start Time'),
                          6.hS,
                          _buildTimePickerTile(
                            time: _startTime,
                            onTap: () => _pickTime(isStartTime: true),
                          ),
                        ],
                      ),
                    ),
                    14.wS,

                    // End Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('End Time'),
                          6.hS,
                          _buildTimePickerTile(
                            time: _endTime,
                            onTap: () => _pickTime(isStartTime: false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                16.hS,

                // 3. Active / Inactive Status Toggle Card
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteShade,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColor.border.withValues(alpha: 0.8),
                      width: 1.r,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isActive
                                  ? AppColor.statusDelivered
                                  : AppColor.slateGrey,
                            ),
                          ),
                          8.wS,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Slot Status',
                                style: AppFont.style(
                                  color: AppColor.charcoal,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              2.hS,
                              Text(
                                _isActive
                                    ? 'Active (Visible for orders)'
                                    : 'Inactive (Hidden)',
                                style: AppFont.style(
                                  color: _isActive
                                      ? AppColor.statusDelivered
                                      : AppColor.slateGrey,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: _isActive,
                        activeTrackColor: AppColor.primary,
                        inactiveTrackColor:
                            AppColor.gray.withValues(alpha: 0.35),
                        onChanged: (val) {
                          setState(() {
                            _isActive = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                24.hS,

                // 4. Update Slot Action Button
                AppButtonWidget(
                  text: 'Update Slot',
                  borderRadius: 16.r,
                  height: 48.h,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Row(
      children: [
        Text(
          label,
          style: AppFont.style(
            color: AppColor.charcoal,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        2.wS,
        Text(
          '*',
          style: AppFont.style(
            color: AppColor.bright_red,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerTile({
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    final hasValue = time != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColor.whiteShade,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColor.border.withValues(alpha: 0.8),
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatTimeDisplay(time),
                style: AppFont.style(
                  color: hasValue
                      ? AppColor.charcoal
                      : AppColor.slateGrey.withValues(alpha: 0.7),
                  fontSize: 13.sp,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.access_time_rounded,
              color: AppColor.primary,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
