import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';

import '../common/styles.dart';

void PrintError(String controller, String method, String message) {
  print(
      'Error -> Controller : $controller, Method : $method\nMessage : $message');
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach(
      // ignore: avoid_print
      (match) => print("***${match.group(0)}***"));
}

String formatDateTime(DateTime? dateTime, {String format = 'dd-MM-yyyy'}) {
  return DateFormat(format).format(dateTime ?? DateTime.now());
}

int daysDifference({required DateTime from, required DateTime to}) {
// get the difference in term of days, and not just a 24h difference
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);

  return to.difference(from).inDays;
}

myAppBar(
    {String? title,
    Color backGroundColor = AppColor.whiteColor,
    List<Widget>? actions,
    BuildContext? context,
    bool goBack = true,
    Widget? leadingIcon,
    Widget? titleWidget,
    bool? isTitleCenter,
    Color? titleTextColor,
    onBacKTap}) {
  return AppBar(
    actions: actions ?? [],
    automaticallyImplyLeading: goBack,
    backgroundColor: backGroundColor,
    centerTitle: isTitleCenter ?? true,
    leadingWidth: (goBack && leadingIcon == null) ? 160.w : 280.w,
    leading: leadingIcon ??
        (goBack
            ? InkWell(
                onTap: () {
                  onBacKTap ?? Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 40.w),
                  child: const SvgViewer(
                    svgPath: 'assets/icons_new/arrow_back.svg',
                    //  height: myContext!.height * 0.03,
                  ),
                ),
              )
            : const IgnorePointer()),
    title: titleWidget ??
        Text(title ?? '',
            style: AppTextStyles.textStyleBoldSubTitleLarge
                .copyWith(color: titleTextColor ?? AppColor.primaryBlueColor)),
  );
}

mySwitch(
    {onTickTap,
    onMessageTap,
    Color? fillColor,
    bool isActive = false,
    Color? checkColor,
    required String message,
    Color? messageColor}) {
  return Row(
    children: [
      SizedBox(
        width: 50.w,
      ),
      Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: fillColor ?? AppColor.whiteColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          onTap: onTickTap,
          child: Icon(
            Icons.check,
            size: 15.0,
            color: isActive
                ? (checkColor ?? Colors.black)
                : fillColor ?? AppColor.whiteColor,
          ),
        ),
      ),
      SizedBox(
        width: 50.w,
      ),
      InkWell(
        onTap: onMessageTap,
        child: Text(
          message,
          style: AppTextStyles.textStyleNormalBodySmall
              .copyWith(color: messageColor ?? AppColor.whiteColor),
        ),
      )
    ],
  );
}

Future<void> showDatePickerDialog(
    {required BuildContext context,
    required Function(DateTime date) onDateSelected,
    required DateTime endDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.year}) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: initialDatePickerMode,
      initialDate: DateTime.now(),
      firstDate: DateTime(1905),
      lastDate: endDate);
  if (picked != null && picked != DateTime.now()) {
    onDateSelected(picked);
  }
}

Future pickDateRange({
  required BuildContext context,
  DateTimeRange? initialRange,
  required Function(DateTimeRange date) onRangeSelect,
}) async {
  DateTime now = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: now,
    end: DateTime(now.year, now.month, now.day + 1),
  );

  DateTimeRange? newDateRange = await showDateRangePicker(
    context: context,
    initialDateRange: initialRange ?? dateRange,
    firstDate: DateTime(2019),
    lastDate: DateTime(2023),
  );

  if (newDateRange != null) {
    onRangeSelect(newDateRange);
  }
}

Future<void> showMyTimePicker(
    {required BuildContext context,
    required Function(dynamic date) onTimeSelected,
    TimePickerEntryMode initialDatePickerMode =
        TimePickerEntryMode.dial}) async {
  final TimeOfDay? picked =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (picked != null) {
    onTimeSelected(picked.format(context));
  }
}

Future<void> showMyMonthPicker(
    {required BuildContext context,
    DateTime? lowerBound,
    DateTime? upperBound,
    required Function(DateTime date) onMonthSelected,
    TimePickerEntryMode initialDatePickerMode =
        TimePickerEntryMode.dial}) async {
  DateTime? result = await showMonthYearPicker(
    context: context,
    initialDate: lowerBound ?? DateTime.now(),
    initialMonthYearPickerMode: MonthYearPickerMode.year,
    firstDate: lowerBound ?? DateTime(1900),
    lastDate: upperBound ?? DateTime(3000),
  );

  if (result != null) {
    onMonthSelected(result);
  }
}

String? propertySizeValidator(String? value) {
  if (value!.isEmpty) {
    return 'Required Property Size';
  } else {
    num val = num.parse(value);
    if (val < 0 || val >= 10000) {
      return 'Size must be between 0 - 10000';
      // }
    }
  }
  // Check if the value contains a decimal point
  int decimalIndex = value.indexOf('.');
  if (decimalIndex != -1) {
    // If the decimal point exists, check the number of digits after it
    String decimalPart = value.substring(decimalIndex + 1);
    if (decimalPart.length > 2) {
      // Return an error message if more than two digits are entered after the decimal point
      return 'Only two digits allowed after the decimal point.';
    }
  }

  return null;
}

String? propertyPriceValidator(String? value) {
  if (value!.isEmpty) {
    return 'Required Property Price';
  }
  // else {
  //   num val = num.parse(value);
  //   if (val < 0 || val >= 10000) {
  //     return 'Size must be between 0 - 10000';
  //     // }
  //   }
  // }
  // Check if the value contains a decimal point
  int decimalIndex = value.indexOf('.');
  if (decimalIndex != -1) {
    // If the decimal point exists, check the number of digits after it
    String decimalPart = value.substring(decimalIndex + 1);
    if (decimalPart.length > 2) {
      // Return an error message if more than two digits are entered after the decimal point
      return 'Only two digits allowed after the decimal point.';
    }
  }

  return null;
}
